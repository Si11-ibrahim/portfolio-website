import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../shared/services/audio_service.dart';
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
                    String? link;
                    String? linkLabel;
                    if (index == 0) {
                      link =
                          'https://github.com/Si11-ibrahim/Hindustan-University-Rating-App';
                      linkLabel = 'Hindustan University Rating App (GitHub)';
                    } else if (index == 2) {
                      link =
                          'https://medium.com/@ahamedibrahim0004/how-we-built-a-mobile-based-sdn-simulator-using-flutter-and-mininet-ba6994162942';
                      linkLabel =
                          'SDN Simulator Article With Source Code (Medium)';
                    }
                    return ProjectCard(
                      title: projects[index].$1,
                      description: projects[index].$2,
                      icon: projects[index].$3,
                      onTap: () {
                        AudioService().playTapSound();
                        showGeneralDialog(
                          context: context,
                          barrierDismissible: true,
                          barrierLabel: MaterialLocalizations.of(context)
                              .modalBarrierDismissLabel,
                          barrierColor: Colors.black54,
                          transitionDuration: const Duration(milliseconds: 300),
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  ProjectDetailsDialog(
                            title: projects[index].$1,
                            description: projects[index].$2,
                            icon: projects[index].$3,
                            link: link,
                            linkLabel: linkLabel,
                          ),
                          transitionBuilder:
                              (context, animation, secondaryAnimation, child) {
                            return ScaleTransition(
                              scale: CurvedAnimation(
                                  parent: animation, curve: Curves.easeOutBack),
                              child: FadeTransition(
                                opacity: animation,
                                child: child,
                              ),
                            );
                          },
                        );
                      },
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

class ProjectDetailsDialog extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final String? link;
  final String? linkLabel;

  const ProjectDetailsDialog({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    this.link,
    this.linkLabel,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        children: [
          Icon(icon, size: 28, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 12),
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'LeagueSpartan',
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            description,
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 16),
          if (link != null && linkLabel != null)
            InkWell(
              onTap: () => launchUrl(Uri.parse(link!)),
              child: Text(
                linkLabel!,
                style: const TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          else
            const Text(
              'More details coming soon...',
              style: TextStyle(
                fontStyle: FontStyle.italic,
                color: Colors.grey,
              ),
            ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    );
  }
}
