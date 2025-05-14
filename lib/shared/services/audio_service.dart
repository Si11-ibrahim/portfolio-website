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
  bool _isTapSoundReady = false;
  bool _isConfettiSoundReady = false;
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
      debugPrint('Confetti sound initialized successfully');
    } catch (e) {
      debugPrint('Error initializing sounds: $e');
    }
  }

  /// Play the tap sound when a button is clicked
  void playTapSound() {
    // Only play sound if it's ready
    if (!_isTapSoundReady) return;

    try {
      log('Playing tap sound');
      if (kIsWeb && !_hasUserInteracted) {
        // For web, mark that user has interacted
        _hasUserInteracted = true;
        return; // Skip first play on web to avoid autoplay issues
      }

      _tapPlayer.play(AssetSource('audio/tap.mp3'), volume: 0.5);
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
      if (kIsWeb && !_hasUserInteracted) {
        // For web, mark that user has interacted
        _hasUserInteracted = true;
        return; // Skip first play on web to avoid autoplay issues
      }

      _confettiPlayer.play(AssetSource('audio/confetti.mp3'), volume: 0.7);
    } catch (e) {
      log('Error playing confetti sound: $e');
    }
  }

  /// Mark that user has interacted with the page (for web autoplay policies)
  void markUserInteraction() {
    _hasUserInteracted = true;
  }

  /// Clean up resources
  void dispose() {
    _tapPlayer.dispose();
    _confettiPlayer.dispose();
  }
}
