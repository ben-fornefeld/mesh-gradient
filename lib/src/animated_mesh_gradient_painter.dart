import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:mesh_gradient/src/animated_mesh_gradient_options.dart';

class AnimatedMeshGradientPainter extends CustomPainter {
  AnimatedMeshGradientPainter({
    required this.shader,
    required this.time,
    required this.colors,
    required this.options,
  });

  final FragmentShader shader;
  final double time;
  final List<Color> colors;
  final AnimatedMeshGradientOptions options;

  @override
  void paint(Canvas canvas, Size size) {
    //uSize
    shader.setFloat(0, size.width);
    shader.setFloat(1, size.height);

    //uTime
    shader.setFloat(2, time);

    //values
    shader.setFloat(3, options.frequency);
    shader.setFloat(4, options.amplitude);
    shader.setFloat(5, options.speed);

    //colors
    int i = 6;
    for (Color color in colors) {
      shader.setFloat(i, color.red / 255);
      i++;
      shader.setFloat(i, color.green / 255);
      i++;
      shader.setFloat(i, color.blue / 255);
      i++;
    }

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..shader = shader,
    );
  }

  @override
  bool shouldRepaint(covariant AnimatedMeshGradientPainter oldDelegate) =>
      oldDelegate.time != time ||
      oldDelegate.options != options ||
      oldDelegate.colors != colors;
}
