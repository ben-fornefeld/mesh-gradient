import 'package:flutter/material.dart';

/// Controls the animation state for an [AnimatedMeshGradient] widget.
///
/// This controller uses a [ValueNotifier] to manage the animation state, allowing
/// widgets to react to changes in animation status.
class AnimatedMeshGradientController {
  /// Creates an [AnimatedMeshGradientController].
  ///
  /// The controller exposes [isAnimating] to toggle the animation on
  /// an [AnimatedMeshGradient] widget. Call [start] and [stop] to control
  /// the animation, and [dispose] when the controller is no longer needed.
  AnimatedMeshGradientController();

  /// A [ValueNotifier] that tracks whether the animation is currently running.
  ///
  /// It notifies listeners when the animation starts or stops, enabling widgets
  /// to rebuild in response to these changes. The animation is stopped by default.
  ValueNotifier<bool> isAnimating = ValueNotifier<bool>(false);

  /// Starts the animation.
  ///
  /// Sets the value of [isAnimating] to `true`, indicating that the animation
  /// should be running. Widgets listening to this [ValueNotifier] will be
  /// rebuilt to reflect the change in state.
  void start() {
    isAnimating.value = true;
  }

  /// Stops the animation.
  ///
  /// Sets the value of [isAnimating] to `false`, indicating that the animation
  /// should no longer be running. Widgets listening to this [ValueNotifier]
  /// will be rebuilt to reflect the change in state.
  void stop() {
    isAnimating.value = false;
  }

  /// Disposes the controller and its resources.
  void dispose() {
    isAnimating.dispose();
  }
}
