import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../services/audio_service.dart';

/// A widget that displays a banner informing web users about audio permissions
/// This only appears on web platforms and only until the user interacts with the page
class AudioPermissionBanner extends StatefulWidget {
  const AudioPermissionBanner({super.key});

  @override
  State<AudioPermissionBanner> createState() => _AudioPermissionBannerState();
}

class _AudioPermissionBannerState extends State<AudioPermissionBanner> {
  bool _showBanner = kIsWeb;

  @override
  Widget build(BuildContext context) {
    // Only show this on web platforms
    if (!kIsWeb || !_showBanner) {
      return const SizedBox.shrink();
    }

    return AnimatedOpacity(
      opacity: _showBanner ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 300),
      child: GestureDetector(
        onTap: () {
          // Mark that user has interacted
          AudioService().markUserInteraction();
          setState(() {
            _showBanner = false;
          });
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.volume_up,
                size: 18,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                'Tap anywhere to enable sound effects',
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(width: 12),
              IconButton(
                icon: Icon(
                  Icons.close,
                  size: 18,
                  color: Theme.of(context).colorScheme.primary,
                ),
                onPressed: () {
                  setState(() {
                    _showBanner = false;
                  });
                },
                constraints: const BoxConstraints(
                  minWidth: 30,
                  minHeight: 30,
                ),
                padding: EdgeInsets.zero,
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
