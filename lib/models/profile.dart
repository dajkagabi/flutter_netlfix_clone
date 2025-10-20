import 'package:flutter/material.dart';

class Profile {
  final String name;
  final IconData icon;
  final bool isAdult;
  final Color color;

  Profile({
    required this.name,
    required this.icon,
    required this.isAdult,
    required this.color,
  });
}
