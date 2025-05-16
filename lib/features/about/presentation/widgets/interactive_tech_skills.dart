import 'package:flutter/material.dart';

class InteractiveTechSkills extends StatefulWidget {
  const InteractiveTechSkills({super.key});

  @override
  State<InteractiveTechSkills> createState() => _InteractiveTechSkillsState();
}

class _InteractiveTechSkillsState extends State<InteractiveTechSkills> {
  int _selectedCategoryIndex = 0;
  int? _expandedSkillIndex;

  // Define categories of skills
  final List<SkillCategory> _categories = [
    SkillCategory(
      name: 'Frontend',
      icon: Icons.devices,
      skills: [
        Skill(
          name: 'Flutter',
          proficiency: 0.9,
          description:
              'Cross-platform UI toolkit for building beautiful, natively compiled applications.',
          color: Colors.blue,
          icon: Icons.flutter_dash,
        ),
        Skill(
          name: 'React',
          proficiency: 0.8,
          description:
              'JavaScript library for building user interfaces, particularly single-page applications.',
          color: Colors.blue.shade300,
          icon: Icons.code,
        ),
        Skill(
          name: 'HTML/CSS',
          proficiency: 0.85,
          description:
              'Core technologies for building web pages and web applications.',
          color: Colors.orange,
          icon: Icons.html,
        ),
      ],
    ),
    SkillCategory(
      name: 'Backend',
      icon: Icons.storage,
      skills: [
        Skill(
          name: 'Node.js',
          proficiency: 0.75,
          description:
              'JavaScript runtime built on Chrome\'s V8 JS engine for server-side programming.',
          color: Colors.green,
          icon: Icons.code,
        ),
        Skill(
          name: 'Python',
          proficiency: 0.85,
          description:
              'General-purpose language used for web development, data science, AI, and more.',
          color: Colors.blue.shade900,
          icon: Icons.code,
        ),
        Skill(
          name: 'REST APIs',
          proficiency: 0.8,
          description: 'Design and implement RESTful web services and APIs.',
          color: Colors.purple,
          icon: Icons.api,
        ),
      ],
    ),
    SkillCategory(
      name: 'DevOps',
      icon: Icons.build,
      skills: [
        Skill(
          name: 'Git',
          proficiency: 0.8,
          description:
              'Distributed version control system for tracking changes in source code.',
          color: Colors.orange,
          icon: Icons.commit,
        ),
        Skill(
          name: 'CI/CD',
          proficiency: 0.7,
          description:
              'Continuous integration and continuous delivery pipelines.',
          color: Colors.teal,
          icon: Icons.loop,
        ),
        Skill(
          name: 'Docker',
          proficiency: 0.65,
          description:
              'Platform for developing, shipping, and running applications in containers.',
          color: Colors.blue.shade700,
          icon: Icons.sailing,
        ),
      ],
    ),
  ];
  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 600;

    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min, // Use minimum size
        children: [
          // Category selector
          _buildCategorySelector(isSmallScreen),
          const SizedBox(height: 24),
          // Skills for selected category
          _buildSkillsList(isSmallScreen),
        ],
      ),
    );
  }

  Widget _buildCategorySelector(bool isSmallScreen) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: _categories.asMap().entries.map((entry) {
          final index = entry.key;
          final category = entry.value;
          final isSelected = index == _selectedCategoryIndex;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  setState(() {
                    _selectedCategoryIndex = index;
                    _expandedSkillIndex =
                        null; // Reset expanded card when changing category
                  });
                },
                borderRadius: BorderRadius.circular(16),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: EdgeInsets.symmetric(
                    horizontal: isSmallScreen ? 12.0 : 16.0,
                    vertical: isSmallScreen ? 8.0 : 12.0,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            )
                          ]
                        : null,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        category.icon,
                        size: isSmallScreen ? 16 : 20,
                        color: isSelected
                            ? Theme.of(context).colorScheme.onPrimary
                            : Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      SizedBox(width: isSmallScreen ? 6 : 8),
                      Text(
                        category.name,
                        style: TextStyle(
                          fontSize: isSmallScreen ? 14 : 16,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected
                              ? Theme.of(context).colorScheme.onPrimary
                              : Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSkillsList(bool isSmallScreen) {
    final selectedCategory = _categories[_selectedCategoryIndex];
    final skills = selectedCategory.skills;

    // Wrap in a SizedBox with a fixed height for consistency
    return SizedBox(
        height: 300, // Fixed height for scrollable area
        child: SingleChildScrollView(
            child: Column(
          mainAxisSize: MainAxisSize.min,
          children: skills.asMap().entries.map((entry) {
            final index = entry.key;
            final skill = entry.value;
            final isExpanded = _expandedSkillIndex == index;

            return Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _expandedSkillIndex = isExpanded ? null : index;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOutQuad,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(isSmallScreen ? 12.0 : 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            // Skill icon with colored background
                            Container(
                              width: isSmallScreen ? 36 : 40,
                              height: isSmallScreen ? 36 : 40,
                              decoration: BoxDecoration(
                                color: skill.color.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                skill.icon,
                                color: skill.color,
                                size: isSmallScreen ? 20 : 24,
                              ),
                            ),
                            SizedBox(width: isSmallScreen ? 10 : 12),
                            // Skill name and proficiency bar
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    skill.name,
                                    style: TextStyle(
                                      fontSize: isSmallScreen ? 16 : 18,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      // Animated proficiency bar
                                      Expanded(
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          child: TweenAnimationBuilder<double>(
                                            duration: const Duration(
                                                milliseconds: 1000),
                                            curve: Curves.easeOutQuart,
                                            tween: Tween<double>(
                                              begin: 0.0,
                                              end: skill.proficiency,
                                            ),
                                            builder: (context, value, _) =>
                                                Stack(
                                              children: [
                                                // Background bar
                                                Container(
                                                  height: 8,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .surfaceContainerHighest,
                                                ),
                                                // Filled portion
                                                FractionallySizedBox(
                                                  widthFactor: value,
                                                  child: Container(
                                                    height: 8,
                                                    decoration: BoxDecoration(
                                                      color: skill.color,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              4),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: isSmallScreen ? 8 : 10),
                                      // Proficiency percentage
                                      TweenAnimationBuilder<double>(
                                        duration:
                                            const Duration(milliseconds: 1000),
                                        curve: Curves.easeOutQuart,
                                        tween: Tween<double>(
                                          begin: 0.0,
                                          end: skill.proficiency,
                                        ),
                                        builder: (context, value, _) => Text(
                                          '${(value * 100).toInt()}%',
                                          style: TextStyle(
                                            fontSize: isSmallScreen ? 12 : 14,
                                            fontWeight: FontWeight.bold,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurfaceVariant,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            // Expand/collapse icon
                            Icon(
                              isExpanded
                                  ? Icons.keyboard_arrow_up
                                  : Icons.keyboard_arrow_down,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                          ],
                        ),
                        // Expanded details section
                        if (isExpanded) ...[
                          const SizedBox(height: 16),
                          Padding(
                            padding: const EdgeInsets.only(left: 4.0),
                            child: Text(
                              skill.description,
                              style: TextStyle(
                                fontSize: isSmallScreen ? 14 : 16,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurface
                                    .withOpacity(0.8),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        )));
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class SkillCategory {
  final String name;
  final IconData icon;
  final List<Skill> skills;

  SkillCategory({
    required this.name,
    required this.icon,
    required this.skills,
  });
}

class Skill {
  final String name;
  final double proficiency; // 0.0 to 1.0
  final String description;
  final Color color;
  final IconData icon;

  Skill({
    required this.name,
    required this.proficiency,
    required this.description,
    required this.color,
    required this.icon,
  });
}
