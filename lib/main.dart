import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:makeeasy/states/favorites_notifier.dart';
import 'package:makeeasy/states/history_notifier.dart';
import 'package:provider/provider.dart';

import 'package:makeeasy/pages/MainScreen.dart';

final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.system);

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<UserHistoryNotifier>(
          create: (_) => UserHistoryNotifier(),
        ),
        ChangeNotifierProvider<FavoriteFiltersNotifier>(
          create: (_) => FavoriteFiltersNotifier(),
        ),
      ],
      child: MainApp(),
    ),
  );
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
            scaffoldBackgroundColor: const Color.fromARGB(255, 255, 239, 249),
            colorScheme: const ColorScheme(
              brightness: Brightness.light,
              primary: Color.fromARGB(255, 255, 50, 186),
              onPrimary: Color.fromARGB(255, 26, 26, 26),
              secondary: Color(0xffff7192),
              secondaryFixed: Color.fromARGB(255, 255, 190, 205),
              onSecondary: Colors.black,
              error: Colors.red,
              onError: Colors.black,
              surface: Colors.white,
              surfaceDim: Color.fromARGB(255, 245, 245, 245),
              onSurface: Color.fromARGB(255, 26, 26, 26),
            ),
          ),
          darkTheme: ThemeData(
            fontFamily: "Montserrat",
            brightness: Brightness.dark,
            scaffoldBackgroundColor: const Color(0xFF121212),
            colorScheme: const ColorScheme(
              brightness: Brightness.dark,
              primary: Color.fromARGB(255, 255, 50, 186),
              onPrimary: Colors.white,
              secondary: Color(0xffff7192),
              onSecondary: Colors.white,
              error: Colors.red,
              onError: Colors.white,
              surface: Color.fromARGB(255, 33, 33, 33),
              surfaceDim: Color.fromARGB(255, 56, 56, 56),

              onSurface: Colors.white,
            ),
          ),
          home: const MainScreen(),
        );
      },
    );
  }
}
