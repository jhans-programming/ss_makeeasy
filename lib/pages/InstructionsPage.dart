import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_mesh_detection/google_mlkit_face_mesh_detection.dart';
import 'package:makeeasy/components/HomePage/detector_view.dart';
import 'package:makeeasy/pages/ResultSelfiePage.dart';
import 'package:makeeasy/pages/LippieChatPage.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:makeeasy/painters/instructions_painter.dart';
import 'package:makeeasy/utils/face_guidelines.dart';
import 'package:makeeasy/states/history_notifier.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:core';
import 'dart:async';


class InstructionsPage extends StatefulWidget {
  const InstructionsPage({super.key, required this.selectedCategory});

  final int selectedCategory;

  @override
  State<InstructionsPage> createState() => _InstructionsPageState();
}

class _InstructionsPageState extends State<InstructionsPage> {
  int currentStep = 0;
  Timer? _timer;
  bool _showHelpBubble = false;

  // Text-to-Speech related
  final FlutterTts _flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    _flutterTts.setLanguage('en-US'); // Set language to English (US)
    _flutterTts.setPitch(1.0); // Optional: adjust pitch
    _flutterTts.setSpeechRate(0.5); // Optional: adjust speaking speed

    _resetInactivityTimer();
    //_setFemaleVoice();
  }

  void _speakInstruction() {
    final stepText =
        stepsData[widget.selectedCategory][currentStep]['application'];
      print("Speaking instruction: $stepText");
    if (stepText != null) {
      _flutterTts.speak(stepText);
    }
  }

  void _resetInactivityTimer() {
    _timer?.cancel();
    _timer = Timer(const Duration(seconds: 10), () {
      _showHelpBubbleMessage();
    });
  }

  void _showHelpBubbleMessage() {
    setState(() {
      _showHelpBubble = true;
    });

    // Auto-hide after a few seconds
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          _showHelpBubble = false;
        });
      }
    });
  }



  // Scroll - Button related
  final DraggableScrollableController _sheetController =
      DraggableScrollableController();

  // Camera feed related
  final FaceMeshDetector _meshDetector = FaceMeshDetector(
    option: FaceMeshDetectorOptions.faceMesh,
  );
  bool _canProcess = true;
  bool _isBusy = false;
  CustomPaint? _customPaint;
  String? _text;
  final _cameraLensDirection = CameraLensDirection.front;

  void _nextStep() {
    if (currentStep < stepsData[widget.selectedCategory].length - 1) {
      setState(() => currentStep++);
      _resetInactivityTimer();
    }
  }
  void _previousStep() {
    if (currentStep > 0) {
      setState(() => currentStep--);
      _resetInactivityTimer();
    }
  }


  @override
  void dispose() {
    _flutterTts.stop(); // Stop any ongoing speech
    _canProcess = false;
    _meshDetector.close();
    _timer?.cancel(); // Cancel the timer if it's running
    super.dispose();
  }

  List<Widget> _buildInstructionsUI() {
    Map<String, String> stepData =
        stepsData[widget.selectedCategory][currentStep];

    return [
      // Background Image
      // Positioned.fill(child: Image.asset(stepData['image'], fit: BoxFit.cover)),

      // Top bar with Close, Step Title, Done
      Positioned(
        top: 40,
        left: 10,
        right: 10,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Center Step Info
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Step ${currentStep + 1}",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    shadows: [Shadow(blurRadius: 10, color: Colors.black)],
                  ),
                ),
                Text(
                  stepData['title'] ?? "",
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [Shadow(blurRadius: 10.0, color: Colors.black)],
                  ),
                ),
              ],
            ),

            // Row for Close and Done Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Close Button
                IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    size: 30,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  onPressed: () {
                    //TODO: Show alert dialog
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text("Exit"),
                          content: const Text(
                            "Are you sure you want to exit instructions?",
                          ),
                          actions: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text("Cancel"),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.popUntil(
                                  context,
                                  (route) => route.settings.name == '/',
                                );
                              },
                              child: Text("Exit"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),

                // Done Button
              if (currentStep == stepsData[widget.selectedCategory].length - 1)
                ElevatedButton(
                  // onPressed: () async {
                  //   final stepData = stepsData[widget.selectedCategory][currentStep];

                  //   final newHistory = UserHistory(
                  //     title: stepData['title'] ?? "Selfie",
                  //     description: stepData['description'] ?? "",
                  //     date: DateTime.now(),
                  //     imagePath: 'assets/images/dummylook1.jpg', // Replace with actual image if needed
                  //     style: widget.selectedCategory,
                  //     id: DateTime.now().millisecondsSinceEpoch.toString(),
                  //   );

                  //   final user = FirebaseAuth.instance.currentUser;
                  //   final firestore = FirebaseFirestore.instance;

                  //   if (user != null) {
                  //     try {
                  //       await firestore.collection('users').doc(user.uid).update({
                  //         'history': FieldValue.arrayUnion([
                  //           {
                  //             'title': newHistory.title,
                  //             'description': newHistory.description,
                  //             'date': Timestamp.fromDate(newHistory.date),
                  //             'imagePath': newHistory.imagePath,
                  //             'style': newHistory.style,
                  //             'id': newHistory.id,
                  //           }
                  //         ])
                  //       });
                  //     } catch (e) {
                  //       print("Error uploading history: $e");
                  //     }
                  //   }

                  //   Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //       builder: (_) => ResultSelfiePage(
                  //         history: newHistory,
                  //         selectedCategory: widget.selectedCategory,
                  //       ),
                  //     ),
                  //   );
                  // },

                  onPressed: () {
                    setState(() {
                      currentStep++;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                  child: const Text(
                    "DONE",
                    style: TextStyle(color: Colors.white),
                  ),
                ),

              ],
            ),
          ],
        ),
      ),
      if (_showHelpBubble) 
      Positioned(
        right: 50, // Position bubble to the left of the icon
        top: 640,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.pink.shade100,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
              ),
            ],
          ),
          child: const Text(
            "Need help?\n Tap me!",
            style: TextStyle(
              color: Colors.black87,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),

      // Right side buttons
      Positioned(
        top: 120,
        right: 10,
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white, // or background
              ),
              child: IconButton(
                icon: Icon(
                  Icons.note_alt,
                  color: Theme.of(context).colorScheme.primary,
                ),
                onPressed: () {
                  _sheetController.animateTo(
                    0.5,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white, // or background
              ),
              child: IconButton(
                icon: Icon(
                  Icons.volume_up_rounded,
                  color: Theme.of(context).colorScheme.primary,
                ),
                onPressed: () {
                  _speakInstruction();
                  _resetInactivityTimer();
                },
              ),
            ),
            const SizedBox(height: 450),
            IconButton(
              icon: Image.asset(
                'assets/images/lippie_logo.png',
                height: 40, // adjust size as needed
                width: 40,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LippieChatPage()),
                    );
              },
            ),
            
          ],
        ),
      ),

      // Right arrow for next step
      if (currentStep < stepsData[widget.selectedCategory].length - 1)
        Positioned(
          right: 10,
          bottom: 375,
          child: IconButton(
            icon: Icon(
              Icons.arrow_forward_ios,
              color: Theme.of(context).colorScheme.primary,
            ),
            onPressed: _nextStep,
          ),
        ),

      // Left arrow for previous step
      if (currentStep > 0)
        Positioned(
          left: 10,
          bottom: 375,
          child: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Theme.of(context).colorScheme.primary,
            ),
            onPressed: _previousStep,
          ),
        ),

      // Bottom draggable sheet
      DraggableScrollableSheet(
        controller: _sheetController,
        initialChildSize: 0.1,
        minChildSize: 0.1,
        maxChildSize: 0.75,
        builder: (context, scrollController) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(30),
              ),
            ),

            child: SafeArea(
              top: false,
              child: SingleChildScrollView(
                controller: scrollController,
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(child: Icon(Icons.drag_handle, color: Colors.black)),
                    const SizedBox(height: 10),
                    Center(
                      child: Text(
                        stepData['title'] ?? "",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      stepData['description'] ?? "",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    ];
  }

  List<Widget> _buildSelfieUI() {
  return [
    // Top title and back button
    Positioned(
      top: 40,
      left: 10,
      right: 10,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Text(
            "Take a Selfie!",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: [Shadow(blurRadius: 10.0, color: Colors.black)],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  size: 30,
                  color: Theme.of(context).colorScheme.primary,
                ),
                onPressed: () {
                  currentStep--;
                },
              ),
            ],
          ),
        ],
      ),
    ),

    // Bottom-right Skip button
    Positioned(
      bottom: 150,
      right: 50,
      child: GestureDetector(
        onTap: () {
          final skippedHistory = UserHistory(
            title: "Title",
            description: "Description",
            date: DateTime.now(),
            imagePath: 'assets/images/dummylook1.jpg', // Replace with your default image
            style: widget.selectedCategory,
            id: DateTime.now().millisecondsSinceEpoch.toString(),
          );

          // Save to provider
          Provider.of<UserHistoryNotifier>(context, listen: false)
              .addHistory(skippedHistory);

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ResultSelfiePage(
                history: skippedHistory,
                selectedCategory: widget.selectedCategory,
              ),
            ),
          );
        },
        child: Text(
          "SKIP",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: [Shadow(blurRadius: 10.0, color: Colors.black)],
          ),
        ),
      ),
    ),
  ];
}


  void _confirmSelfie(XFile imagefile) {
    final newHistory = UserHistory(
      title: "Title",
      description: "Description",
      date: DateTime.now(),
      imagePath: imagefile.path,
      style: widget.selectedCategory,
      id: DateTime.now().millisecondsSinceEpoch.toString(),
    );

    // Save to provider
    final historyProvider = Provider.of<UserHistoryNotifier>(
      context,
      listen: false,
    );
    historyProvider.addHistory(newHistory);

    // Navigate to result page with the new data
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (_) => ResultSelfiePage(
              history: newHistory,
              selectedCategory: widget.selectedCategory,
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // The current step
    // final stepData = stepsData[][currentStep];

    int stepsCount = stepsData[widget.selectedCategory].length;

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: _resetInactivityTimer,
      child: Scaffold(
        body: Stack(

        children: [
          // Camera Feed
          DetectorView(
            title: 'Face Mesh Detector',
            onImage: _processImage,
            customPaint: _customPaint,
            enableTakePicture: currentStep == stepsCount,
            onConfirmSelfie: _confirmSelfie,
            text: _text,
            initialCameraLensDirection: _cameraLensDirection,
            onCameraLensDirectionChanged: (value) => _cameraLensDirection,
          ),

          if (currentStep < stepsCount) ..._buildInstructionsUI(),
          if (currentStep == stepsCount) ..._buildSelfieUI(),
        ],
      ),
    )
    );
  }

  Future<void> _processImage(InputImage inputImage) async {
    if (!_canProcess) return;
    if (_isBusy) return;
    _isBusy = true;
    setState(() {
      _text = '';
    });

    final meshes = await _meshDetector.processImage(inputImage);
    if (inputImage.metadata?.size != null &&
        inputImage.metadata?.rotation != null &&
        currentStep < stepsData[widget.selectedCategory].length) {
      final painter = InstructionsPainter(
        meshes,
        inputImage.metadata!.size,
        inputImage.metadata!.rotation,
        _cameraLensDirection,
        [widget.selectedCategory, currentStep],
      );
      _customPaint = CustomPaint(painter: painter);
    } else {
      String text = 'Face meshes found: ${meshes.length}\n\n';
      for (final mesh in meshes) {
        text += 'face: ${mesh.boundingBox}\n\n';
      }
      _text = text;
      // TODO: set _customPaint to draw boundingRect on top of image
      _customPaint = null;
    }
    _isBusy = false;
    if (mounted) {
      setState(() {});
    }
  }
}
