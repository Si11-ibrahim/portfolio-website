import 'dart:math' as math;

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

import '../../../../shared/widgets/sound_button.dart';
import '../../../../shared/widgets/typing_text.dart';
import '../../../../shared/widgets/welcome_card.dart';

// Define a typedef for the scroll function
typedef ScrollToSectionCallback = void Function(String section);

// Animation timing constants
class AnimationTiming {
  static const Duration entranceDuration = Duration(milliseconds: 2000);
  static const Duration continuousDuration = Duration(seconds: 2);
  static const Duration confettiDuration = Duration(seconds: 2);

  // Animation intervals
  static const Interval welcomeInterval =
      Interval(0.0, 0.3, curve: Curves.easeOut);
  static const Interval profilePicInterval =
      Interval(0.15, 0.45, curve: Curves.easeOut);
  static const Interval nameInterval =
      Interval(0.3, 0.6, curve: Curves.easeOut);
  static const Interval roleInterval =
      Interval(0.45, 0.75, curve: Curves.easeOut);
  static const Interval buttonsInterval =
      Interval(0.6, 0.9, curve: Curves.easeOut);
}

class HeroSection extends StatefulWidget {
  final ScrollToSectionCallback? onScrollToSection;

  const HeroSection({
    super.key,
    this.onScrollToSection,
  });

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection>
    with TickerProviderStateMixin {
  // Split into two controllers - one for entrance animations (runs once) and one for continuous animations
  late AnimationController _entranceController;
  late AnimationController _continuousController;

  // Confetti controller for welcome animation
  late ConfettiController _confettiController;

  // One-time entrance animations
  late Animation<double> _welcomeAnimation;
  late Animation<double> _nameAnimation;
  late Animation<double> _roleAnimation;
  late Animation<double> _buttonsAnimation;
  late Animation<double> _profilePicAnimation;

  @override
  void initState() {
    super.initState();

    // Controller for one-time entrance animations
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(
          milliseconds: 2000), // Entrance animations complete in 2 seconds
    );

    // Controller for continuous animations that keep running
    _continuousController = AnimationController(
      vsync: this,
      duration:
          const Duration(seconds: 2), // Shorter loop for continuous animations
    )..repeat();

    // Initialize confetti controller
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 2),
    );

    // Setup entrance animations to play only once in sequence
    _welcomeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.0, 0.3, curve: Curves.easeOut),
      ),
    );

    _profilePicAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.15, 0.45, curve: Curves.easeOut),
      ),
    );

    _nameAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.3, 0.6, curve: Curves.easeOut),
      ),
    );

    _roleAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.45, 0.75, curve: Curves.easeOut),
      ),
    );

    _buttonsAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.6, 0.9, curve: Curves.easeOut),
      ),
    );

    // Start the entrance animations once
    _entranceController.forward();
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _continuousController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  void _scrollToSection(String section) {
    if (widget.onScrollToSection != null) {
      widget.onScrollToSection!(section);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = Theme.of(context).colorScheme.onPrimaryContainer;
    final isSmallScreen = MediaQuery.of(context).size.width < 600;

    return SelectionArea(
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 700),
        child: Stack(
          children: [
            // Background gradient with animated pattern
            Positioned.fill(
              child: AnimatedBuilder(
                animation: _continuousController,
                builder: (context, child) {
                  return CustomPaint(
                    painter: BackgroundPatternPainter(
                      animationValue: _continuousController.value,
                      isDarkMode: isDarkMode,
                    ),
                  );
                },
              ),
            ),

            // Confetti widget for celebratory effect
            Align(
              alignment: Alignment.topCenter,
              child: ConfettiWidget(
                confettiController: _confettiController,
                blastDirectionality: BlastDirectionality.explosive,
                particleDrag: 0.05,
                emissionFrequency: 0.05,
                numberOfParticles: 100,
                gravity: 0.05,
                colors: [
                  Theme.of(context).colorScheme.primary,
                  Colors.amber,
                  Colors.blue,
                  Colors.red,
                  Colors.purple,
                  Colors.green,
                ],
                createParticlePath: (size) {
                  final path = Path();
                  path.addOval(Rect.fromCircle(
                    center: Offset.zero,
                    radius: 10.0 * math.Random().nextDouble(),
                  ));
                  return path;
                },
              ),
            ),

            // Floating decorative elements - keep these continuously animated
            ...List.generate(10, (index) {
              final random = math.Random(index);
              final size = random.nextDouble() * 100 + 50;
              final top = random.nextDouble() * 600;
              final left =
                  random.nextDouble() * MediaQuery.of(context).size.width;
              final opacity = random.nextDouble() * 0.2 + 0.05;

              return Positioned(
                top: top,
                left: left,
                child: AnimatedBuilder(
                  animation: _continuousController,
                  builder: (context, child) {
                    final animValue = math.sin(
                        (_continuousController.value * 2 * math.pi) + index);
                    return Transform.translate(
                      offset: Offset(0, animValue * 10),
                      child: Opacity(
                        opacity: opacity,
                        child: Container(
                          height: size,
                          width: size,
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.1),
                            borderRadius: BorderRadius.circular(size / 2),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            }),

            // Main content
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: isSmallScreen ? 30 : 60),

                  // Welcome message - play once
                  AnimatedBuilder(
                    animation: _welcomeAnimation,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _welcomeAnimation.value,
                        child: Transform.translate(
                          offset: Offset(0, 15 * (1 - _welcomeAnimation.value)),
                          child: WelcomeCard(
                            confettiController: _confettiController,
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(
                      height: 20), // Profile image with animation - play once
                  AnimatedBuilder(
                    animation: _profilePicAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _profilePicAnimation.value,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: isSmallScreen ? 100 : 130,
                            maxHeight: isSmallScreen ? 100 : 130,
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primary
                                      .withOpacity(0.3),
                                  blurRadius: 20,
                                  spreadRadius: 5,
                                ),
                              ],
                            ),
                            child: CircleAvatar(
                              radius: isSmallScreen ? 50 : 65,
                              backgroundImage:
                                  const AssetImage('assets/images/pfp.jpg'),
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(
                      height: 20), // Name with animated entrance - play once
                  AnimatedBuilder(
                    animation: _nameAnimation,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _nameAnimation.value,
                        child: Transform.translate(
                          offset: Offset(0, 15 * (1 - _nameAnimation.value)),
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(
                              maxWidth: 600,
                            ),
                            child: SelectableText(
                              'Ahmed Ibrahim',
                              style: TextStyle(
                                fontSize: isSmallScreen ? 30 : 40,
                                fontWeight: FontWeight.bold,
                                color: textColor,
                                letterSpacing: 1.5,
                                shadows: [
                                  Shadow(
                                    color: Colors.black.withOpacity(0.1),
                                    offset: const Offset(2, 2),
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(
                      height:
                          15), // Animated typing text - will continue because it handles its own animation
                  AnimatedBuilder(
                    animation: _roleAnimation,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _roleAnimation.value,
                        child: Transform.translate(
                          offset: Offset(0, 15 * (1 - _roleAnimation.value)),
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(
                              maxWidth: 500,
                            ),
                            child: TypingText(
                              texts: const [
                                'Flutter Developer',
                                'Mobile App Specialist',
                                'UI/UX Enthusiast',
                                'Problem Solver',
                              ],
                              style: TextStyle(
                                fontSize: isSmallScreen ? 20 : 24,
                                fontWeight: FontWeight.w500,
                                color: textColor.withOpacity(0.9),
                              ),
                              typingSpeed: const Duration(milliseconds: 70),
                              deletingSpeed: const Duration(milliseconds: 30),
                              pauseDuration: const Duration(milliseconds: 1500),
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 40),

                  // Call to action buttons - play once
                  AnimatedBuilder(
                    animation: _buttonsAnimation,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _buttonsAnimation.value,
                        child: Transform.translate(
                          offset: Offset(0, 15 * (1 - _buttonsAnimation.value)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SoundButton(
                                onPressed: () => _scrollToSection('Projects'),
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                  textStyle: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.work_outline_rounded),
                                    SizedBox(width: 8),
                                    Text('View Projects'),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 20),
                              OutlinedSoundButton(
                                onPressed: () => _scrollToSection('Contact'),
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                  textStyle: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.email_outlined),
                                    SizedBox(width: 8),
                                    Text('Contact Me'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                  SizedBox(height: isSmallScreen ? 30 : 60),

                  // Scroll indicator - keep continuously animated
                  Opacity(
                    opacity: 0.7,
                    child: GestureDetector(
                      onTap: () => _scrollToSection('About'),
                      child: AnimatedBuilder(
                        animation: _continuousController,
                        builder: (context, child) {
                          final animValue = math.sin(
                                  _continuousController.value * math.pi * 2) *
                              6;
                          return Transform.translate(
                            offset: Offset(0, animValue),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.keyboard_arrow_down,
                                  color: textColor.withOpacity(0.7),
                                  size: 28,
                                ),
                                Text(
                                  'Scroll to explore',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: textColor.withOpacity(0.7),
                                    letterSpacing: 1.2,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BackgroundPatternPainter extends CustomPainter {
  final double animationValue;
  final bool isDarkMode;

  BackgroundPatternPainter({
    required this.animationValue,
    required this.isDarkMode,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Updated colors to match our new dark theme
    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: isDarkMode
            ? [
                // Darker, more subtle gradient that matches our theme
                const Color(0xFF08091A), // Very dark blue-black
                const Color(0xFF10121F), // Our background color
                const Color(0xFF191D32), // Slightly lighter
                const Color(0xFF242942), // Card color from our theme
              ]
            : [
                const Color(0xFFE3F2FD),
                const Color(0xFFBBDEFB),
                const Color(0xFF90CAF9),
                const Color(0xFF64B5F6),
              ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);

    // Draw patterns with accent color highlights
    final patternPaint = Paint()
      ..color = isDarkMode
          ? const Color(0xFF6D5CFF)
              .withOpacity(0.05) // Very subtle primary color for lines
          : Colors.black.withOpacity(0.05)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    const patternStep = 30.0;
    final patternOffset = 20.0 * animationValue;

    // Draw horizontal lines with wave effect
    for (double y = -patternOffset; y <= size.height; y += patternStep) {
      final path = Path();
      path.moveTo(0, y);

      for (double x = 0; x <= size.width; x += 5) {
        final yOffset = math.sin((x / size.width) * 5 * math.pi +
                (animationValue * 2 * math.pi)) *
            8;
        path.lineTo(x, y + yOffset);
      }

      canvas.drawPath(path, patternPaint);
    }

    // Add subtle radial gradient overlay at the top for depth
    if (isDarkMode) {
      final radialPaint = Paint()
        ..shader = RadialGradient(
          center: const Alignment(0.0, -0.5),
          radius: 1.0,
          colors: [
            const Color(0xFF6D5CFF)
                .withOpacity(0.15), // Primary color with low opacity
            Colors.transparent,
          ],
          stops: const [0.0, 0.7],
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

      canvas.drawRect(
          Rect.fromLTWH(0, 0, size.width, size.height), radialPaint);
    }
  }

  @override
  bool shouldRepaint(BackgroundPatternPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}
