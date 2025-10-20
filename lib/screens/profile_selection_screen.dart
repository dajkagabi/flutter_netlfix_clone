import 'package:flutter/material.dart';
import '../models/profile.dart';
import '../utils/app_icons.dart';
import 'main_screen.dart';

class ProfileSelectionScreen extends StatefulWidget {
  const ProfileSelectionScreen({super.key});

  @override
  State<ProfileSelectionScreen> createState() => _ProfileSelectionScreenState();
}

class _ProfileSelectionScreenState extends State<ProfileSelectionScreen> {
  final List<Profile> _profiles = [
    Profile(
      name: 'Profil1',
      icon: AppIcons.adultProfile,
      isAdult: true,
      color: Colors.blue.shade400,
    ),
    Profile(
      name: 'Profil2',
      icon: AppIcons.adultProfile,
      isAdult: true,
      color: Colors.green.shade400,
    ),
    Profile(
      name: 'Gyerek',
      icon: AppIcons.kidsProfile,
      isAdult: false,
      color: Colors.orange.shade400,
    ),
    Profile(
      name: 'Új profil',
      icon: AppIcons.addProfile,
      isAdult: true,
      color: Colors.grey.shade400,
    ),
  ];

  void _selectProfile(Profile profile) {
    if (profile.name == 'Új profil') {
      _navigateToMainScreen(profile);
    } else if (profile.name == 'Gyerek') {
      _showKidsProfileDialog(profile);
    } else {
      _navigateToMainScreen(profile);
    }
  }

  void _navigateToMainScreen(Profile profile) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => MainScreen(selectedProfile: profile),
      ),
    );
  }

  void _showKidsProfileDialog(Profile profile) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text(
          'Gyerek profil',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'A gyerek sarok jelenleg fejlesztés alatt van. Hamarosan elérhető lesz!',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Rendben', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),

            Expanded(child: _buildProfileGrid()),

            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return const Padding(
      padding: EdgeInsets.all(20.0),
      child: Column(
        children: [
          Text(
            "Ki néz?",
            style: TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildProfileGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        childAspectRatio: 0.8,
      ),
      itemCount: _profiles.length,
      itemBuilder: (context, index) {
        final profile = _profiles[index];
        return _buildProfileItem(profile);
      },
    );
  }

  Widget _buildProfileItem(Profile profile) {
    return GestureDetector(
      onTap: () => _selectProfile(profile),
      child: Column(
        children: [
          // Profil ikon - Flutter ikonnal
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: profile.color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(60), // Kör alakú
              border: Border.all(color: profile.color, width: 2),
            ),
            child: Center(
              child: Icon(profile.icon, color: profile.color, size: 48),
            ),
          ),
          const SizedBox(height: 12),
          // Profil név
          Text(
            profile.name,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          // Profil kezelése gomb
          OutlinedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Profil kezelése hamarosan elérhető'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              side: const BorderSide(color: Colors.white),
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
            ),
            child: const Text('Profil kezelése'),
          ),
        ],
      ),
    );
  }
}
