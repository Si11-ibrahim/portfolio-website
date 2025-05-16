import 'package:flutter/material.dart';

class InteractiveIntro extends StatefulWidget {
  const InteractiveIntro({super.key});

  @override
  State<InteractiveIntro> createState() => _InteractiveIntroState();
}

class _InteractiveIntroState extends State<InteractiveIntro>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeInAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  final List<Map<String, dynamic>> _features = [
    {
      'icon': Icons.category,
      'title': 'Tech Skills Explorer',
      'description':
          'Interactive display of my technical skills with proficiency levels. Tap on a skill to learn more.',
    },
    {
      'icon': Icons.code_outlined,
      'title': 'Code Breaker Game',
      'description':
          'Put your logical thinking to the test in this coding-themed puzzle game.',
    }
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeInAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.7, curve: Curves.easeOut),
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.1, 0.8, curve: Curves.easeOutCubic),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.1, 0.7, curve: Curves.easeOut),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 600;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeInAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Container(
                padding: EdgeInsets.all(isSmallScreen ? 16.0 : 24.0),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Theme.of(context)
                          .colorScheme
                          .primaryContainer
                          .withOpacity(0.7),
                      Theme.of(context)
                          .colorScheme
                          .surfaceContainerHighest
                          .withOpacity(0.7),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      'Welcome to the Interactive Zone!',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 20.0 : 24.0,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Explore and interact with these components to get a better understanding of my skills and coding abilities.',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 14.0 : 16.0,
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.8),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        return constraints.maxWidth > 500
                            ? Row(
                                mainAxisSize: MainAxisSize.min,
                                children: _buildFeatureItems(isSmallScreen),
                              )
                            : Column(
                                mainAxisSize: MainAxisSize.min,
                                children: _buildFeatureItems(isSmallScreen),
                              );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  List<Widget> _buildFeatureItems(bool isSmallScreen) {
    return _features.map((feature) {
      return Flexible(
        fit: FlexFit.loose,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Icon(
                feature['icon'] as IconData,
                size: isSmallScreen ? 32 : 40,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 12),
              Text(
                feature['title'] as String,
                style: TextStyle(
                  fontSize: isSmallScreen ? 16 : 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                feature['description'] as String,
                style: TextStyle(
                  fontSize: isSmallScreen ? 13 : 14,
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }).toList();
  }
}
