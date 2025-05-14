import 'package:flutter/material.dart';
import 'package:makeeasy/pages/RegisterPage.dart';
import 'package:makeeasy/pages/MainScreen.dart';
import 'package:makeeasy/utils/appStyle.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        fontFamily: "Montserrat",
        colorScheme: ColorScheme(
          brightness: Brightness.light,
          primary: Color(0xffff00a8),
          onPrimary: Colors.black,
          secondary: Color(0xffff7192),
          onSecondary: Colors.black,
          error: Colors.red,
          onError: Colors.black,
          surface: Colors.white,
          onSurface: Colors.black,
        ),
      ),
      home: MainScreen(),
    );
  }
}
