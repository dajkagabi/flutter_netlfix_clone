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
    final isKidProfile = selectedProfile?.name == 'Gyerek';

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
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40),

                // Profil ikon
                Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    color: profileColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(75),
                    border: Border.all(color: profileColor, width: 3),
                  ),
                  child: Center(
                    child: Icon(
                      selectedProfile?.icon ?? AppIcons.adultProfile,
                      color: profileColor,
                      size: 60,
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // Profil név
                Text(
                  selectedProfile?.name ?? 'Profil',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),

                // Profil típus
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: isKidProfile
                        ? Colors.orange.withOpacity(0.2)
                        : Colors.blue.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isKidProfile ? Colors.orange : Colors.blue,
                      width: 1,
                    ),
                  ),
                  child: Text(
                    isKidProfile ? 'Gyerek profil' : 'Felnőtt profil',
                    style: TextStyle(
                      color: isKidProfile ? Colors.orange : Colors.blue,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // Profil információk
                _buildProfileInfoSection(profileColor),
                const SizedBox(height: 30),

                // Üzenet a gyerek profilhoz
                if (isKidProfile) ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.orange.withOpacity(0.3)),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.build_circle_outlined,
                          color: Colors.orange,
                          size: 40,
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'A gyerek sarok jelenleg fejlesztés alatt van. Hamarosan elérhető lesz!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            height: 1.4,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ] else ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.withOpacity(0.3)),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.hourglass_empty,
                          color: Colors.grey.shade400,
                          size: 40,
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'További funkciók hamarosan elérhetőek...',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                            height: 1.4,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],

                const SizedBox(height: 40),

                // Profil váltása gomb
                ElevatedButton(
                  onPressed: () => _switchProfile(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Profil váltása',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),

                const SizedBox(height: 20),

                // További beállítások gomb
                OutlinedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Profil beállítások hamarosan elérhetőek',
                        ),
                        backgroundColor: Colors.red,
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white70,
                    side: const BorderSide(color: Colors.white70),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('További beállítások'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileInfoSection(Color profileColor) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade800),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Profil információk',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildInfoRow('Létrehozva', '2024. január'),
          _buildInfoRow('Kedvenc műfaj', 'Akció, Kaland'),
          _buildInfoRow('Megtekintések', '124 film'),
          _buildInfoRow('Utolsó aktivitás', '2 órája'),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
