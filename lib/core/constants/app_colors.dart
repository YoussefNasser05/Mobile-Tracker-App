import 'package:flutter/material.dart';

class AppColors {
  static const background = Color(0xFF0A0A14);
  static const surface = Color(0xFF13132A);
  static const surfaceElevated = Color(0xFF1E1E3F);

  static const textPrimary = Color(0xFFFFFFFF);
  static const textSecondary = Color(0xFFA0A0C0);
  static const textMuted = Color(0xFF60607A);

  static const accent = Color(0xFF6366F1);
  static const accentSoft = Color(0xFF312E81);
  static const accentLight = Color(0xFF818CF8);

  static const danger = Color(0xFFFF6B6B);
  static const warning = Color(0xFFFFB347);
  static const success = Color(0xFF6BCB77);

  static const cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1E1E3F), Color(0xFF13132A)],
  );

  static const heroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF4F46E5), Color(0xFF312E81)],
  );
}
