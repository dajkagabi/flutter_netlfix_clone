import 'package:flutter/material.dart';
import '../models/profile.dart';
import '../utils/app_icons.dart';
import 'profile_selection_screen.dart';

class ProfileScreen extends StatelessWidget {
  final Profile? selectedProfile;

  const ProfileScreen({super.key, this.selectedProfile});

  void _switchProfile(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const ProfileSelectionScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profileColor = selectedProfile?.color ?? Colors.grey.shade400;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          selectedProfile?.name ?? 'Profil',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(AppIcons.switchProfile, color: Colors.white),
            onPressed: () => _switchProfile(context),
            tooltip: 'Profil váltása',
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Profil ikon - Flutter ikonnal
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: profileColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(60),
              border: Border.all(color: profileColor, width: 2),
            ),
            child: Center(
              child: Icon(
                selectedProfile?.icon ?? AppIcons.adultProfile,
                color: profileColor,
                size: 48,
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Profil név
          Text(
            selectedProfile?.name ?? 'Profil',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          // Üzenet a gyerek profilhoz
          if (selectedProfile?.name == 'Gyerek') ...[
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 40.0),
              child: Text(
                'A gyerek sarok jelenleg fejlesztés alatt van. Hamarosan elérhető lesz!',
                style: TextStyle(color: Colors.white70, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
          ] else ...[
            const SizedBox(height: 20),
            const Text(
              'Hamarosan elérhető...',
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
          ],
          const SizedBox(height: 30),
          // Profil váltása gomb
          ElevatedButton(
            onPressed: () => _switchProfile(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
            ),
            child: const Text('Profil váltása'),
          ),
        ],
      ),
    );
  }
}
