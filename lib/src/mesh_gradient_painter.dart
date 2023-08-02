import 'dart:ui';
import 'package:mesh_gradient/src/mesh_gradient_point.dart';
import 'package:flutter/material.dart';

class MeshGradientPainter extends CustomPainter {
  MeshGradientPainter({
    required this.shader,
    required this.points,
  });

  final FragmentShader shader;
  final List<MeshGradientPoint> points;

  @override
  void paint(Canvas canvas, Size size) {
    //uSize
    shader.setFloat(0, size.width);
    shader.setFloat(1, size.height);

    //uNPoints
    shader.setFloat(2, points.length.toDouble());

    //uBlend
    shader.setFloat(3, 3);

    int j = 4;

    //positions
    for (int i = 0; i < 6; i++) {
      Offset pos =
          i > (points.length - 1) ? const Offset(0, 0) : points[i].position;

      shader.setFloat(j, pos.dx);
      j++;
      shader.setFloat(j, pos.dy);
      j++;
    }

    //colors
    for (int i = 0; i < 6; i++) {
      Color color = i > (points.length - 1) ? Colors.black : points[i].color;

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
      oldDelegate.points != points;
}
