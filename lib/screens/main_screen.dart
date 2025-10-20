import 'package:flutter/material.dart';
import 'package:flutter_netlfix_clone/screens/favorites_screen.dart';
import 'package:flutter_netlfix_clone/screens/home_screen.dart';
import 'package:flutter_netlfix_clone/screens/profile_screen.dart';
import 'package:flutter_netlfix_clone/screens/search_screen.dart';
import 'package:flutter_netlfix_clone/utils/app_icons.dart';
import '../models/profile.dart';

class MainScreen extends StatefulWidget {
  final Profile? selectedProfile;

  const MainScreen({super.key, this.selectedProfile});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  Profile? _selectedProfile;

  @override
  void initState() {
    super.initState();
    _selectedProfile = widget.selectedProfile;
  }

  List<Widget> get _screens {
    return [
      const HomeScreen(),
      const SearchScreen(),
      const FavoritesScreen(),
      ProfileScreen(selectedProfile: _selectedProfile),
    ];
  }

  final List<BottomNavigationBarItem> _bottomNavItems = [
    const BottomNavigationBarItem(
      icon: Icon(AppIcons.home),
      activeIcon: Icon(Icons.home),
      label: 'Főoldal',
    ),
    const BottomNavigationBarItem(
      icon: Icon(AppIcons.search),
      activeIcon: Icon(Icons.search),
      label: 'Keresés',
    ),
    const BottomNavigationBarItem(
      icon: Icon(AppIcons.favorites),
      activeIcon: Icon(Icons.favorite),
      label: 'Kedvencek',
    ),
    const BottomNavigationBarItem(
      icon: Icon(AppIcons.profile),
      activeIcon: Icon(Icons.person),
      label: 'Profil',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: _bottomNavItems,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.black,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.white70,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}
