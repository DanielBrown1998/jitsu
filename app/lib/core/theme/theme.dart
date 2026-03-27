import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Paleta do Figma design/figma/src/styles/theme.css
  static const Color primary = Color(0xFF030213);
  static const Color primaryForeground = Color(0xFFFFFFFF);
  static const Color secondary = Color(0xFFEBEDF1); // aproximado do oklch leve
  static const Color secondaryForeground = Color(0xFF030213);
  static const Color background = Color(0xFFFFFFFF);
  static const Color foreground = Color(0xFF030213);
  static const Color card = Color(0xFFFFFFFF);
  static const Color cardForeground = Color(0xFF030213);
  static const Color accent = Color(0xFFE9EBEF);
  static const Color destructive = Color(0xFFD4183D);
  static const Color border = Color(0x1A000000); // rgba(0,0,0,0.1)
  static const Color inputBackground = Color(0xFFF3F3F5);
  static const Color switchBackground = Color(0xFFCBCED4);

  static ThemeData lightTheme() {
    final colorScheme =
        ColorScheme.fromSeed(
          seedColor: primary,
          brightness: Brightness.light,
        ).copyWith(
          primary: primary,
          onPrimary: primaryForeground,
          secondary: secondary,
          onSecondary: secondaryForeground,
          surface: card,
          onSurface: cardForeground,
          error: destructive,
          onError: Colors.white,
        );

    return ThemeData(
      useMaterial3: true,
      fontFamily: GoogleFonts.inter().fontFamily,
      textTheme: GoogleFonts.interTextTheme(
        TextTheme(
          headlineLarge: TextStyle(
            color: foreground,
            fontWeight: FontWeight.w600,
          ),
          headlineMedium: TextStyle(
            color: foreground,
            fontWeight: FontWeight.w600,
          ),
          bodyLarge: TextStyle(color: foreground),
          bodyMedium: TextStyle(color: foreground),
          labelLarge: TextStyle(color: foreground, fontWeight: FontWeight.w500),
        ),
      ),
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 0,
        surfaceTintColor: colorScheme.primary,
      ),
      cardTheme: CardThemeData(
        color: card,
        surfaceTintColor: card,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: border),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: inputBackground,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: border),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      
      switchTheme: SwitchThemeData(
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return switchBackground;
          return switchBackground.withOpacity(0.9);
        }),
        thumbColor: WidgetStateProperty.all(colorScheme.primary),
      ),
    );
  }

  static ThemeData darkTheme() {
    final colorScheme =
        ColorScheme.fromSeed(
          seedColor: Color(0xFF1A1C24),
          brightness: Brightness.dark,
        ).copyWith(
          primary: Color(0xFFEDEDED),
          onPrimary: Color(0xFF030213),
          secondary: Color(0xFF4A4A4A),
          onSecondary: Color(0xFFEDEDED),
          surface: Color(0xFF1A1C24),
          onSurface: Color(0xFFEDEDED),
          error: Color(0xFFB71C1C),
          onError: Colors.white,
        );

    return ThemeData(
      useMaterial3: true,
      fontFamily: GoogleFonts.inter().fontFamily,
      textTheme: GoogleFonts.interTextTheme(
        TextTheme(
          headlineLarge: TextStyle(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
          headlineMedium: TextStyle(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
          bodyLarge: TextStyle(color: colorScheme.onSurface),
          bodyMedium: TextStyle(color: colorScheme.onSurface),
        ),
      ),
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
      ),
      cardTheme: CardThemeData(
        color: colorScheme.surface,
        surfaceTintColor: colorScheme.surface,
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Color(0xFF252A37),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Color(0xFF2B2F3C)),
        ),
      ),
    );
  }
}
