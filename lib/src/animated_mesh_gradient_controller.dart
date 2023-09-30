import 'package:flutter/material.dart';

class AnimatedMeshGradientController {
  /// Use [ValueListenableBuilder] to listen to changes in your widget.
  ValueNotifier isAnimating = ValueNotifier(false);

  void start() {
    isAnimating.value = true;
  }

  void stop() {
    isAnimating.value = false;
  }
}
