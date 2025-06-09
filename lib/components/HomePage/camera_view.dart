import 'dart:io';

import 'package:camera/camera.dart';
import 'package:camera_android/camera_android.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_commons/google_mlkit_commons.dart';

class CameraView extends StatefulWidget {
  CameraView({
    Key? key,
    required this.customPaint,
    required this.onImage,
    required this.enableTakePicture,
    this.onCameraFeedReady,
    this.onDetectorViewModeChanged,
    this.onCameraLensDirectionChanged,
    this.initialCameraLensDirection = CameraLensDirection.back,
  }) : super(key: key);

  final bool enableTakePicture;
  final CustomPaint? customPaint;
  final Function(InputImage inputImage) onImage;
  final VoidCallback? onCameraFeedReady;
  final VoidCallback? onDetectorViewModeChanged;
  final Function(CameraLensDirection direction)? onCameraLensDirectionChanged;
  final CameraLensDirection initialCameraLensDirection;

  @override
  State<CameraView> createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  static List<CameraDescription> _cameras = [];
  CameraController? _controller;
  int _cameraIndex = -1;
  bool _changingCameraLens = false;

  @override
  void initState() {
    super.initState();

    _initialize();
  }

  void _initialize() async {
    if (_cameras.isEmpty) {
      _cameras = await availableCameras();
    }
    for (var i = 0; i < _cameras.length; i++) {
      if (_cameras[i].lensDirection == widget.initialCameraLensDirection) {
        _cameraIndex = i;
        break;
      }
    }
    if (_cameraIndex != -1) {
      _startLiveFeed();
    }
  }

  @override
  void dispose() {
    _stopLiveFeed();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _liveFeedBody(),
          if (widget.enableTakePicture)
            Positioned(
              bottom: 128,
              left: 10,
              right: 10,
              child: ShutterButton(onPressed: () async {}),
            ),
        ],
      ),
    );
  }

  Widget _liveFeedBody() {
    if (_cameras.isEmpty) return Container();
    if (_controller == null) return Container();
    if (_controller?.value.isInitialized == false) return Container();
    return ColoredBox(
      color: Colors.black,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Center(
            child:
                _changingCameraLens
                    ? Center(child: const Text('Changing camera lens'))
                    : CameraPreview(_controller!, child: widget.customPaint),
          ),
        ],
      ),
    );
  }

  Future _startLiveFeed() async {
    final camera = _cameras[_cameraIndex];
    _controller = CameraController(
      camera,
      // Set to ResolutionPreset.high. Do NOT set it to ResolutionPreset.max because for some phones does NOT work.
      ResolutionPreset.high,
      enableAudio: false,
      imageFormatGroup:
          Platform.isAndroid
              ? ImageFormatGroup.nv21
              : ImageFormatGroup.bgra8888,
    );
    _controller?.initialize().then((_) {
      if (!mounted) {
        return;
      }

      _controller?.startImageStream(_processCameraImage).then((value) {
        if (widget.onCameraFeedReady != null) {
          widget.onCameraFeedReady!();
        }
        if (widget.onCameraLensDirectionChanged != null) {
          widget.onCameraLensDirectionChanged!(camera.lensDirection);
        }
      });
      setState(() {});
    });
  }

  Future _stopLiveFeed() async {
    await _controller?.stopImageStream();
    await _controller?.dispose();
    _controller = null;
  }

  void _processCameraImage(CameraImage image) {
    final inputImage = _inputImageFromCameraImage(image);
    if (inputImage == null) return;
    widget.onImage(inputImage);
  }

  final _orientations = {
    DeviceOrientation.portraitUp: 0,
    DeviceOrientation.landscapeLeft: 90,
    DeviceOrientation.portraitDown: 180,
    DeviceOrientation.landscapeRight: 270,
  };

  InputImage? _inputImageFromCameraImage(CameraImage image) {
    if (_controller == null) return null;

    // get image rotation
    // it is used in android to convert the InputImage from Dart to Java: https://github.com/flutter-ml/google_ml_kit_flutter/blob/master/packages/google_mlkit_commons/android/src/main/java/com/google_mlkit_commons/InputImageConverter.java
    // `rotation` is not used in iOS to convert the InputImage from Dart to Obj-C: https://github.com/flutter-ml/google_ml_kit_flutter/blob/master/packages/google_mlkit_commons/ios/Classes/MLKVisionImage%2BFlutterPlugin.m
    // in both platforms `rotation` and `camera.lensDirection` can be used to compensate `x` and `y` coordinates on a canvas: https://github.com/flutter-ml/google_ml_kit_flutter/blob/master/packages/example/lib/vision_detector_views/painters/coordinates_translator.dart
    final camera = _cameras[_cameraIndex];
    final sensorOrientation = camera.sensorOrientation;
    // print(
    //     'lensDirection: ${camera.lensDirection}, sensorOrientation: $sensorOrientation, ${_controller?.value.deviceOrientation} ${_controller?.value.lockedCaptureOrientation} ${_controller?.value.isCaptureOrientationLocked}');
    InputImageRotation? rotation;
    if (Platform.isIOS) {
      rotation = InputImageRotationValue.fromRawValue(sensorOrientation);
    } else if (Platform.isAndroid) {
      var rotationCompensation =
          _orientations[_controller!.value.deviceOrientation];
      if (rotationCompensation == null) return null;
      if (camera.lensDirection == CameraLensDirection.front) {
        // front-facing
        rotationCompensation = (sensorOrientation + rotationCompensation) % 360;
      } else {
        // back-facing
        rotationCompensation =
            (sensorOrientation - rotationCompensation + 360) % 360;
      }
      rotation = InputImageRotationValue.fromRawValue(rotationCompensation);
      // print('rotationCompensation: $rotationCompensation');
    }
    if (rotation == null) return null;
    // print('final rotation: $rotation');

    // get image format
    final format = InputImageFormatValue.fromRawValue(image.format.raw);
    // validate format depending on platform
    // only supported formats:
    // * nv21 for Android
    // * bgra8888 for iOS
    if (format == null ||
        (Platform.isAndroid && format != InputImageFormat.nv21) ||
        (Platform.isIOS && format != InputImageFormat.bgra8888)) {
      print("What's going on?...");
      return null;
    }

    // since format is constraint to nv21 or bgra8888, both only have one plane
    if (image.planes.length != 1) return null;
    final plane = image.planes.first;

    // compose InputImage using bytes
    return InputImage.fromBytes(
      bytes: plane.bytes,
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: rotation, // used only in Android
        format: format, // used only in iOS
        bytesPerRow: plane.bytesPerRow, // used only in iOS
      ),
    );
  }
}

