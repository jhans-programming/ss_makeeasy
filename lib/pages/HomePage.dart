import 'dart:collection';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_mlkit_face_mesh_detection/google_mlkit_face_mesh_detection.dart';
import 'package:makeeasy/components/HomePage/filter_selector.dart';
import 'package:makeeasy/pages/InstructionsPage.dart';

import 'package:makeeasy/painters/instructions_painter.dart';
import 'package:makeeasy/utils/face_guidelines.dart';

import 'package:provider/provider.dart';
import 'package:makeeasy/states/favorites_notifier.dart';

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
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  late FaceMeshDetector _meshDetector = FaceMeshDetector(
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
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _meshDetector = FaceMeshDetector(
      option: FaceMeshDetectorOptions.faceMesh,
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _meshDetector.close();
      _meshDetector = FaceMeshDetector(
        option: FaceMeshDetectorOptions.faceMesh,
      );
    }
  }

  @override
  void dispose() {
    _canProcess = false;
    try {
      _meshDetector.close();
    } catch (_) {}
    categoryFilterController.dispose();
    super.dispose();
  }

  List<Widget> _buildHomePageUI(FavoriteFiltersNotifier favNotifier) {
    return [
      Positioned(
        top: 80,
        left: 20,
        right: 20,
        child: Row(
          //mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Choose your style",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Colors.black.withAlpha(255),
                          blurRadius: 10,
                        ),
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

            Padding(
              padding: const EdgeInsets.only(right: 1),
              // Info button
              child: IconButton(
                icon: Icon(Icons.info_outline, color: Colors.white),
                tooltip: 'Information',
                onPressed: () {
                  // String selectedFilter =
                  //     selectedCategoryFilter == CategoryFilter.Party
                  //         ? 'party'
                  //         : 'daily';
                  String getSelectedStyleKey() {
                    if (selectedCategoryFilter == CategoryFilter.Party)
                      return 'party';

                    // If showing both daily and party (CategoryFilter.All), use selectedCategory to pick
                    return selectedCategory == 0 ? 'daily' : 'party';
                  }

                  final selectedKey = getSelectedStyleKey();
                  final selectedStyle = styleInfo[selectedKey]!;

                  final imagePath = selectedStyle['image'];
                  final title = selectedStyle['title'];
                  final description = selectedStyle['description'];

                  showDialog(
                    context: context,
                    builder:
                        (context) => Dialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(25),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child: Image.asset(
                                        selectedStyle['image']!,
                                        height: 100,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      selectedStyle['title']!,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      selectedStyle['description']!,
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                right: 0,
                                child: IconButton(
                                  icon: const Icon(Icons.close),
                                  onPressed: () => Navigator.pop(context),
                                ),
                              ),
                            ],
                          ),
                        ),
                  );
                },
              ),
            ),
          ],
        ),
      ),

      //   child: Column(
      //     children: [
      //       Text(
      //         "Choose your style",
      //         style: TextStyle(
      //           fontSize: 18,
      //           fontWeight: FontWeight.bold,
      //           color: Colors.white,
      //           shadows: [
      //             Shadow(color: Colors.black.withAlpha(255), blurRadius: 10),
      //           ],
      //         ),
      //       ),
      //       const SizedBox(height: 8),
      //       DropdownMenu(
      //         dropdownMenuEntries: CategoryFilter.entries,
      //         initialSelection: selectedCategoryFilter,
      //         textStyle: const TextStyle(color: Colors.white),
      //         onSelected: (value) {
      //           setState(() {
      //             selectedCategoryFilter = value ?? CategoryFilter.All;
      //           });
      //         },
      //       ),
      //     ],
      //   ),
      // ),

      FilterSelector(
        optionChangeHandler: (page) => setState(() {
          selectedCategory = page;
        }),
        optionChosenHandler: (selectedStyle) {
          if (selectedCategory == selectedStyle) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    InstructionsPage(selectedCategory: selectedCategory),
              ),
            );
          }
        },
        onToggleFavorite: (index) => favNotifier.toggleFavorite(index),
        isFavorite: (index) => favNotifier.isFavorite(index),
        categoryFilter: selectedCategoryFilter,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return Scaffold(
        appBar: AppBar(title: const Text('Under construction')),
        body: const Center(
          child: Text(
            'Not implemented yet for iOS :(\nTry Android',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const Scaffold(
        body: Center(child: Text("Please log in first.")),
      );
    }


    return ChangeNotifierProvider(
      create: (_) => FavoriteFiltersNotifier(user.uid),
      child: Consumer<FavoriteFiltersNotifier>(
        builder: (context, favNotifier, _) {
          return Stack(
            alignment: Alignment.bottomCenter,
            children: [
              DetectorView(
                title: 'Face Mesh Detector',
                customPaint: _customPaint,
                enableTakePicture: false,
                text: _text,
                onImage: _processImage,
                initialCameraLensDirection: _cameraLensDirection,
                onCameraLensDirectionChanged: (value) =>
                    _cameraLensDirection = value,
              ),
              ..._buildHomePageUI(favNotifier),
            ],
          );
        },
      ),
    );
  }

  Future<void> _processImage(InputImage inputImage) async {
    if (!_canProcess || _isBusy) return;
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
      _text = 'Face meshes found: \${meshes.length}\n\n';
      for (final mesh in meshes) {
        _text = (_text ?? '') + 'face: \${mesh.boundingBox}\n\n';
      }
      _customPaint = null;
    }
    _isBusy = false;
    if (mounted) {
      setState(() {});
    }
  }
}
final Map<String, Map<String, String>> styleInfo = {
  'daily': {
    'title': 'Last Friday Night',
    'description':
        'This is a simple daily makeup routine that enhances your natural beauty without being too heavy.',
    'image': 'assets/images/daily.png',
  },
  'party': {
    'title': 'Party in The USA',
    'description':
        'This party makeup routine is bold and glamorous, perfect for special occasions.',
    'image': 'assets/images/party.png',
  },
};