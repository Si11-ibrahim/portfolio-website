import 'package:flutter/material.dart';

import '../../../../shared/widgets/typing_text.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SelectionArea(
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 500),
        child: Container(
          width: double.infinity,
          color: Theme.of(context).colorScheme.primaryContainer,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              SelectableText(
                'Ahmed Ibrahim',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              TypingText(
                texts: [
                  'Flutter Developer',
                  'Mobile App Specialist',
                  'UI/UX Enthusiast',
                  'Problem Solver',
                ],
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
