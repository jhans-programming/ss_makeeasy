import 'package:flutter/material.dart';
import 'package:makeeasy/utils/appStyle.dart';
import 'package:makeeasy/pages/SettingsPage.dart';
import 'package:makeeasy/pages/HistoryPage.dart';
import 'package:makeeasy/pages/LippieChatPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return const Center(child: Text('Not logged in.'));
    }

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance.collection('users').doc(user!.uid).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final userData = snapshot.data!.data() as Map<String, dynamic>?;

        if (userData == null) {
          return const Center(child: Text('User data not found.'));
        }

        final history = (userData['history'] as List?) ?? [];

        return Scaffold(
          appBar: AppBar(
            title: Text(
              'My Profile',
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.settings, size: 30),
                onPressed: () {
                  Navigator.of(context).push(
                    PageRouteBuilder(
                      transitionDuration: const Duration(milliseconds: 500),
                      pageBuilder: (context, animation, secondaryAnimation) => const SettingsPage(),
                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                        const begin = Offset(1.0, 0.0);
                        const end = Offset.zero;
                        const curve = Curves.ease;

                        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
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
          body: Stack(
  children: [
    Padding(
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
                      color: Theme.of(context).colorScheme.secondary.withAlpha(150),
                      blurRadius: 15,
                      spreadRadius: 8,
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/profile.jpg',
                    width: 150,
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                userData['fullName'] ?? 'No name',
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(24),
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
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (history.isEmpty)
                  const Text("Your make-up history will be listed here!"),
                if (history.isNotEmpty)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(
                      3,
                      (index) {
                        if (index < history.length) {
                          return _buildRecentMakeupBox(
                            context,
                            history[index]['image'] ?? 'assets/images/profile.jpg',
                          );
                        } else {
                          return const SizedBox(width: 80, height: 120);
                        }
                      },
                    ),
                  ),
                const SizedBox(height: 8),
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
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),

    // 👉 Floating Lippie Button
    Positioned(
      bottom: 16,
      right: 16,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LippieChatPage(),
            ),
          );
        },
        child: Container(
    
          padding: const EdgeInsets.all(12),
          child: Image.asset(
            'assets/images/lippie_logo.png',
            height: 50,
            width: 50,
          ),
        ),
      ),
    ),
  ],
),

          
        );
        
      },
    );
    
  }

  

  static Widget _buildRecentMakeupBox(BuildContext context, String imagePath) {
  final screenWidth = MediaQuery.of(context).size.width;
  final boxWidth = (screenWidth - 125) / 3;

  final isNetwork = imagePath.startsWith('http'); // ✅ Fixed declaration

  return SizedBox(
    width: boxWidth,
    height: 120,
    child: ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: isNetwork
          ? Image.network(
              imagePath,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) =>
                  Image.asset('assets/images/profile.jpg', fit: BoxFit.cover),
            )
          : Image.asset(imagePath, fit: BoxFit.cover),
    ),
  );
}


  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }
}
