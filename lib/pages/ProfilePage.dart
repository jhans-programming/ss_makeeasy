import 'package:flutter/material.dart';
import 'package:makeeasy/utils/appStyle.dart';
import 'package:makeeasy/pages/SettingsPage.dart';
import 'package:makeeasy/pages/HistoryPage.dart';
import 'package:makeeasy/pages/LippieChatPage.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColors['primaryLight4'],
      appBar: AppBar(
        title: Text(
          'MY PROFILE',
          style: TextStyle(
            color: appColors['primaryDark1'] ?? Colors.black,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.settings,
              size: 30,
              color: appColors['primaryDark1'] ?? Colors.black,
            ),
            tooltip: 'Settings',
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
                    secondaryAnimation,
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
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                ClipOval(
                  child: Image(
                    image: const AssetImage(
                      'assets/images/profile.jpg',
                    ), // Use your asset image
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover, // Important: Use BoxFit.cover
                  ),
                ),
                const SizedBox(width: 20),
                Text(
                  'Nana',
                  style: TextStyle(
                    color: appColors['primaryDark1'] ?? Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Stack(
              children: <Widget>[
                // 1. The Box
                Container(
                  width: double.infinity,
                  height: 250,
                  decoration: BoxDecoration(
                    color: appColors['primaryLight5'],
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: appColors['primaryDark1']!,
                        blurRadius: 10,
                        offset: const Offset(5, 5),
                      ),
                    ],
                  ),
                ),
                // 2. The Elements (Icon, Text)
                Positioned(
                  top: 20,
                  left: 30,
                  child: Row(
                    children: [
                      Icon(
                        Icons.history,
                        size: 30,
                        color: appColors['primaryDark1'] ?? Colors.black,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Recent Makeups',
                        style: TextStyle(
                          fontSize: 22,
                          color: appColors['primaryDark1'] ?? Colors.black,
                          //fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                // 3. The Elements (Boxes of recent makeup images)
                Positioned(
                  top: 60,
                  left: 30,
                  right: 30,
                  child: Row(
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
                ),
                // 4. The Element (Button)
                Positioned(
                  bottom: 15,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: TextButton(
                      onPressed: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(builder: (context) => const HistoryPage()),
                        // );
                        _showSnackBar(
                          context,
                          'See all history button pressed',
                        );
                      },
                      child: Text(
                        'See all history',
                        style: TextStyle(
                          color: appColors['primaryDark1'] ?? Colors.black,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
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
                backgroundColor: appColors['primaryDark1'],
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
    );
  }

  // Helper function to build the small boxes
  static Widget _buildRecentMakeupBox(BuildContext context, String imagePath) {
    final screenWidth = MediaQuery.of(context).size.width;
    final boxWidth = (screenWidth - 125) / 3;

    return SizedBox(
      width: boxWidth,
      height: 120,
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