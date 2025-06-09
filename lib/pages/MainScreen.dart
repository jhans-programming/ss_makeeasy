import 'package:flutter/material.dart';
import 'package:makeeasy/pages/FavouritesPage.dart';
import 'package:makeeasy/pages/HomePage.dart';
import 'package:makeeasy/pages/InstructionsPage.dart';
import 'package:makeeasy/pages/RegisterPage.dart';
import 'package:makeeasy/pages/ProfilePage.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _pageIndex = 1;
  bool _signedIn = false;

  final List<Widget> _pages = <Widget>[
    FavouritesPage(),
    HomePage(),
    // InstructionsPage(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _pageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          _signedIn
              ? Center(child: _pages.elementAt(_pageIndex))
              : RegisterPage(
                onSubmit: () {
                  setState(() {
                    _signedIn = true;
                  });
                },
              ),
      bottomNavigationBar:
          _signedIn
              ? BottomNavigationBar(
                items: <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(Icons.favorite),
                    label: "Saved",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: "Home",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person),
                    label: "Profile",
                  ),
                ],
                currentIndex: _pageIndex,
                onTap: _onItemTapped,
              )
              : null,
    );
  }
}
