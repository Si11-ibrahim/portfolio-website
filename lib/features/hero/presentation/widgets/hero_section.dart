import 'dart:math' as math;

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:portfolio_website/features/home/presentation/widgets/hero_section.dart';

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
      child: SizedBox(
        height: MediaQuery.of(context).size.height - 55,
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
            // Floating decorative elements
            LayoutBuilder(
              builder: (context, constraints) {
                final screenSize = MediaQuery.of(context).size;
                return FloatingDecorativeElements(
                  animation: _continuousController,
                  isDarkMode: isDarkMode,
                  size: Size(constraints.maxWidth, screenSize.height),
                );
              },
            ),
            // Main content
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: HeroMainContent(
                welcomeAnimation: _welcomeAnimation,
                profilePicAnimation: _profilePicAnimation,
                nameAnimation: _nameAnimation,
                roleAnimation: _roleAnimation,
                buttonsAnimation: _buttonsAnimation,
                confettiController: _confettiController,
                scrollToSection: _scrollToSection,
                isSmallScreen: isSmallScreen,
                textColor: textColor,
              ),
            ),
            // Scroll indicator - keep continuously animated
            Positioned(
              bottom: isSmallScreen ? 50 : 20,
              left: 0,
              right: 0,
              child: Opacity(
                opacity: 0.7,
                child: GestureDetector(
                  onTap: () => _scrollToSection('About'),
                  child: AnimatedBuilder(
                    animation: _continuousController,
                    builder: (context, child) {
                      final animValue =
                          math.sin(_continuousController.value * math.pi * 2) *
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
            ),
          ],
        ),
      ),
    );
  }
}

// Main content column as a helper widget
class HeroMainContent extends StatelessWidget {
  final Animation<double> welcomeAnimation;
  final Animation<double> profilePicAnimation;
  final Animation<double> nameAnimation;
  final Animation<double> roleAnimation;
  final Animation<double> buttonsAnimation;
  final ConfettiController confettiController;
  final void Function(String section) scrollToSection;
  final bool isSmallScreen;
  final Color textColor;

  const HeroMainContent({
    super.key,
    required this.welcomeAnimation,
    required this.profilePicAnimation,
    required this.nameAnimation,
    required this.roleAnimation,
    required this.buttonsAnimation,
    required this.confettiController,
    required this.scrollToSection,
    required this.isSmallScreen,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(height: 30),
        // Welcome message
        AnimatedBuilder(
          animation: welcomeAnimation,
          builder: (context, child) {
            return Opacity(
              opacity: welcomeAnimation.value,
              child: Transform.translate(
                offset: Offset(0, 15 * (1 - welcomeAnimation.value)),
                child: WelcomeCard(confettiController: confettiController),
              ),
            );
          },
        ),
        const SizedBox(height: 20),
        // Profile image
        AnimatedBuilder(
          animation: profilePicAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: profilePicAnimation.value,
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
                    backgroundImage: const AssetImage('assets/images/pfp.jpg'),
                  ),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 20),
        // Name
        AnimatedBuilder(
          animation: nameAnimation,
          builder: (context, child) {
            return Opacity(
              opacity: nameAnimation.value,
              child: Transform.translate(
                offset: Offset(0, 15 * (1 - nameAnimation.value)),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: SelectableText(
                    'Ahmed Ibrahim',
                    style: TextStyle(
                      fontFamily: 'LeagueSpartan',
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
        const SizedBox(height: 15),
        // Typing text
        AnimatedBuilder(
          animation: roleAnimation,
          builder: (context, child) {
            return Opacity(
              opacity: roleAnimation.value,
              child: Transform.translate(
                offset: Offset(0, 15 * (1 - roleAnimation.value)),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 500),
                  child: TypingText(
                    texts: const [
                      'Flutter Developer',
                      'Mobile App Specialist',
                      'UI/UX Enthusiast',
                      'Problem Solver',
                    ],
                    style: TextStyle(
                      fontFamily: 'LeagueSpartan',
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
        // Call to action buttons
        AnimatedBuilder(
          animation: buttonsAnimation,
          builder: (context, child) {
            return Opacity(
              opacity: buttonsAnimation.value,
              child: Transform.translate(
                offset: Offset(0, 15 * (1 - buttonsAnimation.value)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SoundButton(
                      onPressed: () => scrollToSection('Projects'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        textStyle: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.work_outline_rounded),
                          SizedBox(width: 8),
                          Text('View Projects',
                              style: TextStyle(
                                  fontFamily: 'LeagueSpartan',
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 20),
                    OutlinedSoundButton(
                      onPressed: () => scrollToSection('Contact'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        textStyle: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.email_outlined),
                          SizedBox(width: 8),
                          Text('Contact Me',
                              style: TextStyle(
                                  fontFamily: 'LeagueSpartan',
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}

// Floating decorative elements as a separate widget
class FloatingDecorativeElements extends StatelessWidget {
  final Animation<double> animation;
  final bool isDarkMode;
  final Size size;
  const FloatingDecorativeElements({
    super.key,
    required this.animation,
    required this.isDarkMode,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size.width,
      height: size.height,
      child: Stack(
        children: List.generate(10, (index) {
          final random = math.Random(index);
          final elemSize = random.nextDouble() * 100 + 50;
          final top = random.nextDouble() * (size.height - elemSize);
          final left = random.nextDouble() * (size.width - elemSize);
          final opacity = random.nextDouble() * 0.2 + 0.05;
          return Positioned(
            top: top,
            left: left,
            child: AnimatedBuilder(
              animation: animation,
              builder: (context, child) {
                final animValue =
                    math.sin((animation.value * 2 * math.pi) + index);
                return Transform.translate(
                  offset: Offset(0, animValue * 10),
                  child: Opacity(
                    opacity: opacity,
                    child: Container(
                      height: elemSize,
                      width: elemSize,
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.1),
                        borderRadius: BorderRadius.circular(elemSize / 2),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        }),
      ),
    );
  }
}
