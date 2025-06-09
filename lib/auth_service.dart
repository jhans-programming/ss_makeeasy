// lib/services/auth_service.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;
  final _db   = FirebaseFirestore.instance;

  /// Sign up: create user in Firebase Auth & write a Firestore doc at users/{uid}
  Future<User?> signUp(String email, String password, String fullName) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = cred.user;
    if (user != null) {
      await _db.collection('users').doc(user.uid).set({
        'fullName': fullName,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
    return user;
  }

  /// Login with email & password
  Future<User?> login(String email, String password) async {
    final cred = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return cred.user;
  }

  /// Sign out
  Future<void> signOut() => _auth.signOut();

  /// Real‐time stream of users/{uid} document
  Stream<DocumentSnapshot> profileStream(String uid) {
    return _db.collection('users').doc(uid).snapshots();
  }
}
