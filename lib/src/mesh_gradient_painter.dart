import 'dart:ui';
import 'package:mesh_gradient/src/mesh_gradient_point.dart';
import 'package:flutter/material.dart';
import 'package:mesh_gradient/src/mesh_gradient_options.dart';

/// A custom painter that paints a mesh gradient
class MeshGradientPainter extends CustomPainter {
  MeshGradientPainter({
    required this.shader,
    required this.points,
    required this.options,
  }) {
    assert(points.length <= 6);
    assert(points.isNotEmpty);
    assert(options.noiseIntensity >= 0);
    assert(options.noiseIntensity <= 1);
    assert(options.blend >= 0);
    assert(options.blend <= 10);
  }

  final FragmentShader shader;
  final List<MeshGradientPoint> points;
  final MeshGradientOptions options;

  @override
  void paint(Canvas canvas, Size size) {
    //uSize
    shader.setFloat(0, size.width);

    //uHeight
    shader.setFloat(1, size.height);

    //uBlend
    shader.setFloat(2, options.blend);

    //uNoiseIntensity
    shader.setFloat(3, options.noiseIntensity);

    //uNumPoints
    shader.setFloat(4, points.length.toDouble());

    int j = 5;

    //uPositions
    for (int i = 0; i < 6; i++) {
      Offset pos = i >= points.length ? const Offset(0, 0) : points[i].position;

      shader.setFloat(j, pos.dx);
      j++;
      shader.setFloat(j, pos.dy);
      j++;
    }

    //uColors
    for (int i = 0; i < 6; i++) {
      Color color = i >= points.length ? Colors.black : points[i].color;

      shader.setFloat(j, color.red / 255);
      j++;
      shader.setFloat(j, color.green / 255);
      j++;
      shader.setFloat(j, color.blue / 255);
      j++;
    }

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..shader = shader,
    );
  }

  @override
  bool shouldRepaint(covariant MeshGradientPainter oldDelegate) =>
      oldDelegate.points != points || oldDelegate.options != options;
}
