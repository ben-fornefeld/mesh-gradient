import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mesh_gradient/mesh_gradient.dart';

/// Controls the animation of mesh gradient points.
///
/// This controller is responsible for managing the animation of points within a mesh gradient.
/// It provides methods to animate individual points or a sequence of points with custom
/// durations, curves, and other animation parameters. It also supports repeating animations
/// and stopping all ongoing animations.
class MeshGradientController {
  /// A [ValueNotifier] that notifies listeners of changes to the mesh gradient points.
  late ValueNotifier<List<MeshGradientPoint>> points;

  /// A [ValueNotifier] that indicates whether the mesh gradient is currently being animated.
  final ValueNotifier<bool> isAnimating = ValueNotifier(false);

  /// The [TickerProvider] for the animation controller.
  final TickerProvider vsync;

  /// A list to keep track of all active animation controllers.
  final List<AnimationController> _activeAnimationControllers = [];

  /// Tracks whether this controller has been disposed.
  bool _isDisposed = false;

  /// Constructs a [MeshGradientController].
  ///
  /// Requires a list of [MeshGradientPoint]s to initialize the points and a [TickerProvider]
  /// to handle animations.
  MeshGradientController({
    required List<MeshGradientPoint> points,
    required this.vsync,
  }) : points = ValueNotifier(points);

  /// Disposes the controller and its resources.
  ///
  /// This method stops all ongoing animations and disposes of all resources
  /// used by the controller.
  void dispose() {
    if (_isDisposed) return;

    stopAllAnimations();
    points.dispose();
    isAnimating.dispose();
    _isDisposed = true;
  }

  /// Checks if the controller is disposed.
  ///
  /// Returns true if the controller has been disposed, false otherwise.
  bool isDisposed() {
    return _isDisposed;
  }

  /// Stops all ongoing animations.
  ///
  /// This method stops and disposes of all active animation controllers,
  /// effectively halting all ongoing animations.
  void stopAllAnimations() {
    for (var controller in _activeAnimationControllers) {
      controller.stop();
      controller.dispose();
    }
    _activeAnimationControllers.clear();
    isAnimating.value = false;
  }

  /// Animates a single point to a new state.
  ///
  /// The [pointIndex] specifies the index of the point to animate, and [newPoint] specifies
  /// the target state of the point. Optional parameters [curve] and [duration] can be provided
  /// to customize the animation.
  Future<void> animatePoint(
    int pointIndex,
    MeshGradientPoint newPoint, {
    Curve curve = Curves.ease,
    Duration duration = const Duration(milliseconds: 300),
  }) async {
    if (_isDisposed) {
      throw StateError('Cannot animate point on a disposed controller');
    }

    try {
      final completer = Completer();

      final List<MeshGradientPoint> currentPoints = points.value;

      if (pointIndex < 0 || pointIndex >= currentPoints.length) {
        throw ArgumentError('Index out of bounds');
      }

      final MeshGradientPoint startPoint = currentPoints[pointIndex];
      final Tween<Offset> positionTween = Tween(
        begin: startPoint.position,
        end: newPoint.position,
      );

      final ColorTween colorTween = ColorTween(
        begin: startPoint.color,
        end: newPoint.color,
      );

      isAnimating.value = true;

      AnimationController animationController = AnimationController(
        duration: duration,
        vsync: vsync,
      );

      _activeAnimationControllers.add(animationController);

      void listener() {
        final Offset animatedPosition = positionTween.evaluate(
          CurvedAnimation(parent: animationController, curve: curve),
        );
        final Color? animatedColor = colorTween.evaluate(
          CurvedAnimation(parent: animationController, curve: curve),
        );

        MeshGradientPoint animatedPoint = MeshGradientPoint(
          position: animatedPosition,
          color: animatedColor ?? Colors.transparent,
        );

        List<MeshGradientPoint> updatedPoints = List.from(currentPoints);
        updatedPoints[pointIndex] = animatedPoint;

        points.value = updatedPoints;
      }

      animationController.addListener(listener);

      animationController.forward();

      animationController.addStatusListener((status) {
        if (status == AnimationStatus.completed ||
            status == AnimationStatus.dismissed) {
          animationController.removeListener(listener);
          animationController.dispose();
          _activeAnimationControllers.remove(animationController);
          completer.complete();
        }
      });

      await completer.future;
    } catch (e) {
      rethrow;
    } finally {
      isAnimating.value = _activeAnimationControllers.isNotEmpty;
    }
  }

