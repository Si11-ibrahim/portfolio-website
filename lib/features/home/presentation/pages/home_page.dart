import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../../shared/widgets/drawer_list_tile.dart';
import '../../../../shared/widgets/footer.dart';
import '../../../../shared/widgets/nav_button.dart';
import '../../../about/presentation/widgets/about_section.dart';
import '../../../contact/presentation/widgets/contact_section.dart';
import '../../../projects/presentation/widgets/projects_section.dart';
import '../widgets/fun_section.dart';
import '../widgets/hero_section.dart';

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

  final Map<String, double> _sectionOffsets = {};

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
        final visibleBottom = (position.dy + sectionHeight).clamp(0.0, viewportHeight);
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
        _sectionOffsets[entry.key] = position.dy;
      }
    }
  }

  Widget _buildDrawerItem(String label, IconData icon) {
    return DrawerListTile(
      label: label,
      icon: icon,
      onTap: () {
        Navigator.pop(context);
        _scrollToSection(label);
      },
      isSelected: _activeSection == label,
    );
  }

  @override
  void dispose() {
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 800;
    
    return Scaffold(
      drawer: isSmallScreen ? Drawer(
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
          ),
          child: Column(
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Theme.of(context).colorScheme.primaryContainer,
                      Theme.of(context).colorScheme.primary.withOpacity(0.7),
                    ],
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircleAvatar(
                        radius: 36,
                        backgroundImage: AssetImage('assets/images/pfp.jpg'),
                      ),
                        const SizedBox(height: 12),
                    Text(
                        'Ahmed Ibrahim',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              _buildDrawerItem('Home', Icons.home),
_buildDrawerItem('About', Icons.person),
_buildDrawerItem('Projects', Icons.work),
_buildDrawerItem('Fun', Icons.games),
_buildDrawerItem('Contact', Icons.email),

// --- NEW: Divider & Tagline ---
const Padding(
  padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
  child: Divider(),
),
const Padding(
  padding: EdgeInsets.symmetric(horizontal: 16.0),
  child: Text(
    'Turning ideas into products.',
    style: TextStyle(
      fontSize: 13,
      fontStyle: FontStyle.italic,
      color: Colors.grey,
      letterSpacing: 0.2,
    ),
    textAlign: TextAlign.center,
  ),
),
const SizedBox(height: 10),

// --- NEW: Social icons, row centered ---
Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    IconButton(
      icon: const Icon(Icons.linked_camera, size: 20, color: Colors.blueGrey),
      tooltip: 'Instagram',
      onPressed: () {
        // TODO: launch instagram/profile url
      },
    ),
    IconButton(
      icon: const Icon(Icons.web, size: 20, color: Colors.blueAccent),
      tooltip: 'Website',
      onPressed: () {
        // TODO: launch website
      },
    ),
    IconButton(
      icon: const Icon(Icons.email, size: 20, color: Colors.deepOrangeAccent),
      tooltip: 'Email',
      onPressed: () {
        // TODO: launch mailto/email
      },
    ),
  ],
),

const Spacer(),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  '© ${DateTime.now().year} Ahmed Ibrahim',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
        ),
      ) : null,
      body: CustomScrollView(
        controller: scrollController,
        slivers: [
          SliverAppBar(
            floating: true,
            pinned: true,
            elevation: 0,
            backgroundColor: Theme.of(context).colorScheme.surface.withOpacity(0.7),
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
                        color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            leading: isSmallScreen ? Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              ),
            ) : null,
            title: Text(
              'Portfolio',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: isSmallScreen ? null : [
              NavButton(
                label: 'Home',
                onPressed: () => _scrollToSection('Home'),
                isActive: _activeSection == 'Home',
              ),
              NavButton(
                label: 'About',
                onPressed: () => _scrollToSection('About'),
                isActive: _activeSection == 'About',
              ),
              NavButton(
                label: 'Projects',
                onPressed: () => _scrollToSection('Projects'),
                isActive: _activeSection == 'Projects',
              ),
              NavButton(
                label: 'Fun',
                onPressed: () => _scrollToSection('Fun'),
                isActive: _activeSection == 'Fun',
              ),
              NavButton(
                label: 'Contact',
                onPressed: () => _scrollToSection('Contact'),
                isActive: _activeSection == 'Contact',
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                HeroSection(key: _sectionKeys['Home']),
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
