import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../services/audio_service.dart';

/// A widget that detects and marks user interactions to enable audio playback on web
/// 
/// This is particularly useful for web platforms where browsers require a user 
/// interaction before allowing audio to play. This widget wraps around the app
/// to ensure audio permission is properly granted.
class UserInteractionDetector extends StatelessWidget {
  final Widget child;

  const UserInteractionDetector({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    // Only add the detector on web platforms
    if (!kIsWeb) {
      return child;
    }

    return GestureDetector(
      onTap: () {
        // Mark that the user has interacted with the app
        AudioService().markUserInteraction();
      },
      behavior: HitTestBehavior.translucent,
      child: Listener(
        onPointerDown: (_) {
          // Mark that the user has interacted with the app
          AudioService().markUserInteraction();
        },
        behavior: HitTestBehavior.translucent,
        child: child,
      ),
    );
  }
}
