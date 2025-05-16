import 'package:flutter/material.dart';

import '../services/audio_service.dart';

/// A compact navigation button for small screen sizes
class CompactNavButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;
  final bool isActive;

  const CompactNavButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
    this.isActive = false,
  });

  @override
  State<CompactNavButton> createState() => _CompactNavButtonState();
}

class _CompactNavButtonState extends State<CompactNavButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = widget.isActive
        ? theme.colorScheme.primary
        : theme.colorScheme.onSurface.withOpacity(_isHovered ? 0.9 : 0.7);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2.0),
        child: Tooltip(
          message: widget.label,
          child: InkWell(
            onTap: () {
              AudioService().playTapSound();
              widget.onPressed();
            },
            borderRadius: BorderRadius.circular(4),
            child: Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 6.0, horizontal: 4.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    widget.icon,
                    size: 20,
                    color: color,
                  ),
                  const SizedBox(height: 2),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    height: 2,
                    width: widget.isActive || _isHovered ? 12 : 0,
                    decoration: BoxDecoration(
                      color: widget.isActive
                          ? theme.colorScheme.primary
                          : theme.colorScheme.primary.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(1),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
