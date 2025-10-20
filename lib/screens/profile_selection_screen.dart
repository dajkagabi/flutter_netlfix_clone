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
      _showNewProfileScreen();
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

  // Új profil
  void _showNewProfileScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NewProfileScreen(
          onSave: (newProfile) {
            setState(() {
              _profiles.insert(_profiles.length - 1, newProfile);
            });
          },
        ),
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
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200,
        mainAxisSpacing: 20,
        crossAxisSpacing: 20,
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
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: profile.color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(60),
              border: Border.all(color: profile.color, width: 2),
            ),
            child: Center(
              child: Icon(profile.icon, color: profile.color, size: 48),
            ),
          ),
          const SizedBox(height: 12),
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

//  Új profil
class NewProfileScreen extends StatefulWidget {
  final Function(Profile) onSave;

  const NewProfileScreen({super.key, required this.onSave});

  @override
  State<NewProfileScreen> createState() => _NewProfileScreenState();
}

class _NewProfileScreenState extends State<NewProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  bool _isAdult = true;
  Color _selectedColor = Colors.blueGrey.shade400;

  final List<Color> _colors = [
    Colors.blue.shade400,
    Colors.green.shade400,
    Colors.orange.shade400,
    Colors.purple.shade400,
    Colors.red.shade400,
    Colors.yellow.shade400,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Új profil', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Avatar
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: _selectedColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(60),
                border: Border.all(color: _selectedColor, width: 2),
              ),
              child: const Center(
                child: Icon(
                  AppIcons.adultProfile,
                  color: Colors.white,
                  size: 48,
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Név mező
            TextField(
              controller: _nameController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Profil név',
                labelStyle: TextStyle(color: Colors.white70),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white70),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Felnőtt/Gyerek váltó
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Felnőtt', style: TextStyle(color: Colors.white70)),
                Switch(
                  value: _isAdult,
                  onChanged: (val) => setState(() => _isAdult = val),
                  activeColor: Colors.red,
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Színválasztó
            Wrap(
              spacing: 10,
              children: _colors.map((color) {
                return GestureDetector(
                  onTap: () => setState(() => _selectedColor = color),
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: _selectedColor == color
                          ? Border.all(color: Colors.white, width: 3)
                          : null,
                    ),
                  ),
                );
              }).toList(),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                final newProfile = Profile(
                  name: _nameController.text.isEmpty
                      ? 'Új profil'
                      : _nameController.text,
                  icon: AppIcons.adultProfile,
                  isAdult: _isAdult,
                  color: _selectedColor,
                );
                widget.onSave(newProfile);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 12,
                ),
              ),
              child: const Text(
                'Mentés',
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
