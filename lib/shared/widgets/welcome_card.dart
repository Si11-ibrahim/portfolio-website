import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

import '../services/audio_service.dart';

class WelcomeCard extends StatefulWidget {
  final ConfettiController confettiController;

  const WelcomeCard({
    super.key,
    required this.confettiController,
  });

  @override
  State<WelcomeCard> createState() => _WelcomeCardState();
}

class _WelcomeCardState extends State<WelcomeCard> {
  // Variables to track mouse position for 3D effect
  double _rotateX = 0;
  double _rotateY = 0;
  bool _isHovering = false;

  void _playCelebration() {
    // Force stop and restart the confetti animation for consistent behavior
    widget.confettiController.stop();
    // Add a small delay to ensure the controller is ready to start again
    Future.microtask(() {
      if (mounted) {
        widget.confettiController.play();
      }
    });

    // Play confetti sound using the central AudioService
    AudioService().playConfettiSound();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = Theme.of(context).colorScheme.onPrimaryContainer;
    final isSmallScreen = MediaQuery.of(context).size.width < 600;    return MouseRegion(
      onEnter: (_) {
        setState(() {
          _isHovering = true;
        });
        
        // Only trigger celebration if it's not web or user has already interacted
        // The audio service will handle skipping sounds if needed
        _playCelebration();
      },
      onExit: (_) {
        setState(() {
          _isHovering = false;
          _rotateX = 0;
          _rotateY = 0;
        });
      },
      onHover: (event) {
        // Get card dimensions
        final RenderBox box = context.findRenderObject() as RenderBox;
        final size = box.size;
        final offset = box.localToGlobal(Offset.zero);

        // Calculate position relative to card center
        final x = event.position.dx - offset.dx;
        final y = event.position.dy - offset.dy;

        // Convert to rotation values (-10 to 10 degrees)
        setState(() {
          _rotateY = ((x / size.width) - 0.5) * 10; // -5 to 5 degrees
          _rotateX = ((y / size.height) - 0.5) * -10; // -5 to 5 degrees
        });
      },
      child: GestureDetector(
        onTap: () {
          _playCelebration();
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOutQuad,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001) // Add perspective
            ..rotateX(_rotateX * 0.01) // Convert to radians
            ..rotateY(_rotateY * 0.01),
          decoration: BoxDecoration(
            color: isDarkMode
                ? Theme.of(context).cardColor.withOpacity(0.8)
                : Colors.white.withOpacity(0.8),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: _isHovering
                    ? Theme.of(context).colorScheme.primary.withOpacity(0.4)
                    : Colors.black.withOpacity(0.1),
                blurRadius: _isHovering ? 15 : 10,
                spreadRadius: _isHovering ? 2 : 0,
              ),
            ],
            border: Border.all(
              color: _isHovering
                  ? Theme.of(context).colorScheme.primary.withOpacity(0.5)
                  : Colors.grey.withOpacity(0.2),
              width: 1.5,
            ),
          ),
          padding: EdgeInsets.all(isSmallScreen ? 16 : 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.celebration_rounded,
                size: isSmallScreen ? 32 : 48,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 12),
              Text(
                "Welcome to My Portfolio!",
                style: TextStyle(
                  fontSize: isSmallScreen ? 18 : 24,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                "Hover or tap to celebrate!",
                style: TextStyle(
                  fontSize: isSmallScreen ? 14 : 16,
                  color: textColor.withOpacity(0.7),
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
