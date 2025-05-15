import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTheme {
  // Custom fonts
  static const _fontFamily = 'League Spartan';

  static ThemeData get light {
    // Keep your existing light theme
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blue,
        brightness: Brightness.light,
      ),
      useMaterial3: true,
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
        bodyLarge: TextStyle(
          fontSize: 18,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 15,
          ),
        ),
      ),
    );
  }

  static ThemeData get dark {
    // Enhanced dark theme with a professional, modern look
    const primaryColor = Color(0xFF6D5CFF); // Rich purple-blue
    const accentColor = Color(0xFF56E8FF); // Cyan accent
    const darkBgColor = Color(0xFF10121F); // Deep blue-black
    const surfaceColor = Color(0xFF1A1D30); // Slightly lighter background
    const cardColor = Color(0xFF242942); // Card background

    final darkColorScheme = ColorScheme(
      brightness: Brightness.dark,
      primary: primaryColor,
      onPrimary: Colors.white,
      primaryContainer: primaryColor.withOpacity(0.15),
      onPrimaryContainer: Colors.white.withOpacity(0.9),
      secondary: accentColor,
      onSecondary: Colors.black,
      secondaryContainer: accentColor.withOpacity(0.15),
      onSecondaryContainer: accentColor,
      tertiary: const Color(0xFFFFAB91), // Soft coral
      onTertiary: Colors.black,
      tertiaryContainer: const Color(0xFF21242F),
      onTertiaryContainer: const Color(0xFFFFAB91).withOpacity(0.8),
      error: const Color(0xFFE57373),
      onError: Colors.black,
      errorContainer: const Color(0x40E57373),
      onErrorContainer: const Color(0xFFE57373),
      surface: surfaceColor,
      onSurface: Colors.white.withOpacity(0.9),
      surfaceContainerHighest: cardColor,
      onSurfaceVariant: Colors.white.withOpacity(0.8),
      outline: Colors.white30,
      shadow: Colors.black.withOpacity(0.5),
      inverseSurface: Colors.white.withOpacity(0.1),
      onInverseSurface: Colors.white,
      inversePrimary: primaryColor.withOpacity(0.2),
      surfaceTint: primaryColor.withOpacity(0.05),
    );

    return ThemeData(
      colorScheme: darkColorScheme,
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: darkBgColor,
      cardColor: cardColor,
      appBarTheme: AppBarTheme(
        backgroundColor: darkBgColor.withOpacity(0.8),
        foregroundColor: Colors.white,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          fontFamily: _fontFamily,
        ),
      ),
      dividerTheme: DividerThemeData(
        color: Colors.white.withOpacity(0.1),
        thickness: 1,
      ),
      textTheme: TextTheme(
        // Headers
        displayLarge: TextStyle(
          fontSize: 57,
          fontWeight: FontWeight.bold,
          color: Colors.white.withOpacity(0.95),
          fontFamily: _fontFamily,
          height: 1.1,
        ),
        displayMedium: TextStyle(
          fontSize: 45,
          fontWeight: FontWeight.bold,
          color: Colors.white.withOpacity(0.95),
          fontFamily: _fontFamily,
          height: 1.1,
        ),
        displaySmall: TextStyle(
          fontSize: 36,
          fontWeight: FontWeight.w700,
          color: Colors.white.withOpacity(0.95),
          fontFamily: _fontFamily,
          height: 1.1,
        ),
        // Section headers
        headlineLarge: const TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontFamily: _fontFamily,
          letterSpacing: -0.5,
        ),
        headlineMedium: const TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontFamily: _fontFamily,
        ),
        headlineSmall: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontFamily: _fontFamily,
        ),
        // Body text
        bodyLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.normal,
          color: Colors.white.withOpacity(0.9),
          fontFamily: _fontFamily,
          height: 1.5,
        ),
        bodyMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: Colors.white.withOpacity(0.9),
          fontFamily: _fontFamily,
          height: 1.5,
        ),
        bodySmall: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: Colors.white.withOpacity(0.8),
          fontFamily: _fontFamily,
          height: 1.4,
        ),
        // Labels
        labelLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.white.withOpacity(0.9),
          fontFamily: _fontFamily,
        ),
        labelMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.white.withOpacity(0.9),
          fontFamily: _fontFamily,
        ),
        labelSmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: Colors.white.withOpacity(0.8),
          fontFamily: _fontFamily,
          letterSpacing: 0.5,
        ),
      ),
      // Code font for any code blocks
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: accentColor,
        selectionColor: accentColor.withOpacity(0.3),
        selectionHandleColor: accentColor,
      ),
      // Special buttons styling
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 16,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 4,
          shadowColor: primaryColor.withOpacity(0.5),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: _fontFamily,
            letterSpacing: 0.5,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.white,
          side: const BorderSide(color: primaryColor, width: 2),
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 16,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: _fontFamily,
            letterSpacing: 0.5,
          ),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: Colors.white.withOpacity(0.9),
          hoverColor: primaryColor.withOpacity(0.2),
        ),
      ),
      cardTheme: CardTheme(
        color: cardColor,
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        shadowColor: Colors.black.withOpacity(0.5),
      ),
      drawerTheme: DrawerThemeData(
        backgroundColor: surfaceColor,
        elevation: 10,
        scrimColor: Colors.black.withOpacity(0.6),
      ),
      dialogTheme: DialogTheme(
        backgroundColor: surfaceColor,
        elevation: 15,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: surfaceColor,
        contentTextStyle: TextStyle(
          color: Colors.white.withOpacity(0.9),
          fontFamily: _fontFamily,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: surfaceColor.withOpacity(0.9),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Colors.white.withOpacity(0.2),
            width: 1,
          ),
        ),
        textStyle: TextStyle(
          color: Colors.white.withOpacity(0.9),
          fontSize: 12,
          fontFamily: _fontFamily,
        ),
      ),
      // Animations and transitions
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: ZoomPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.windows: ZoomPageTransitionsBuilder(),
          TargetPlatform.linux: ZoomPageTransitionsBuilder(),
        },
      ),
    );
  }
}
