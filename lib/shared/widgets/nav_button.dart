import 'package:flutter/material.dart';

import '../services/audio_service.dart';

class NavButton extends StatefulWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isActive;

  const NavButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isActive = false,
  });

  @override
  State<NavButton> createState() => _NavButtonState();
}

class _NavButtonState extends State<NavButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: TextButton(
          onPressed: () {
            // Play tap sound when button is clicked
            AudioService().playTapSound();
            widget.onPressed();
          },
          style: TextButton.styleFrom(
            foregroundColor: widget.isActive
                ? theme.colorScheme.primary
                : theme.colorScheme.onSurface.withOpacity(_isHovered ? 1 : 0.8),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.label,
                style: TextStyle(
                  fontWeight:
                      widget.isActive ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              const SizedBox(height: 4),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: 2,
                width: widget.isActive || _isHovered ? 24 : 0,
                decoration: BoxDecoration(
                  color: widget.isActive
                      ? theme.colorScheme.primary
                      : theme.colorScheme.primary.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
