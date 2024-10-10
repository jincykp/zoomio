import 'package:flutter/material.dart';

class FanMenuItem {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  FanMenuItem({
    required this.title,
    required this.icon,
    required this.onTap,
  });
}
