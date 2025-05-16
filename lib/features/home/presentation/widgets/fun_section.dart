import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../../shared/widgets/particle_background.dart';
import '../../../about/presentation/widgets/interactive_memory_game.dart';
import '../../../projects/presentation/widgets/code_breaker_game.dart';
import 'interactive_intro.dart';

class FunSection extends StatefulWidget {
  const FunSection({super.key});

  @override
  State<FunSection> createState() => _FunSectionState();
}

class _FunSectionState extends State<FunSection>
    with SingleTickerProviderStateMixin {
  bool _isVisible = false;
  late AnimationController _animationController;
  late Animation<double> _fadeInAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _fadeInAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Use ConstrainedBox instead of SizedBox to ensure minimum height
    // but allow expansion if needed
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minHeight: 700, // Slightly smaller minimum height
      ),
      child: VisibilityDetector(
        key: const Key('fun-section-detector'),
        onVisibilityChanged: (VisibilityInfo info) {
          if (info.visibleFraction > 0.3 && !_isVisible) {
            setState(() {
              _isVisible = true;
              _animationController.forward();
            });
          }
        },
        child: Stack(
          children: [
            // Background that doesn't depend on size
            Positioned.fill(
              child: AnimatedOpacity(
                opacity: _isVisible ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 1500),
                curve: Curves.easeOut,
                child: ParticleBackground(
                  baseColor: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            // Content in a column that can expand if needed
            Container(
              constraints: const BoxConstraints(maxWidth: 1200),
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
              child: Column(
                mainAxisSize:
                    MainAxisSize.min, // Allow column to size to content
                children: [
                  // Header content
                  AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) => Opacity(
                      opacity: _fadeInAnimation.value,
                      child: child,
                    ),
                    child: const Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(24.0),
                          child: Text(
                            'Interactive Zone',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 32.0),
                          child: InteractiveIntro(),
                        ),
                        SizedBox(height: 32),
                      ],
                    ),
                  ),

                  // Interactive elements section
                  AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) => Opacity(
                      opacity: _fadeInAnimation.value,
                      child: child,
                    ),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        if (constraints.maxWidth > 800) {
                          // Desktop layout - side by side
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Left side - Memory Match Game
                              Container(
                                width: constraints.maxWidth * 0.45,
                                constraints:
                                    const BoxConstraints(maxWidth: 450),
                                child: const InteractiveMemoryGame(),
                              ),
                              const SizedBox(width: 48),
                              // Right side - Code Breaker (scrollable internally)
                              Flexible(
                                child: Container(
                                  constraints:
                                      const BoxConstraints(maxWidth: 500),
                                  child: const CodeBreakerGame(),
                                ),
                              ),
                            ],
                          );
                        } else {
                          // Mobile layout
                          return Column(
                            mainAxisSize:
                                MainAxisSize.min, // Allow to size to content
                            children: [
                              // Interactive Tech Skills
                              const InteractiveMemoryGame(),
                              const SizedBox(
                                  height:
                                      32), // Code Breaker Game (scrollable internally)
                              Container(
                                constraints: BoxConstraints(
                                  maxWidth: 500,
                                  // Set min width to prevent excessive shrinking
                                  minWidth: constraints.maxWidth > 320
                                      ? 320
                                      : constraints.maxWidth,
                                ),
                                child: const CodeBreakerGame(),
                              ),
                            ],
                          );
                        }
                      },
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
