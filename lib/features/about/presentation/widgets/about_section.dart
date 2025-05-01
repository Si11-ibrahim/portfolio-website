import 'package:flutter/material.dart';
import 'package:portfolio_website/shared/widgets/skill_chip.dart';

import 'animated_skill_bars.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SelectionArea(
      child: Container(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: [
            const SelectableText(
              'About Me',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            SelectableText(
              'I am a passionate full-stack developer with extensive expertise in Flutter, Python, JavaScript, and Node.js. '
              'My technical prowess extends across mobile development, REST APIs, and state management, allowing me to create robust cross-platform applications. '
              'I excel in problem-solving and consistently deliver innovative solutions to complex technical challenges. '
              'With strong team collaboration skills and proven experience in project management, I effectively handle multiple projects while maintaining strict deadlines. '
              'My methodical approach to time management and attention to detail ensures high-quality deliverables that exceed expectations.',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[700],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48),
            const AnimatedSkillBars(),
            const SizedBox(height: 30),
            const Wrap(
              spacing: 16,
              runSpacing: 16,
              alignment: WrapAlignment.center,
              children: [
                SkillChip(
                  label: 'Flutter',
                  url: 'https://flutter.dev',
                ),
                SkillChip(
                  label: 'Python',
                  url: 'https://python.org',
                ),
                SkillChip(
                  label: 'JavaScript',
                  url: 'https://developer.mozilla.org/en-US/docs/Web/JavaScript',
                ),
                SkillChip(
                  label: 'Node.js',
                  url: 'https://nodejs.org',
                ),
                SkillChip(
                  label: 'Networking',
                  url: 'https://en.wikipedia.org/wiki/Computer_network',
                ),
                SkillChip(
                  label: 'Mobile Development',
                  url: 'https://developer.android.com',
                ),
                SkillChip(
                  label: 'UI/UX Design',
                  url: 'https://material.io/design',
                ),
                SkillChip(
                  label: 'REST APIs',
                  url: 'https://restfulapi.net',
                ),
                SkillChip(
                  label: 'State Management',
                  url: 'https://flutter.dev/docs/development/data-and-backend/state-mgmt/intro',
                ),
                SkillChip(
                  label: 'Full Stack Development',
                  url: 'https://www.w3schools.com/whatis/whatis_fullstack.asp',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
