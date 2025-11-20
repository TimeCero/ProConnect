import 'package:flutter/material.dart';
import 'colors.dart';
import 'text_styles.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Asigna el tema usando el método light()
  static final ThemeData theme = light();

  // Tema light centralizado
  static ThemeData light() {
    // Base typographic theme usando Google Fonts (Inter)
    final baseText = GoogleFonts.interTextTheme();

    return ThemeData(
      // Paleta básica
      scaffoldBackgroundColor: AppColors.background,
      primaryColor: AppColors.primary,

      // ColorScheme (desde un seed color)
      colorScheme: ColorScheme.fromSeed(seedColor: AppColors.accent),

      // TextTheme actualizado usando los nombres nuevos (Material 3)
      textTheme: baseText.copyWith(
        // Mapea tus estilos personalizados a los nuevos nombres
        displayLarge: AppTextStyles.heading1, // antes headline1
        titleLarge: AppTextStyles.heading2, // antes headline6
        bodyLarge: AppTextStyles.body, // antes bodyText1
        bodySmall: AppTextStyles.small, // antes caption
      ),

      // Input fields
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),

      // Botones principales (Naranja)
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accent,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          textStyle: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
          elevation: 3,
        ),
      ),

      // Tarjetas
      cardTheme: CardTheme(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        elevation: 3,
      ),

      // AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.primary,
        elevation: 0,
        titleTextStyle: AppTextStyles.heading2.copyWith(color: Colors.white),
        iconTheme: IconThemeData(color: Colors.white),
      ),
    );
  }
}
