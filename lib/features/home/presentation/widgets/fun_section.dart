import 'package:flutter/material.dart';
import '../../../about/presentation/widgets/tech_stack_cube.dart';
import '../../../projects/presentation/widgets/code_breaker_game.dart';
import 'terminal_intro.dart';
import '../../../../shared/widgets/particle_background.dart';

class FunSection extends StatelessWidget {
  const FunSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 800, // Fixed height for the section
      child: Stack(
        fit: StackFit.expand,
        children: [
          ParticleBackground(
            baseColor: Theme.of(context).colorScheme.primary,
          ),
          SingleChildScrollView(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 1200),
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(32.0),
                    child: Text(
                      'Fun Interactive Zone',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 32.0),
                    child: TerminalIntro(),
                  ),
                  const SizedBox(height: 48),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      if (constraints.maxWidth > 800) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const TechStackCube(),
                            const SizedBox(width: 48),
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
                        return Column(
                          children: [
                            const TechStackCube(),
                            const SizedBox(height: 32),
                            Container(
                              constraints: const BoxConstraints(maxWidth: 500),
                              child: const CodeBreakerGame(),
                            ),
                          ],
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 48),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
