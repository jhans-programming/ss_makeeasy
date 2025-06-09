// lib/RegisterPage.dart

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:makeeasy/utils/appStyle.dart';
import 'package:makeeasy/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key, required this.onSubmit});

  final VoidCallback onSubmit;

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

enum UserGender { Male, Female, Other }

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  UserGender _userGender = UserGender.Female; // default set to Female

  bool _isLoginPage = true;
  bool _busy = false;
  String? _errorText;

  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _passCtrl = TextEditingController();
  final TextEditingController _fullNameCtrl = TextEditingController();

  final AuthService _authSvc = AuthService();

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _fullNameCtrl.dispose();
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
        final user = await _authSvc.login(
          _emailCtrl.text.trim(),
          _passCtrl.text.trim(),
        );
        if (user != null) {
          widget.onSubmit();
        }
      } else {
        final user = await _authSvc.signUp(
          _emailCtrl.text.trim(),
          _passCtrl.text.trim(),
          _fullNameCtrl.text.trim(), // fullName is empty for now
          _userGender.toString().split('.').last,
        );

        if (user != null) {
          widget.onSubmit(); // Go to Home
        } else {
          setState(() {
            _errorText = "Sign up failed.";
          });
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
      _fullNameCtrl.clear();
      _userGender = UserGender.Female;
    });
  }

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
            _buildTextField(
              _emailCtrl,
              "Email",
              false,
              TextInputType.emailAddress,
            ),
            const SizedBox(height: 8.0),
            _buildTextField(_passCtrl, "Password", true),
            if (_errorText != null) ...[
              const SizedBox(height: 12),
              Text(_errorText!, style: const TextStyle(color: Colors.red)),
            ],
          ],
        ),
      ),
      const Spacer(),
      _buildSubmitButton("Log in"),
      const SizedBox(height: 8),
      _buildSwitchPageRow("Don't have an account?", "Sign up"),
    ];
  }

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
            _buildTextField(_fullNameCtrl, "Full Name"),
            const SizedBox(height: 8.0),
            _buildTextField(
              _emailCtrl,
              "Email",
              false,
              TextInputType.emailAddress,
            ),
            const SizedBox(height: 8.0),
            _buildTextField(_passCtrl, "Password", true),
            const SizedBox(height: 16),
            _buildGenderDropdown(),
          ],
        ),
      ),
      const Spacer(),
      _buildTermsText(),
      const SizedBox(height: 8),
      _buildSubmitButton("Create account"),
      if (_errorText != null) ...[
        const SizedBox(height: 12),
        Text(_errorText!, style: const TextStyle(color: Colors.red)),
      ],
      const SizedBox(height: 8),
      _buildSwitchPageRow("Already have an account?", "Log in"),
    ];
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, [
    bool obscureText = false,
    TextInputType? keyboardType,
  ]) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        label: Text(label, style: appTextStyles['textFormFieldLabel']),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide(
            color: appColors['primaryLight2'] ?? Colors.black,
          ),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your $label';
        }
        if (label == "Email" && !value.contains('@')) {
          return 'Enter a valid email';
        }
        if (label == "Password" && value.length < 6) {
          return 'Password must be at least 6 characters';
        }
        return null;
      },
    );
  }

  Widget _buildGenderDropdown() {
    return DropdownButtonFormField<UserGender>(
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
          borderSide: BorderSide(color: appColors['primary'] ?? Colors.black),
        ),
      ),
      items:
          UserGender.values.map((UserGender gender) {
            return DropdownMenuItem(
              value: gender,
              child: Text(gender.toString().split(".")[1]),
            );
          }).toList(),
      onChanged: (UserGender? gender) {
        setState(() {
          _userGender = gender!;
        });
      },
    );
  }

  Widget _buildSubmitButton(String text) {
    return ElevatedButton(
      onPressed: _busy ? null : _handleSubmit,
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).primaryColor,
        minimumSize: const Size.fromHeight(48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      ),
      child:
          _busy
              ? const CircularProgressIndicator(color: Colors.white)
              : Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
    );
  }

  Widget _buildSwitchPageRow(String label, String buttonText) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(label),
        TextButton(
          onPressed: _switchPage,
          child: Text(
            buttonText,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _buildTermsText() {
    return RichText(
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
            recognizer:
                TapGestureRecognizer()
                  ..onTap = () {
                    // TODO: Open Terms & Conditions
                  },
          ),
          const TextSpan(text: 'for more information.'),
        ],
      ),
    );
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
