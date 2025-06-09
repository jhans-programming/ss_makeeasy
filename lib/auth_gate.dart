// lib/auth_gate.dart

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:makeeasy/pages/MainScreen.dart';
import 'package:makeeasy/pages/RegisterPage.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (!snapshot.hasData) {
          // Not signed in → show RegisterPage, passing a rebuild callback
          return RegisterPage(
            onSubmit: () {
              // Rebuild AuthGate (so it detects the new auth state and shows MainScreen)
              (context as Element).reassemble();
            },
          );
        }
        // Signed in → show MainScreen
        return const MainScreen();
      },
    );
  }
}
