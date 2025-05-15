import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

/// Service to manage audio playback throughout the app
class AudioService {
  // Singleton pattern
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  final AudioPlayer _tapPlayer = AudioPlayer();
  final AudioPlayer _confettiPlayer = AudioPlayer();
  final AudioPlayer _hoverPlayer = AudioPlayer();
  bool _isTapSoundReady = false;
  bool _isConfettiSoundReady = false;
  bool _isHoverSoundReady = false;
  bool _hasUserInteracted = false;

  /// Initialize the audio service
  Future<void> init() async {
    try {
      // Initialize tap sound
      await _tapPlayer.setVolume(0.5);
      await _tapPlayer.setSourceAsset('audio/tap.mp3');
      _isTapSoundReady = true;
      debugPrint('Tap sound initialized successfully');

      // Initialize confetti sound
      await _confettiPlayer.setVolume(0.7);
      await _confettiPlayer.setSourceAsset('audio/confetti.mp3');
      _isConfettiSoundReady = true;
      log('Confetti sound initialized successfully');

      // Initialize hover sound
      await _hoverPlayer.setVolume(0.5);
      await _hoverPlayer.setSourceAsset('audio/hover.mp3');
      _isHoverSoundReady = true;
      log('Hover sound initialized successfully');
      
      // For web, provide extra debug logging
      if (kIsWeb) {
        log('Audio initialized for web - will require user interaction');
      }
    } catch (e) {
      log('Error initializing sounds: $e');
    }
  }

  /// Play the tap sound when a button is clicked
  void playTapSound() {
    // Only play sound if it's ready
    if (!_isTapSoundReady) return;

    try {
      log('Playing tap sound');
      // Always mark that user has interacted with the page
      _hasUserInteracted = true;
      
      // On web, we need to check if we already have permission to play audio
      if (kIsWeb) {
        _tapPlayer.play(AssetSource('audio/tap.mp3'), volume: 0.5)
          .catchError((error) {
            // Log but don't rethrow, so the app continues normally even if audio fails
            log('Web audio playback error: $error');
          });
      } else {
        // On non-web platforms, play normally
        _tapPlayer.play(AssetSource('audio/tap.mp3'), volume: 0.5);
      }
    } catch (e) {
      log('Error playing tap sound: $e');
    }
  }

  /// Play the confetti celebration sound
  void playConfettiSound() {
    // Only play sound if it's ready
    if (!_isConfettiSoundReady) return;

    try {
      log('Playing confetti sound');
      // Skip if no user interaction on web yet
      if (kIsWeb && !_hasUserInteracted) {
        return;
      }
      
      // On web, we need to handle potential errors without crashing
      if (kIsWeb) {
        _confettiPlayer.play(AssetSource('audio/confetti.mp3'), volume: 0.7)
          .catchError((error) {
            // Log but don't rethrow
            log('Web confetti sound playback error: $error');
          });
      } else {
        // On non-web platforms, play normally
        _confettiPlayer.play(AssetSource('audio/confetti.mp3'), volume: 0.7);
      }
    } catch (e) {
      log('Error playing confetti sound: $e');
    }
  }

  /// Play the hover sound
  void playHoverSound() {
    if (!_isHoverSoundReady) return;
    // Skip hover sounds on web completely unless user has already interacted
    if (kIsWeb && !_hasUserInteracted) {
      return;
    }
    
    try {
      log('Playing hover sound');
      // On web, we need to handle potential errors without crashing
      if (kIsWeb) {
        _hoverPlayer.play(AssetSource('audio/hover.mp3'), volume: 0.5)
          .catchError((error) {
            // Log but don't rethrow
            log('Web hover sound playback error: $error');
          });
      } else {
        // On non-web platforms, play normally
        _hoverPlayer.play(AssetSource('audio/hover.mp3'), volume: 0.5);
      }
    } catch (e) {
      log('Error playing hover sound: $e');
    }
  }

  /// Mark that user has interacted with the page (for web autoplay policies)
  void markUserInteraction() {
    if (!_hasUserInteracted) {
      log('User interaction detected - enabling audio');
      _hasUserInteracted = true;
      
      // On web, try to initialize audio by playing a silent sound
      if (kIsWeb) {
        // Create a short, silent sound to try to unlock the audio context
        try {
          // Play and immediately pause to unlock the audio context
          _tapPlayer.play(AssetSource('audio/tap.mp3'), volume: 0.01).then((_) {
            _tapPlayer.pause();
          }).catchError((error) {
            log('Error initializing web audio: $error');
          });
        } catch (e) {
          log('Error trying to unlock audio: $e');
        }
      }
    }
  }

  /// Clean up resources
  void dispose() {
    _tapPlayer.dispose();
    _confettiPlayer.dispose();
    _hoverPlayer.dispose();
  }
}
