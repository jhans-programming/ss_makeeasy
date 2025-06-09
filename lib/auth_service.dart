// lib/services/auth_service.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

  /// Sign up: create user in Firebase Auth & write a Firestore doc at users/{uid}
  Future<User?> signUp(
  String email,
  String password,
  String fullName,
  String gender,
) async {
  try {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = cred.user;

    if (user != null) {
      print("✅ Firebase Auth UID: ${user.uid}");

      await _db.collection('users').doc(user.uid).set({
        'fullName': fullName,
        'email': email,
        'gender': gender,
        'favorites': [], // default empty array
        'history': [],   // default empty array
        'createdAt': FieldValue.serverTimestamp(),
      });
      print("✅ Firestore document written for UID: ${user.uid}");
    }

    return user;
  } catch (e) {
    print("Error during sign-up: $e");
    rethrow;
  }
}

  /// Login with email & password
  Future<User?> login(String email, String password) async {
  final cred = await _auth.signInWithEmailAndPassword(
    email: email,
    password: password,
  );

  final user = cred.user;

  if (user != null) {
    final doc = await _db.collection('users').doc(user.uid).get();

    if (!doc.exists) {
      // Optional: Provide fallback/default info
      await _db.collection('users').doc(user.uid).set({
        'fullName': 'Unknown',
        'email': email,
        'gender': 'Other',
        'favorites': [],
        'history': [],
        'createdAt': FieldValue.serverTimestamp(),
      });
      print("Created missing Firestore document for user.");
    }
  }

  return user;
}


  /// Sign out
  Future<void> signOut() => _auth.signOut();

  /// Real‐time stream of users/{uid} document
  Stream<DocumentSnapshot> profileStream(String uid) {
    return _db.collection('users').doc(uid).snapshots();
  }
}
