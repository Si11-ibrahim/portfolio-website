import 'package:flutter/material.dart';

import '../features/home/presentation/pages/home_page.dart';
import '../shared/theme/app_theme.dart';
import '../shared/theme/theme_provider.dart';
import '../shared/widgets/user_interaction_detector.dart';

class PortfolioApp extends StatefulWidget {
  const PortfolioApp({super.key});

  @override
  State<PortfolioApp> createState() => _PortfolioAppState();
}

class _PortfolioAppState extends State<PortfolioApp> {
  // Set dark mode as the default theme
  ThemeMode _themeMode = ThemeMode.dark;

  void _handleThemeModeChanged(ThemeMode mode) {
    setState(() {
      _themeMode = mode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ThemeProvider(
      themeMode: _themeMode,
      onThemeModeChanged: _handleThemeModeChanged,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Portfolio Website',
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: _themeMode,
        home: const UserInteractionDetector(
          child: HomePage(),
        ),
      ),
    );
  }
}
