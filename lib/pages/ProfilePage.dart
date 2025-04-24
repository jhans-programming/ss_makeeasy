import 'package:flutter/material.dart';
import 'package:makeeasy/utils/appStyle.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColors['primaryLight4'],
      appBar: AppBar(
        title: const Text('MY PROFILE'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Settings',
            onPressed: () {
              _showSnackBar(context, 'Settings pressed!');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              //mainAxisAlignment: MainAxisAlignment.center,
              //crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ClipOval(
                  child: Image(
                    image: const AssetImage('assets/images/profile.jpg'), // Use your asset image
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
                )
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
                  )
                ),
                // 3. The Elements (Boxes of recent makeup images)
                Positioned(
                  top: 60,
                  left: 30,
                  right: 30,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      _buildRecentMakeupBox('assets/images/profile.jpg'),
                      _buildRecentMakeupBox('assets/images/profile.jpg'),
                      _buildRecentMakeupBox('assets/images/profile.jpg'),
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
                        _showSnackBar(context, 'TextButton pressed!');
                      },
                      child:
                      Text('See all history',
                        style: TextStyle(
                          color: appColors['primaryDark1'] ?? Colors.black,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  // Helper function to build the small boxes
  static Widget _buildRecentMakeupBox(String imagePath) {
    return SizedBox(
      width: 95,
      height: 120,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.asset(imagePath,
        fit: BoxFit.cover,
        ),
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