  /// Animates a sequence of points with specified durations and curves.
  ///
  /// The method takes a [duration] for the entire sequence and a list of [sequences]
  /// specifying the animation details for each point in the sequence.
  /// [repeatCount] specifies the number of times to repeat the entire sequence. If set to 0, it repeats indefinitely.
  /// [pauseBetweenRepeats] is an optional pause duration between repeats.
  Future<void> animateSequence({
    required Duration duration,
    required List<AnimationSequence> sequences,
    int repeatCount = 1,
    Duration pauseBetweenRepeats = Duration.zero,
  }) async {
    if (_isDisposed) {
      throw StateError('Cannot animate sequence on a disposed controller');
    }

    Future<void> singleSequenceAnimation() async {
      try {
        final completer = Completer();

        AnimationController animationController = AnimationController(
          duration: duration,
          vsync: vsync,
        );

        _activeAnimationControllers.add(animationController);

        isAnimating.value = true;

        final indexSet = <int>{};
        for (var sequence in sequences) {
          if (!indexSet.add(sequence.pointIndex)) {
            throw ArgumentError(
                'Duplicate sequence index detected: ${sequence.pointIndex}. Each sequence must have a unique point index.');
          }
          final int pointIndex = sequence.pointIndex;
          final MeshGradientPoint newPoint = sequence.newPoint;

          if (pointIndex < 0 || pointIndex >= points.value.length) {
            throw ArgumentError('Index out of bounds');
          }

          final MeshGradientPoint startPoint = points.value[pointIndex];
          final Tween<Offset> positionTween = Tween(
            begin: startPoint.position,
            end: newPoint.position,
          );

          final ColorTween colorTween = ColorTween(
            begin: startPoint.color,
            end: newPoint.color,
          );

          final Animation<double> sequenceAnimation = CurvedAnimation(
            parent: animationController,
            curve: sequence.interval,
          );

          void sequenceListener() {
            final Offset animatedPosition =
                positionTween.evaluate(sequenceAnimation);
            final Color? animatedColor = colorTween.evaluate(sequenceAnimation);
            MeshGradientPoint animatedPoint = MeshGradientPoint(
              position: animatedPosition,
              color: animatedColor ?? Colors.transparent,
            );

            List<MeshGradientPoint> updatedPoints = List.from(points.value);
            updatedPoints[pointIndex] = animatedPoint;

            points.value = updatedPoints;
          }

          sequenceAnimation.addListener(sequenceListener);

          void sequenceStatusListener(AnimationStatus status) {
            if (status == AnimationStatus.completed ||
                status == AnimationStatus.dismissed) {
              sequenceAnimation.removeListener(sequenceListener);
              sequenceAnimation.removeStatusListener(sequenceStatusListener);
            }
          }

          sequenceAnimation.addStatusListener(sequenceStatusListener);
        }

        animationController.forward();

        void animationStatusListener(AnimationStatus status) {
          if (status == AnimationStatus.completed ||
              status == AnimationStatus.dismissed) {
            animationController.removeStatusListener(animationStatusListener);
            animationController.dispose();
            _activeAnimationControllers.remove(animationController);
            completer.complete();
          }
        }

        animationController.addStatusListener(animationStatusListener);

        await completer.future;
      } catch (e) {
        rethrow;
      } finally {
        isAnimating.value = _activeAnimationControllers.isNotEmpty;
      }
    }

    await repeatAnimation(
      animation: singleSequenceAnimation,
      repeatCount: repeatCount,
      pauseBetweenRepeats: pauseBetweenRepeats,
    );
  }

  /// Repeats an animation for a specified number of times or indefinitely.
  ///
  /// [animation] is a function that performs the animation.
  /// [repeatCount] specifies the number of times to repeat the animation. If set to 0, it repeats indefinitely.
  /// [pauseBetweenRepeats] is an optional pause duration between repeats.
  Future<void> repeatAnimation({
    required Future<void> Function() animation,
    int repeatCount = 0,
    Duration pauseBetweenRepeats = Duration.zero,
  }) async {
    int currentRepeat = 0;

    while (repeatCount == 0 || currentRepeat < repeatCount) {
      await animation();

      if (pauseBetweenRepeats > Duration.zero) {
        await Future.delayed(pauseBetweenRepeats);
      }

      if (repeatCount > 0) {
        currentRepeat++;
      }
    }
  }

  /// Repeats a single point animation.
  ///
  /// This method animates a single point repeatedly using the specified parameters.
  /// It uses [repeatAnimation] internally to handle the repetition logic.
  Future<void> repeatPointAnimation(
    int pointIndex,
    MeshGradientPoint newPoint, {
    Curve curve = Curves.ease,
    Duration duration = const Duration(milliseconds: 300),
    int repeatCount = 0,
    Duration pauseBetweenRepeats = Duration.zero,
  }) async {
    await repeatAnimation(
      animation: () =>
          animatePoint(pointIndex, newPoint, curve: curve, duration: duration),
      repeatCount: repeatCount,
      pauseBetweenRepeats: pauseBetweenRepeats,
    );
  }
}

/// Represents a sequence of animations for a mesh gradient point.
///
/// Encapsulates the details of an animation sequence, including the index of the point
/// to be animated, the new state of the point after the animation, and the interval
/// during which the animation occurs.
class AnimationSequence {
  /// The index of the point in the mesh gradient to be animated.
  final int pointIndex;

  /// The new state of the point after the animation completes.
  final MeshGradientPoint newPoint;

  /// The interval during which the animation occurs.
  final Interval interval;

  /// Constructs an [AnimationSequence].
  ///
  /// Requires [pointIndex] to specify the index of the point to be animated,
  /// [newPoint] to specify the new state of the point, and [interval] to specify
  /// the timing of the animation.
  AnimationSequence({
    required this.pointIndex,
    required this.newPoint,
    required this.interval,
  });
}
