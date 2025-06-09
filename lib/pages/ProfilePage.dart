import 'package:flutter/material.dart';
import 'package:makeeasy/utils/appStyle.dart';
import 'package:makeeasy/pages/SettingsPage.dart';
import 'package:makeeasy/pages/HistoryPage.dart';
import 'package:makeeasy/pages/LippieChatPage.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Profile',
          style: TextStyle(color: Theme.of(context).colorScheme.primary),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings, size: 30),
            // tooltip: 'Settings',
            onPressed: () {
              Navigator.of(context).push(
                PageRouteBuilder(
                  transitionDuration: const Duration(milliseconds: 500),
                  pageBuilder:
                      (context, animation, secondaryAnimation) =>
                          const SettingsPage(),
                  transitionsBuilder: (
                    context,
                    animation,
                    secondary,
                    child,
                  ) {
                    const begin = Offset(1.0, 0.0);
                    const end = Offset.zero;
                    const curve = Curves.ease;

                    var tween = Tween(
                      begin: begin,
                      end: end,
                    ).chain(CurveTween(curve: curve));
                    return SlideTransition(
                      position: animation.drive(tween),
                      child: child,
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Theme.of(context).colorScheme.secondary,
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(
                            context,
                          ).colorScheme.secondary.withAlpha(150),
                          blurRadius: 15,
                          spreadRadius: 8,
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: Image(
                        image: const AssetImage(
                          'assets/images/profile.jpg',
                        ), // Use your asset image
                        width: 150,
                        height: 150,
                        fit: BoxFit.cover, // Important: Use BoxFit.cover
                      ),
                    ),
                  ),
        
                  SizedBox(height: 20),
        
                  Text(
                    'Nana',
                    style: TextStyle(
                      // color: appColors['primaryDark1'] ?? Colors.black,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
        
              const SizedBox(height: 20),
              
              // Recent Makeups Card
              Container(
                padding: EdgeInsets.all(24),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(50),
                      blurRadius: 10,
                      offset: const Offset(5, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // 2. The Elements (Icon, Text)
                    Row(
                      children: [
                        Icon(
                          Icons.history,
                          size: 30,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Recent Makeups',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontWeight: FontWeight.bold,
        
                            // fontSize: 18,
                          ),
                        ),
                      ],
                    ),
        
                    SizedBox(height: 16),
        
                    // 3. The Elements (Boxes of recent makeup images)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        _buildRecentMakeupBox(
                          context,
                          'assets/images/profile.jpg',
                        ),
                        _buildRecentMakeupBox(
                          context,
                          'assets/images/profile.jpg',
                        ),
                        _buildRecentMakeupBox(
                          context,
                          'assets/images/profile.jpg',
                        ),
                      ],
                    ),
        
                    SizedBox(height: 16),
        
                    // 4. The Element (Button)
                    Center(
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HistoryPage(),
                            ),
                          );
                        },
                        child: Text(
                          'See all history',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                            // fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
        
              // Button to Lippie
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LippieChatPage()),
                  );
                  //_showSnackBar(context, 'Lippie button pressed');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  'Lippie',
                  style: TextStyle(
                    color: appColors['primaryLight5'] ?? Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper function to build the small boxes
  static Widget _buildRecentMakeupBox(BuildContext context, String imagePath) {
    final screenWidth = MediaQuery.of(context).size.width;
    final boxWidth = (screenWidth - 125) / 3;

    return SizedBox(
      width: boxWidth,
      height: 240,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.asset(imagePath, fit: BoxFit.cover),
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }
}
