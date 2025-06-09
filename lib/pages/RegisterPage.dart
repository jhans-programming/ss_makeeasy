// lib/RegisterPage.dart

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:makeeasy/utils/appStyle.dart';
import 'package:makeeasy/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key, required this.onSubmit});

  /// Called when login or signup succeeds.
  final VoidCallback onSubmit;

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

enum UserGender { Male, Female, Other }

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  UserGender _userGender = UserGender.Male;

  bool _isLoginPage = true;
  bool _busy = false;
  String? _errorText;

  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _passCtrl = TextEditingController();

  final AuthService _authSvc = AuthService();

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _busy = true;
      _errorText = null;
    });

    try {
      if (_isLoginPage) {
        // ── LOGIN FLOW ─────────────────────────────────────────
        final user = await _authSvc.login(
          _emailCtrl.text.trim(),
          _passCtrl.text.trim(),
        );
        if (user != null) {
          widget.onSubmit();
        }
      } else {
        // ── SIGNUP FLOW ────────────────────────────────────────
        final user = await _authSvc.signUp(
          _emailCtrl.text.trim(),
          _passCtrl.text.trim(),
          "", // no “fullName” field in this UI
        );
        if (user != null) {
          // Save gender in Firestore under users/{uid}
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .update({
            'gender': _userGender.toString().split('.').last,
          });
          widget.onSubmit();
        }
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorText = e.message;
      });
    } catch (_) {
      setState(() {
        _errorText = "An unexpected error occurred.";
      });
    } finally {
      setState(() {
        _busy = false;
      });
    }
  }

  void _switchPage() {
    setState(() {
      _isLoginPage = !_isLoginPage;
      _errorText = null;
      _busy = false;
      _emailCtrl.clear();
      _passCtrl.clear();
      _userGender = UserGender.Male;
    });
  }

  /// Widgets shown in “Login” mode:
  List<Widget> _buildLoginPage() {
    return [
      const Spacer(),
      const Image(image: AssetImage('assets/images/logo.png')),
      const SizedBox(height: 16),
      Text("Log into your account", style: appTextStyles['normalBlack']),
      const SizedBox(height: 16),
      Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _emailCtrl,
              style: appTextStyles['textFormField'],
              decoration: InputDecoration(
                label: Text(
                  "Email",
                  style: appTextStyles['textFormFieldLabel'],
                ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: const BorderSide(color: Colors.red),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide(
                    color: appColors['primaryLight2'] ?? Colors.black,
                  ),
                ),
              ),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                if (!value.contains('@')) {
                  return 'Enter a valid email';
                }
                return null;
              },
            ),
            const SizedBox(height: 8.0),
            TextFormField(
              controller: _passCtrl,
              style: appTextStyles['textFormField'],
              obscureText: true,
              decoration: InputDecoration(
                label: Text(
                  "Password",
                  style: appTextStyles['textFormFieldLabel'],
                ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: const BorderSide(color: Colors.red),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide(
                    color: appColors['primaryLight2'] ?? Colors.black,
                  ),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                if (value.length < 6) {
                  return 'Password must be at least 6 characters';
                }
                return null;
              },
            ),
            if (_errorText != null) ...[
              const SizedBox(height: 12),
              Text(
                _errorText!,
                style: const TextStyle(color: Colors.red),
              ),
            ],
          ],
        ),
      ),
      const Spacer(),
      ElevatedButton(
        onPressed: _busy ? null : _handleSubmit,
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor,
          minimumSize: const Size.fromHeight(48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        child: _busy
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text(
                "Log in",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
      const SizedBox(height: 8),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Don't have an account?"),
          TextButton(
            onPressed: _switchPage,
            child: const Text(
              "Sign up",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    ];
  }

  /// Widgets shown in “Sign-Up” mode:
  List<Widget> _buildSignupPage() {
    return [
      const Spacer(),
      const Image(image: AssetImage("assets/images/logo.png"), width: 128),
      const SizedBox(height: 16),
      Text("Create a new account", style: appTextStyles['normalBlack']),
      const SizedBox(height: 16),
      Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _emailCtrl,
              decoration: InputDecoration(
                label: Text(
                  "Email",
                  style: appTextStyles['textFormFieldLabel'],
                ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: const BorderSide(color: Colors.red),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide(
                    color: appColors['primaryLight2'] ?? Colors.black,
                  ),
                ),
              ),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                if (!value.contains('@')) {
                  return 'Enter a valid email';
                }
                return null;
              },
            ),
            const SizedBox(height: 8.0),
            TextFormField(
              controller: _passCtrl,
              obscureText: true,
              decoration: InputDecoration(
                label: Text(
                  "Password",
                  style: appTextStyles['textFormFieldLabel'],
                ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: const BorderSide(color: Colors.red),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide(
                    color: appColors['primaryLight2'] ?? Colors.black,
                  ),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a password';
                }
                if (value.length < 6) {
                  return 'Password must be at least 6 characters';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      const SizedBox(height: 16),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Please select your gender",
            style: TextStyle(
              color: appColors['primaryDark1'] ?? Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          DropdownButtonFormField<UserGender>(
            value: _userGender,
            decoration: InputDecoration(
              hintText: "Choose your gender",
              filled: true,
              fillColor: Colors.white,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0),
                borderSide: BorderSide(
                  color: appColors['primaryLight2'] ?? Colors.black,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0),
                borderSide: BorderSide(
                  color: appColors['primary'] ?? Colors.black,
                ),
              ),
            ),
            items: UserGender.values.map((UserGender u) {
              return DropdownMenuItem(
                value: u,
                child: Text(u.toString().split(".")[1]),
              );
            }).toList(),
            onChanged: (UserGender? u) {
              setState(() {
                _userGender = u!;
              });
            },
          ),
        ],
      ),
      const Spacer(),
      RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: const TextStyle(color: Colors.black),
          children: <TextSpan>[
            const TextSpan(
              text: 'By clicking on Sign up, you agree to MakeEasy’s ',
            ),
            TextSpan(
              text: 'Terms and Conditions ',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: appColors['primary'] ?? Colors.black,
              ),
              recognizer: TapGestureRecognizer()..onTap = () {
                // TODO: Open your Terms & Conditions link
              },
            ),
            const TextSpan(text: 'for more information.'),
          ],
        ),
      ),
      const SizedBox(height: 8),
      ElevatedButton(
        onPressed: _busy ? null : _handleSubmit,
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor,
          minimumSize: const Size.fromHeight(48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        child: _busy
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text(
                "Create account",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
      if (_errorText != null) ...[
        const SizedBox(height: 12),
        Text(
          _errorText!,
          style: const TextStyle(color: Colors.red),
        ),
      ],
      const SizedBox(height: 8),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Already have an account?"),
          TextButton(
            onPressed: _switchPage,
            child: const Text(
              "Log in",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: appGradients['primary']),
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: _isLoginPage ? _buildLoginPage() : _buildSignupPage(),
        ),
      ),
    );
  }
}
