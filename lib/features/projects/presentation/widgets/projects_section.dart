import 'package:flutter/material.dart';

import '../../../../shared/widgets/project_card.dart';

class ProjectsSection extends StatelessWidget {
  const ProjectsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SelectionArea(
      child: Container(
        padding: const EdgeInsets.all(32.0),
        color: theme.colorScheme.secondaryContainer,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SelectableText(
              'My Projects',
              style: theme.textTheme.headlineLarge?.copyWith(
                color: theme.colorScheme.onSecondaryContainer,
              ),
            ),
            const SizedBox(height: 30),
            LayoutBuilder(
              builder: (context, constraints) {
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 3,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: constraints.maxWidth > 1200
                        ? 3
                        : constraints.maxWidth > 800
                            ? 2
                            : 1,
                    childAspectRatio: 1.2,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                  ),
                  itemBuilder: (context, index) {
                    final projects = [
                      (
                        'Mobile App',
                        'A cross-platform mobile application built with Flutter',
                        Icons.mobile_friendly
                      ),
                      (
                        'Web Dashboard',
                        'A responsive admin dashboard with real-time data',
                        Icons.web
                      ),
                      (
                        'Desktop App',
                        'A powerful desktop application with native performance',
                        Icons.desktop_windows_outlined
                      ),
                    ];
                    return ProjectCard(
                      title: projects[index].$1,
                      description: projects[index].$2,
                      icon: projects[index].$3,
                      onTap: () {},
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
