import 'dart:collection';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_mesh_detection/google_mlkit_face_mesh_detection.dart';
import 'package:makeeasy/components/HomePage/filter_selector.dart';

import '../components/HomePage/detector_view.dart';
import '../painters/face_mesh_detector_painter.dart';

typedef CategoryFilterEntry = DropdownMenuEntry<CategoryFilter>;
String getCategoryFilterLabel(CategoryFilter cat) =>
    cat.toString().split(".")[1];

enum CategoryFilter {
  All,
  Daily,
  Party;

  static final List<DropdownMenuEntry<CategoryFilter>> entries =
      UnmodifiableListView<CategoryFilterEntry>(
        values.map<CategoryFilterEntry>(
          (CategoryFilter cat) => CategoryFilterEntry(
            value: cat,
            label: getCategoryFilterLabel(cat),
          ),
        ),
      );
}

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FaceMeshDetector _meshDetector = FaceMeshDetector(
    option: FaceMeshDetectorOptions.faceMesh,
  );
  bool _canProcess = true;
  bool _isBusy = false;
  CustomPaint? _customPaint;
  String? _text;
  var _cameraLensDirection = CameraLensDirection.front;

  CategoryFilter selectedCategoryFilter = CategoryFilter.All;

  int selectedCategory = 0;
  final TextEditingController categoryFilterController =
      TextEditingController();

  @override
  void dispose() {
    _canProcess = false;
    _meshDetector.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return Scaffold(
        appBar: AppBar(title: Text('Under construction')),
        body: Center(
          child: Text(
            'Not implemented yet for iOS :(\nTry Android',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        // Camera Feed
        DetectorView(
          title: 'Face Mesh Detector',
          customPaint: _customPaint,
          text: _text,
          onImage: _processImage,
          initialCameraLensDirection: _cameraLensDirection,
          onCameraLensDirectionChanged: (value) => _cameraLensDirection = value,
        ),

        // Title "Choose your style"
        Positioned(
          top: 80,
          child: Column(
            children: [
              Text(
                "Choose your style",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(color: Colors.black.withAlpha(255), blurRadius: 10),
                  ],
                ),
              ),

              SizedBox(height: 8),

              DropdownMenu(
                dropdownMenuEntries: CategoryFilter.entries,
                initialSelection: selectedCategoryFilter,
                textStyle: TextStyle(color: Colors.white),
                onSelected: (value) {
                  setState(() {
                    selectedCategoryFilter = value ?? CategoryFilter.All;
                  });
                },
              ),
            ],
          ),
        ),

        // Filter Selector
        FilterSelector(
          optionChangeHandler:
              (page) => setState(() {
                selectedCategory = page;
              }),
          categoryFilter: selectedCategoryFilter,
        ),
      ],
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
        inputImage.metadata?.rotation != null) {
      final painter = FaceMeshDetectorPainter(
        meshes,
        inputImage.metadata!.size,
        inputImage.metadata!.rotation,
        _cameraLensDirection,
        selectedCategoryFilter == CategoryFilter.Party ? 1 : selectedCategory,
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
