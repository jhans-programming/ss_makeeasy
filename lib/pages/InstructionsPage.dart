import 'package:flutter/material.dart';

class InstructionsPage extends StatefulWidget {
  const InstructionsPage({super.key});

  @override
  State<InstructionsPage> createState() => _InstructionsPageState();
}

class _InstructionsPageState extends State<InstructionsPage> {
  int currentStep = 1;

  // Step-specific data
  final List<Map<String, dynamic>> steps = [
    {
      'step': 'STEP 1',
      'title': 'CONCEALER',
      'description':
          'This is dummy text explaining how to apply concealer properly. You can drag this panel up for more detailed instructions, tips, or video links.',
      'image': 'assets/images/dummylook1.jpg',
    },
    {
      'step': 'STEP 2',
      'title': 'FOUNDATION',
      'description':
          'This is dummy text explaining how to apply foundation evenly. You can drag this panel up for more detailed instructions, tips, or video links.',
      'image': 'assets/images/dummylook1.jpg',
    },
  ];

  void _nextStep() {
    if (currentStep < steps.length) {
      setState(() {
        currentStep++;
      });
    }
  }

  void _previousStep() {
    if (currentStep > 1) {
      setState(() {
        currentStep--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final stepData = steps[currentStep - 1];

    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(stepData['image'], fit: BoxFit.cover),
          ),

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
                      stepData['step'],
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        shadows: [
                          Shadow(
                            offset: Offset(1.0, 1.0),
                            blurRadius: 5.0,
                            color: Colors.white.withValues(),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      stepData['title'],
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        shadows: [
                          Shadow(
                            offset: Offset(1.0, 1.0),
                            blurRadius: 5.0,
                            color: Colors.white.withValues(),
                          ),
                        ],
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
                        Icons.close,
                        size: 30,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),

                    // Done Button
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
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
                    onPressed: () {},
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
                    onPressed: () {},
                  ),
                ),
                const SizedBox(height: 450),
                IconButton(
                  icon: Image.asset(
                    'assets/images/lippie_logo.png',
                    height: 40, // adjust size as needed
                    width: 40,
                  ),
                  onPressed: () {},
                ),
              ],
            ),
          ),

          // Right arrow for next step
          if (currentStep < steps.length)
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
          if (currentStep > 1)
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
            initialChildSize: 0.1,
            minChildSize: 0.1,
            maxChildSize: 0.5,
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
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
                        Center(
                          child: Icon(Icons.drag_handle, color: Colors.black),
                        ),
                        const SizedBox(height: 10),
                        Center(
                          child: Text(
                            stepData['title'],
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          stepData['description'],
                          textAlign: TextAlign.center,
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
        ],
      ),
    );
  }
}
