import 'package:flutter/material.dart';
import 'package:flutter_shaders/flutter_shaders.dart';
import 'package:mesh_gradient/src/widgets/animated_mesh_gradient/animated_mesh_gradient_controller.dart';
import 'package:mesh_gradient/src/widgets/animated_mesh_gradient/animated_mesh_gradient_options.dart';
import 'package:mesh_gradient/src/widgets/animated_mesh_gradient/animated_mesh_gradient_painter.dart';

/// A widget that paints an animated mesh gradient.
///
/// This widget creates a visually appealing animated gradient effect by meshing together
/// four colors. It allows for customization through various parameters such as colors,
/// animation options, and a manual controller for animation control.
class AnimatedMeshGradient extends StatefulWidget {
  /// Creates a meshed gradient with provided colors and animates between them.
  ///
  /// The [colors] parameter must contain exactly four colors which will be used to
  /// create the animated gradient. The [options] parameter allows for customization
  /// of the animation effect. A [seed] can be provided to generate a static gradient
  /// based on the colors, effectively stopping the animation. The [controller] can be
  /// used for manual control over the animation. A [child] widget can be placed on top
  /// of the gradient.
  const AnimatedMeshGradient({
    super.key,
    required this.colors,
    required this.options,
    this.child,
    this.controller,
    this.seed,
  });

  /// Define 4 colors which will be used to create an animated gradient.
  final List<Color> colors;

  /// Here you can define options to play with the animation / effect.
  final AnimatedMeshGradientOptions options;

  /// Sets a seed for the mesh gradient which gives back a static blended gradient based on the given colors.
  /// This setting stops the animation. Try out different values until you like what you see.
  final double? seed;

  /// Can be used to start / stop the animation manually. Will be ignored if [seed] is set.
  final AnimatedMeshGradientController? controller;

  /// The child widget to display on top of the gradient.
  final Widget? child;

  @override
  State<AnimatedMeshGradient> createState() => _AnimatedMeshGradientState();
}

class _AnimatedMeshGradientState extends State<AnimatedMeshGradient> {
  /// Path to the shader asset used for the gradient animation.
  static const String _shaderAssetPath =
      'packages/mesh_gradient/shaders/animated_mesh_gradient.frag';

  /// The current time value used to control the animation phase.
  late double _time = widget.seed ?? 0;

  /// Recursively updates the animation time and triggers a repaint.
  ///
  /// This method is called periodically and ensures the animation continues
  /// to run. It checks if the widget is still mounted and if the controller
  /// (if present) allows for the animation to proceed.
  void _timeLoop() {
    if (!mounted ||
        (widget.controller != null
            ? !widget.controller!.isAnimating.value
            : false)) {
      return;
    }

    setState(() {
      _time += 16 / 1000;
    });

    Future.delayed(const Duration(milliseconds: 16), () => _timeLoop());
  }

  @override
  void initState() {
    super.initState();
    // Attempts to precache the shader used for the gradient animation.
    Future(() async {
      try {
        await ShaderBuilder.precacheShader(_shaderAssetPath);
      } catch (e) {
        debugPrint('[AnimatedMeshGradient] [Exception] Precaching Shader: $e');
        debugPrintStack(stackTrace: StackTrace.current);
      }
    });

    // Ensures exactly four colors are provided.
    if (widget.colors.length != 4) {
      throw Exception(
          'Condition colors.length == 4 is not true. Assign exactly 4 colors.');
    }

    // Initializes the animation based on the provided seed or controller.
    if (widget.seed != null) {
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (widget.controller == null) {
        _timeLoop();
      }

      if (widget.controller != null && widget.seed == null) {
        widget.controller!.isAnimating.addListener(() {
          if (widget.controller!.isAnimating.value) {
            _timeLoop();
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Builds the widget using a ShaderBuilder to apply the animated mesh gradient effect.
    return ShaderBuilder(
      assetKey: _shaderAssetPath,
      (context, shader, child) {
        return CustomPaint(
          painter: AnimatedMeshGradientPainter(
            shader: shader,
            time: _time,
            colors: widget.colors,
            options: widget.options,
          ),
          willChange: true,
          child: child,
        );
      },
      child: widget.child,
    );
  }
}
