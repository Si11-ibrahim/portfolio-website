import 'package:flutter/material.dart';

import 'core/app.dart';
import 'shared/services/audio_service.dart';

void main() {
  // Initialize audio service
  AudioService().init();

  runApp(const PortfolioApp());
}
