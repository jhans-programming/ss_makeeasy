import 'package:flutter/material.dart';
import 'package:makeeasy/pages/HistoryDetailPage.dart';
import 'package:makeeasy/pages/HistoryPage.dart'; // Ensure this file contains the HistoryPage class
import 'package:makeeasy/pages/RegisterPage.dart';

import 'package:makeeasy/pages/MainScreen.dart';

final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.system);

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  // Halo ini thania :V

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, themeMode, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          themeMode: themeMode,
          theme: ThemeData(
            fontFamily: "Montserrat",
            brightness: Brightness.light,
            colorScheme: const ColorScheme(
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
          darkTheme: ThemeData(
            fontFamily: "Montserrat",
            brightness: Brightness.dark,
            scaffoldBackgroundColor: const Color(0xFF121212),
            colorScheme: const ColorScheme(
              brightness: Brightness.dark,
              primary: Color(0xffff00a8),
              onPrimary: Colors.white,
              secondary: Color(0xffff7192),
              onSecondary: Colors.white,
              error: Colors.red,
              onError: Colors.white,
              surface: Color(0xFF1E1E1E),
              onSurface: Colors.white,
            ),
          ),
          home: const MainScreen(),
        );
      },
    );
  }
}
