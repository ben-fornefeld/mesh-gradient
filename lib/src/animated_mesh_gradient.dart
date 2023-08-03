import 'package:flutter/material.dart';
import 'package:flutter_shaders/flutter_shaders.dart';
import 'package:mesh_gradient/src/animated_mesh_gradient_options.dart';
import 'package:mesh_gradient/src/animated_mesh_gradient_painter.dart';

class AnimatedMeshGradient extends StatefulWidget {
  /// Creates a meshed gradient with provided colors and animates between them.
  const AnimatedMeshGradient({
    super.key,
    required this.colors,
    required this.options,
    this.child,
    this.seed,
  });

  /// Define 4 colors which will be used to create an animated gradient.
  final List<Color> colors;

  /// Here you can define options to play with the animation / effect.
  final AnimatedMeshGradientOptions options;

  /// Sets a seed for the mesh gradient which gives back a static blended gradient based on the given colors.
  /// This settings stops the animation. Try out different values until you like what you see.
  final double? seed;

  final Widget? child;

  @override
  State<AnimatedMeshGradient> createState() => _AnimatedMeshGradientState();
}

class _AnimatedMeshGradientState extends State<AnimatedMeshGradient> {
  late double _time = widget.seed ?? 0;

  void _timeLoop() {
    if (!mounted) return;

    setState(() {
      _time += 16 / 1000;
    });

    Future.delayed(const Duration(milliseconds: 16), () => _timeLoop());
  }

  @override
  void initState() {
    if (widget.colors.length != 4) {
      throw Exception(
          'Condition colors.length == 4 is not true. Assign exactly 4 colors.');
    }

    super.initState();

    if (widget.seed != null) {
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _timeLoop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ShaderBuilder(
      assetKey: 'packages/mesh_gradient/shaders/animated_mesh_gradient.frag',
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
