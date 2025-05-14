import 'package:flutter/material.dart';

import '../services/audio_service.dart';

/// A button that plays a tap sound when clicked
class SoundButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onPressed;
  final ButtonStyle? style;
  final bool playSound;

  const SoundButton({
    super.key,
    required this.child,
    required this.onPressed,
    this.style,
    this.playSound = true,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: style,
      onPressed: () {
        if (playSound) {
          AudioService().playTapSound();
        }
        onPressed();
      },
      child: child,
    );
  }
}

/// An outlined button that plays a tap sound when clicked
class OutlinedSoundButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onPressed;
  final ButtonStyle? style;
  final bool playSound;

  const OutlinedSoundButton({
    super.key,
    required this.child,
    required this.onPressed,
    this.style,
    this.playSound = true,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: style,
      onPressed: () {
        if (playSound) {
          AudioService().playTapSound();
        }
        onPressed();
      },
      child: child,
    );
  }
}