// A custom Flutter widget that represents a camera shutter button.
class ShutterButton extends StatefulWidget {
  // Callback function to be executed when the button is pressed.
  final VoidCallback onPressed;
  // The size of the button.
  final double size;
  // The color of the outer ring of the button.
  final Color outerColor;
  // The color of the inner circle of the button.
  final Color innerColor;
  // The padding around the inner circle.
  final double innerPadding;

  // Constructor for the ShutterButton widget.
  const ShutterButton({
    Key? key,
    required this.onPressed,
    this.size = 80.0, // Default size for the button
    this.outerColor = Colors.white, // Default outer ring color
    this.innerColor = Colors.white, // Default inner circle color
    this.innerPadding = 5.0, // Default padding for the inner circle
  }) : super(key: key);

  @override
  _ShutterButtonState createState() => _ShutterButtonState();
}

// The state class for the ShutterButton widget.
class _ShutterButtonState extends State<ShutterButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    // Initialize the animation controller for the button press effect.
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150), // Duration of the animation
    );

    // Define a Tween for scaling the button during animation.
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.9).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut, // Use easeOut curve for a smooth press effect
      ),
    );
  }

  @override
  void dispose() {
    // Dispose the animation controller when the widget is removed from the tree.
    _controller.dispose();
    super.dispose();
  }

  // Handles the tap down event, starting the animation.
  void _onTapDown(TapDownDetails details) {
    _controller.forward(); // Start the forward animation (scaling down)
  }

  // Handles the tap up event, reversing the animation and triggering onPressed.
  void _onTapUp(TapUpDetails details) {
    _controller.reverse(); // Reverse the animation (scaling up)
    widget.onPressed(); // Execute the provided onPressed callback
  }

  // Handles the tap cancel event, reversing the animation.
  void _onTapCancel() {
    _controller.reverse(); // Reverse the animation (scaling up)
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown, // Register tap down event
      onTapUp: _onTapUp, // Register tap up event
      onTapCancel: _onTapCancel, // Register tap cancel event
      child: ScaleTransition(
        scale: _scaleAnimation, // Apply the scale animation to the button
        child: Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            shape: BoxShape.circle, // Make the outer container a circle
            border: Border.all(
              color: widget.outerColor, // Set outer border color
              width: 4.0, // Set outer border width
            ),
          ),
          child: Center(
            child: Container(
              width:
                  widget.size -
                  (widget.innerPadding * 2) -
                  8, // Calculate inner circle size
              height: widget.size - (widget.innerPadding * 2) - 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle, // Make the inner container a circle
                color: widget.innerColor, // Set inner circle color
              ),
            ),
          ),
        ),
      ),
    );
  }
}
