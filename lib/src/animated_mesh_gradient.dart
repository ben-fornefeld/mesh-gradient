import 'package:animated_mesh_gradient/src/animated_mesh_gradient_options.dart';
import 'package:flutter/material.dart';
import 'package:animated_mesh_gradient/src/animated_mesh_gradient_painter.dart';
import 'package:flutter_shaders/flutter_shaders.dart';

class AnimatedMeshGradient extends StatefulWidget {
  const AnimatedMeshGradient({
    super.key,
    required this.colors,
    required this.options,
    this.child,
  });

  final List<Color> colors;
  final AnimatedMeshGradientOptions options;
  final Widget? child;

  @override
  State<AnimatedMeshGradient> createState() => _AnimatedMeshGradientState();
}

class _AnimatedMeshGradientState extends State<AnimatedMeshGradient> {
  double _time = 0;

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
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _timeLoop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ShaderBuilder(
      assetKey: 'packages/animated_mesh_gradient/shaders/mesh_gradient.frag',
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
