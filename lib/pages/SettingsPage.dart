import 'package:flutter/material.dart';
import 'package:makeeasy/utils/appStyle.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:makeeasy/main.dart'; // assuming `themeNotifier` is defined there

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            size: 30,
            color: Theme.of(context).colorScheme.primary,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Settings',
          style: TextStyle(color: Theme.of(context).colorScheme.primary),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSettingsItem(context, Icons.email, "Change email"),
            _buildSettingsItem(context, Icons.lock, "Change password"),
            _buildSettingsItem(
              context,
              Icons.color_lens,
              "Theme",
              onTap: () => _toggleTheme(context),
            ),

            _buildSettingsItem(
              context,
              Icons.privacy_tip,
              "Privacy",
              onTap: () => _showPrivacyDialog(context),
            ),

            _buildSettingsItem(
              context,
              Icons.help_outline,
              "FAQ",
              onTap: () => _showFAQDialog(context),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                // AuthGate will detect sign-out and show RegisterPage again
                },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.secondary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 12,
                ),
              ),
              child: const Text(
                'Log out',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsItem(
    BuildContext context,
    IconData icon,
    String title, {
    VoidCallback? onTap,
  }) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: Icon(
          icon,
          size: 30,
          color: Theme.of(context).colorScheme.secondary,
        ),
        title: Text(
          title,
          style: TextStyle(color: Theme.of(context).colorScheme.secondary),
        ),
        onTap:
            onTap ??
            () {
              // Default tap behavior
            },
      ),
    );
  }
}

void _showFAQDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8, // 80% of screen width
          height:
              MediaQuery.of(context).size.height * 0.6, // 60% of screen height
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "FAQs",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "Q: How do I change my password?",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text("A: Go to Settings > Change password."),
                      SizedBox(height: 15),
                      Text(
                        "Q: How do I contact support?",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text("A: Email us at support@example.com."),
                      SizedBox(height: 15),
                      Text(
                        "Q: Is dark mode available?",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text("A: Yes! Go to Settings > Theme."),
                      SizedBox(height: 15),
                      // Add more FAQs here as needed
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text("Close"),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

void _showPrivacyDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height * 0.6,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Privacy Policy",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "1. Data Collection",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "We collect only the data necessary to provide our services, such as email and username.",
                      ),
                      SizedBox(height: 15),
                      Text(
                        "2. Data Usage",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Your data is used solely to enhance your experience and is never sold to third parties.",
                      ),
                      SizedBox(height: 15),
                      Text(
                        "3. Security",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "We implement secure methods to protect your information from unauthorized access.",
                      ),
                      SizedBox(height: 15),
                      Text(
                        "4. Contact",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "For questions regarding our privacy policy, contact privacy@makeeasy.com.",
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text("Close"),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

void _toggleTheme(BuildContext context) {
  if (themeNotifier.value == ThemeMode.light) {
    themeNotifier.value = ThemeMode.dark;
  } else if (themeNotifier.value == ThemeMode.dark) {
    themeNotifier.value = ThemeMode.light;
  } else {
    // If system, toggle to light as a default
    themeNotifier.value = ThemeMode.light;
  }

  // Optional: show feedback
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        'Switched to ${themeNotifier.value == ThemeMode.dark ? "Dark" : "Light"} Mode',
      ),
      duration: const Duration(seconds: 1),
    ),
  );
}
