import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

class AnimatedSkillBars extends StatefulWidget {
  const AnimatedSkillBars({super.key});

  @override
  State<AnimatedSkillBars> createState() => _AnimatedSkillBarsState();
}

class _AnimatedSkillBarsState extends State<AnimatedSkillBars> {
  final Map<String, double> skills = {
    'Flutter': 0.75,
    'Dart': 0.70,
    'Python': 0.85,
    'JavaScript': 0.65,
    'Node.js': 0.55,
    'Firebase': 0.70,
    'Networking': 0.65,
    'REST APIs': 0.6,
    'UI/UX Design': 0.60,
    'Git': 0.75,
  };

  bool _isVisible = false;

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      // Using a unique key for this visibility detector
      key: const Key('skill-bars-detector'),
      // Start animation when at least 30% of the widget is visible
      onVisibilityChanged: (VisibilityInfo info) {
        if (info.visibleFraction > 0.3 && !_isVisible) {
          setState(() {
            _isVisible = true;
          });
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Technical Skills',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 20),
          ...skills.entries.map((skill) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    skill.key,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  TweenAnimationBuilder<double>(
                    duration: const Duration(milliseconds: 1500),
                    curve: Curves.easeOut,
                    tween: Tween<double>(
                      begin: 0,
                      end: _isVisible ? skill.value : 0,
                    ),
                    builder: (context, value, _) => Stack(
                      children: [
                        Container(
                          height: 20,
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        FractionallySizedBox(
                          widthFactor: value,
                          child: Container(
                            height: 20,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Theme.of(context).colorScheme.primary,
                                  Theme.of(context).colorScheme.secondary,
                                ],
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        Positioned(
                          right: 8,
                          top: 2,
                          child: Text(
                            '${(value * 100).toInt()}%',
                            style: TextStyle(
                              color: value > 0.5
                                  ? Colors.white
                                  : Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
