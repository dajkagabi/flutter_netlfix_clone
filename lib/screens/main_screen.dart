import 'package:flutter/material.dart';
import 'package:flutter_netlfix_clone/screens/favorites_screen.dart';
import 'package:flutter_netlfix_clone/screens/home_screen.dart';
import 'package:flutter_netlfix_clone/screens/profile_screen.dart';
import 'package:flutter_netlfix_clone/screens/search_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // Aktuális lap indexe
  int _currentIndex = 0;

  // Navigációs lapok listája
  final List<Widget> _screens = [
    const HomeScreen(),
    const SearchScreen(),
    const FavoritesScreen(),
    const ProfileScreen(),
  ];

  // Bottom navigation
  final List<BottomNavigationBarItem> _bottomNavItems = [
    const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Főoldal'),
    const BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Keresés'),
    const BottomNavigationBarItem(
      icon: Icon(Icons.favorite),
      label: 'Kedvencek',
    ),
    const BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Aktuális képernyő megjelenítése
      body: _screens[_currentIndex],

      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: _bottomNavItems,
        // Fix elrendezés
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.black,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.white70,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}
