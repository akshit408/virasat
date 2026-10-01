import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Official VIRASAT Brand Palette
  static const Color primaryTerracotta = Color(0xFFA63E24); // Primary Terracotta #A63E24
  static const Color cream = Color(0xFFFFF8F1); // Cream #FFF8F1
  static const Color forestGreen = Color(0xFF1F5E45); // Forest Green #1F5E45
  static const Color saffronGold = Color(0xFFE5A34B); // Saffron Gold #E5A34B
  static const Color darkBrown = Color(0xFF3B2314); // Dark Brown #3B2314

  // Theme Alias Tokens
  static const Color primary = primaryTerracotta; // Terracotta
  static const Color secondary = saffronGold; // Saffron Gold
  static const Color background = cream; // Cream Warm Background
  static const Color surface = Color(0xFFFFFDF8); // Warm Cream Surface
  static const Color success = forestGreen; // Sage/Forest Green
  static const Color accent = Color(0xFF8C2F1D); // Deep Maroon

  // Neutral & Text Tokens
  static const Color textPrimary = Color(0xFF2F2A26); // Deep Charcoal
  static const Color textSecondary = Color(0xFF6D625B); // Warm Muted Brown
  static const Color textLight = Color(0xFF9E9288); // Soft Slate Text
  static const Color border = Color(0xFFE6DCCF); // Soft Sand Border
  static const Color error = Color(0xFFB23A2B); // Rust Red

  // Extra Tokens & Surfaces
  static const Color cardShadow = Color(0x142F2A26);
  static const Color chipBackground = Color(0xFFEFE8DD);
  static const Color surfaceVariant = Color(0xFFEFE8DD);
  static const Color divider = Color(0xFFEADBCE);
  static const Color goldLight = Color(0xFFE5C880);
  static const Color terracottaLight = Color(0xFFD97960);
  static const Color sageLight = Color(0xFF7E9786);

  // Aliases for AI Scanner components
  static const Color primaryGold = secondary;
  static const Color primaryIndigo = Color(0xFF2C3E50);
  static const Color cardBorder = border;

  // Heritage Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFFB55239), Color(0xFF8C2F1D)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient goldGradient = LinearGradient(
    colors: [Color(0xFFE5C880), Color(0xFFC89B3C)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient terracottaGoldGradient = LinearGradient(
    colors: [Color(0xFFB55239), Color(0xFFC89B3C)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
