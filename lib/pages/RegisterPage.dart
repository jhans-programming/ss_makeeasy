import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:makeeasy/utils/appStyle.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key, required this.onSubmit});

  final Function onSubmit;

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

enum UserGender { Male, Female, Other }

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  UserGender? _userGender = UserGender.Male;

  bool _isLoginPage = true;

  void _handleLogin() {
    widget.onSubmit();
  }

  void _switchPage() {
    setState(() {
      _isLoginPage = !_isLoginPage;
    });
  }

  List<Widget> _buildLoginPage() {
    return [
      Spacer(),
      Image(image: AssetImage('assets/images/logo.png')),
      Text("Log into your account", style: appTextStyles['normalBlack']),
      SizedBox(height: 16.0),
      Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              style: appTextStyles['textFormField'],
              decoration: InputDecoration(
                label: Text(
                  "Username",
                  style: appTextStyles['textFormFieldLabel'],
                ),

                filled: true,
                fillColor: Colors.white,

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide(color: Colors.red),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide(
                    color: appColors['primaryLight2'] ?? Colors.black,
                  ),
                ),
              ),
            ),
            SizedBox(height: 8.0),
            TextFormField(
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
                  borderSide: BorderSide(color: Colors.red),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide(
                    color: appColors['primaryLight2'] ?? Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      Spacer(),
      ElevatedButton(
        onPressed: _handleLogin,
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor,
        ),
        child: Center(
          child: Text(
            "Log in",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Don't have an account?"),
          TextButton(
            onPressed: _switchPage,
            child: Text(
              "Sign up",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    ];
  }

  List<Widget> _buildSignupPage() {
    return [
      Spacer(),
      Image(image: AssetImage("assets/images/logo.png"), width: 128),
      Text("Create a new account", style: appTextStyles['normalBlack']),
      SizedBox(height: 16),
      Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(
                label: Text(
                  "Username",
                  style: appTextStyles['textFormFieldLabel'],
                ),

                filled: true,
                fillColor: Colors.white,

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide(color: Colors.red),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide(
                    color: appColors['primaryLight2'] ?? Colors.black,
                  ),
                ),
              ),
            ),
            SizedBox(height: 8.0),
            TextFormField(
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
                  borderSide: BorderSide(color: Colors.red),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide(
                    color: appColors['primaryLight2'] ?? Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      SizedBox(height: 16),
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
          DropdownButtonFormField(
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
            items:
                UserGender.values.map((UserGender u) {
                  return DropdownMenuItem(
                    value: u,
                    child: Text(u.toString().split(".")[1]),
                  );
                }).toList(),
            onChanged: (UserGender? u) {
              setState(() {
                _userGender = u;
              });
            },
          ),
        ],
      ),
      Spacer(),
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
              recognizer: TapGestureRecognizer()..onTap = () {},
            ),
            const TextSpan(text: 'for more information.'),
          ],
        ),
      ),
      SizedBox(height: 8),
      ElevatedButton(
        onPressed: _handleLogin,
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor,
        ),
        child: Center(
          child: Text(
            "Create account",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Already have an account?"),
          TextButton(
            onPressed: _switchPage,
            child: Text(
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
      width: MediaQuery.sizeOf(context).width,
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
