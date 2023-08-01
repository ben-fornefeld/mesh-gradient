import 'dart:ui';
import 'package:animated_mesh_gradient/models/animated_mesh_gradient_options.dart';
import 'package:flutter/material.dart';
import 'package:animated_mesh_gradient/painters/animated_mesh_gradient_painter.dart';

class AnimatedMeshGradient extends StatefulWidget {
  const AnimatedMeshGradient({
    super.key,
    required this.colors,
    required this.options,
  });

  final List<Color> colors;
  final AnimatedMeshGradientOptions options;

  @override
  State<AnimatedMeshGradient> createState() => _AnimatedMeshGradientState();
}

class _AnimatedMeshGradientState extends State<AnimatedMeshGradient> {
  double _time = 0;

  void _timeLoop() {
    if (!mounted) return;
    setState(() {
      _time += 4 / 1000;
    });
    Future.delayed(const Duration(milliseconds: 4), () => _timeLoop());
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
    return FutureBuilder(
      future: FragmentProgram.fromAsset('shaders/mesh_gradient.frag'),
      builder: (context, data) => data.hasData
          ? CustomPaint(
              painter: AnimatedMeshGradientPainter(
                shader: data.data!.fragmentShader(),
                time: _time,
                colors: widget.colors,
                options: widget.options,
              ),
            )
          : Container(),
    );
  }
}
