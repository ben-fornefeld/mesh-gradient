import 'package:flutter/material.dart';
import 'package:flutter_shaders/flutter_shaders.dart';
import 'package:mesh_gradient/src/animated_mesh_gradient_controller.dart';
import 'package:mesh_gradient/src/animated_mesh_gradient_options.dart';
import 'package:mesh_gradient/src/animated_mesh_gradient_painter.dart';

/// A widget that paints an animated mesh gradient
class AnimatedMeshGradient extends StatefulWidget {
  /// Creates a meshed gradient with provided colors and animates between them.
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
  /// This settings stops the animation. Try out different values until you like what you see.
  final double? seed;

  /// Can be used to start / stop the animation manually. Will be ignored if [seed] is set.
  final AnimatedMeshGradientController? controller;

  final Widget? child;

  @override
  State<AnimatedMeshGradient> createState() => _AnimatedMeshGradientState();
}

class _AnimatedMeshGradientState extends State<AnimatedMeshGradient> {
  static const String _shaderAssetPath =
      'packages/mesh_gradient/shaders/animated_mesh_gradient.frag';

  late double _time = widget.seed ?? 0;

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
    Future(() async {
      try {
        await ShaderBuilder.precacheShader(_shaderAssetPath);
      } catch (e) {
        debugPrint('[AnimatedMeshGradient] [Exception] Precaching Shader: $e');
        debugPrintStack(stackTrace: StackTrace.current);
      }
    });

    if (widget.colors.length != 4) {
      throw Exception(
          'Condition colors.length == 4 is not true. Assign exactly 4 colors.');
    }

    super.initState();

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
