import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../../shared/services/audio_service.dart';
import '../../../../shared/widgets/footer.dart';
import '../../../../shared/widgets/nav_button.dart';
import '../../../about/presentation/widgets/about_section.dart';
import '../../../contact/presentation/widgets/contact_section.dart';
import '../../../hero/presentation/widgets/index.dart';
import '../../../projects/presentation/widgets/projects_section.dart';
import '../widgets/fun_section.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final scrollController = ScrollController();
  String _activeSection = 'Home';

  final Map<String, GlobalKey> _sectionKeys = {
    'Home': GlobalKey(),
    'About': GlobalKey(),
    'Projects': GlobalKey(),
    'Fun': GlobalKey(),
    'Contact': GlobalKey(),
  };

  // Stores the Y offset of each section
  final Map<String, double> _sectionOffsets = {};

  // Section data with icons for navigation - using this approach makes it easy to add new sections
  final List<(String, IconData)> _sections = [
    ('Home', Icons.home_outlined),
    ('About', Icons.person_outline),
    ('Projects', Icons.work_outline),
    ('Fun', Icons.emoji_emotions_outlined),
    ('Contact', Icons.email_outlined),
  ];

  @override
  void initState() {
    super.initState();
    scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateSectionOffsets();
    });
  }

  void _onScroll() {
    if (!mounted) return;
    _updateActiveSection();
  }

  void _updateActiveSection() {
    if (!mounted) return;
    final viewportHeight = MediaQuery.of(context).size.height;
    final scrollPosition = scrollController.offset;
    final maxScroll = scrollController.position.maxScrollExtent;

    // Special case for bottom of page (Contact section)
    if (maxScroll - scrollPosition <= viewportHeight / 2) {
      if (_activeSection != 'Contact') {
        setState(() {
          _activeSection = 'Contact';
        });
      }
      return;
    }

    // Get all visible sections and their positions
    final visibleSections = _sectionKeys.entries.where((entry) {
      final context = entry.value.currentContext;
      if (context == null) return false;
      final box = context.findRenderObject() as RenderBox;
      final position = box.localToGlobal(Offset.zero);
      final sectionHeight = box.size.height;

      // Consider a section visible if it takes up a significant portion of the viewport
      final visibleThreshold = viewportHeight * 0.3;
      return position.dy <= visibleThreshold &&
          position.dy + sectionHeight >= -visibleThreshold;
    }).toList();

    if (visibleSections.isNotEmpty) {
      // Find the section that is most prominently displayed
      var maxVisibility = 0.0;
      String newSection = _activeSection;

      for (final entry in visibleSections) {
        final context = entry.value.currentContext!;
        final box = context.findRenderObject() as RenderBox;
        final position = box.localToGlobal(Offset.zero);
        final sectionHeight = box.size.height;

        // Calculate how much of the section is visible in the viewport
        final visibleTop = position.dy.clamp(0.0, viewportHeight);
        final visibleBottom =
            (position.dy + sectionHeight).clamp(0.0, viewportHeight);
        final visibleHeight = visibleBottom - visibleTop;

        if (visibleHeight > maxVisibility) {
          maxVisibility = visibleHeight;
          newSection = entry.key;
        }
      }

      if (newSection != _activeSection) {
        setState(() {
          _activeSection = newSection;
        });
      }
    }
  }

  void _scrollToSection(String section) {
    if (!mounted) return;
    final key = _sectionKeys[section];
    if (key?.currentContext != null) {
      Scrollable.ensureVisible(
        key!.currentContext!,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        alignment: 0.0, // Align to top of viewport
      ).then((_) {
        // Force update the active section after scrolling
        Future.delayed(const Duration(milliseconds: 100), () {
          _updateActiveSection();
        });
      });
    }
  }

  void _updateSectionOffsets() {
    for (var entry in _sectionKeys.entries) {
      final context = entry.value.currentContext;
      if (context != null) {
        final RenderBox box = context.findRenderObject() as RenderBox;
        final position = box.localToGlobal(Offset.zero);
        // Using a Map to store the Y offset of each section
        _sectionOffsets[entry.key] = position.dy;
      }
    }
  }

  @override
  void dispose() {
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    super.dispose();
  }

  // Build the appropriate navigation based on screen size
  Widget _buildNavigation(bool isVerySmallScreen, bool isSmallScreen) {
    // For very small screens (e.g., narrow mobile), show a dropdown menu
    if (isVerySmallScreen) {
      return PopupMenuButton<String>(
        icon: Icon(
          Icons.menu,
          color: Theme.of(context).colorScheme.onSurface,
        ),
        onSelected: (value) {
          AudioService().playTapSound();
          _scrollToSection(value);
        },
        itemBuilder: (context) => _sections
            .map((section) => PopupMenuItem<String>(
                  value: section.$1,
                  child: Row(
                    children: [
                      Icon(
                        section.$2,
                        size: 18,
                        color: _activeSection == section.$1
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.onSurface,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        section.$1,
                        style: TextStyle(
                          fontWeight: _activeSection == section.$1
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ))
            .toList(),
      );
    }

    // For small screens (e.g., larger mobile), show icon buttons
    if (isSmallScreen) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: _sections
            .map((section) => IconButton(
                  icon: Icon(
                    section.$2,
                    color: _activeSection == section.$1
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.onSurface,
                  ),
                  tooltip: section.$1,
                  onPressed: () {
                    AudioService().playTapSound();
                    _scrollToSection(section.$1);
                  },
                  visualDensity: VisualDensity.compact,
                  constraints: const BoxConstraints(
                    minWidth: 40,
                    maxWidth: 40,
                  ),
                ))
            .toList(),
      );
    }

    // For larger screens, show full text buttons
    return Row(
      children: _sections
          .map((section) => NavButton(
                label: section.$1,
                onPressed: () => _scrollToSection(section.$1),
                isActive: _activeSection == section.$1,
              ))
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Define screen size breakpoints
    final screenWidth = MediaQuery.of(context).size.width;
    final isVerySmallScreen = screenWidth < 400;
    final isSmallScreen = screenWidth < 600;

    return Scaffold(
      body: CustomScrollView(
        controller: scrollController,
        slivers: [
          SliverAppBar(
            floating: true,
            pinned: true,
            elevation: 0,
            backgroundColor:
                Theme.of(context).colorScheme.surface.withOpacity(0.7),
            flexibleSpace: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Theme.of(context).colorScheme.surface.withOpacity(0.6),
                        Theme.of(context).colorScheme.surface.withOpacity(0.3),
                      ],
                    ),
                    border: Border(
                      bottom: BorderSide(
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            title: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                'Portfolio',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                  fontSize: isSmallScreen ? 18 : 24,
                ),
              ),
            ),
            actions: [
              // Build responsive navigation based on screen size
              _buildNavigation(isVerySmallScreen, isSmallScreen),
              // Add some spacing on the right
              const SizedBox(width: 8),
            ],
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                HeroSection(
                  key: _sectionKeys['Home'],
                  onScrollToSection: _scrollToSection,
                ),
                Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1200),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        children: [
                          AboutSection(key: _sectionKeys['About']),
                          ProjectsSection(key: _sectionKeys['Projects']),
                          FunSection(key: _sectionKeys['Fun']),
                          ContactSection(key: _sectionKeys['Contact']),
                        ],
                      ),
                    ),
                  ),
                ),
                const Footer(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
