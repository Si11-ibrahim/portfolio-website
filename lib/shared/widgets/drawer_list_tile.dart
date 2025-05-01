import 'package:flutter/material.dart';

class DrawerListTile extends StatefulWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool isSelected;

  const DrawerListTile({
    super.key,
    required this.label,
    required this.icon,
    required this.onTap,
    this.isSelected = false,
  });

  @override
  State<DrawerListTile> createState() => _DrawerListTileState();
}

class _DrawerListTileState extends State<DrawerListTile>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.03,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return MouseRegion(
      onEnter: (_) {
        setState(() => _isHovered = true);
        _controller.forward();
      },
      onExit: (_) {
        setState(() => _isHovered = false);
        _controller.reverse();
      },
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          // Much tighter vertical/horizontal space:
          margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: widget.isSelected
                ? theme.colorScheme.primaryContainer.withOpacity(0.85)
                : _isHovered
                    ? theme.colorScheme.surfaceContainerHighest.withOpacity(0.25)
                    : Colors.transparent,
          ),
          child: ListTile(
            leading: Icon(
              widget.icon,
              // Smaller icon
              size: 18,
              color: widget.isSelected
                  ? theme.colorScheme.primary
                  : _isHovered
                      ? theme.colorScheme.primary.withOpacity(0.7)
                      : theme.colorScheme.onSurfaceVariant,
            ),
            title: Text(
              widget.label,
              style: TextStyle(
                fontSize: 13,  // Smaller font
                color: widget.isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurface,
                fontWeight: widget.isSelected ? FontWeight.w600 : FontWeight.normal,
                letterSpacing: 0.2,
              ),
            ),
            visualDensity: const VisualDensity(horizontal: -3, vertical: -3),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
            minLeadingWidth: 0,
            minVerticalPadding: 0,
            dense: true,
            onTap: widget.onTap,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            // Reduce height
            horizontalTitleGap: 6,
          ),
        ),
      ),
    );
  }
}
