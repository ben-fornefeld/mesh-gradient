import 'dart:ui';
import 'package:mesh_gradient/src/widgets/mesh_gradient/mesh_gradient_point.dart';
import 'package:flutter/material.dart';
import 'package:mesh_gradient/src/widgets/mesh_gradient/mesh_gradient_options.dart';

/// A custom painter that paints a mesh gradient.
///
/// This painter uses a fragment shader to render a gradient based on a set of points and options.
/// It supports up to 6 points to define the gradient mesh. Each point has a position and a color.
/// The options allow for configuring the blend and noise intensity of the gradient.
class MeshGradientPainter extends CustomPainter {
  /// Creates a [MeshGradientPainter].
  ///
  /// The [shader] is the fragment shader used to render the gradient.
  /// The [points] list contains the points defining the mesh gradient.
  /// The [options] define the appearance of the gradient.
  ///
  /// The constructor asserts that there are between 2 and 6 points,
  /// and that the noise intensity and blend values are within their respective ranges.
  MeshGradientPainter({
    required this.shader,
    required this.points,
    required this.options,
  }) {
    // Ensure the points list contains between 2 and 6 points inclusive.
    assert(points.length <= 6, 'The number of points must not exceed 6.');
    assert(points.length >= 2,
        'There must be at least 2 points to define a mesh gradient.');
    // Validate the noise intensity is within the range [0, 1].
    assert(
        options.noiseIntensity >= 0, 'Noise intensity cannot be less than 0.');
    assert(options.noiseIntensity <= 1, 'Noise intensity cannot exceed 1.');
    // Ensure the blend option is within the range [0, 10].
    assert(options.blend >= 0, 'Blend value cannot be less than 0.');
    assert(options.blend <= 10, 'Blend value cannot exceed 10.');
  }

  /// The fragment shader used to render the gradient.
  final FragmentShader shader;

  /// The list of points defining the mesh gradient.
  final List<MeshGradientPoint> points;

  /// The options defining the appearance of the mesh gradient.
  final MeshGradientOptions options;

  @override
  void paint(Canvas canvas, Size size) {
    // Set shader parameters based on the size, blend, noise intensity, and number of points.
    shader.setFloat(0, size.width); // uSize
    shader.setFloat(1, size.height); // uHeight
    shader.setFloat(2, options.blend); // uBlend
    shader.setFloat(3, options.noiseIntensity); // uNoiseIntensity
    shader.setFloat(4, points.length.toDouble()); // uNumPoints

    int j = 5;

    // Set shader parameters for the positions of up to 6 points.
    // If there are fewer than 6 points, the remaining positions are set to (0, 0).
    for (int i = 0; i < 6; i++) {
      Offset pos = i >= points.length ? const Offset(0, 0) : points[i].position;
      shader.setFloat(j++, pos.dx);
      shader.setFloat(j++, pos.dy);
    }

    // Set shader parameters for the colors of up to 6 points.
    // If there are fewer than 6 points, the remaining colors are set to black.
    for (int i = 0; i < 6; i++) {
      Color color = i >= points.length ? Colors.black : points[i].color;
      shader.setFloat(j++, color.red / 255);
      shader.setFloat(j++, color.green / 255);
      shader.setFloat(j++, color.blue / 255);
    }

    // Paint the rectangle covering the canvas with the gradient.
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..shader = shader,
    );
  }

  @override
  bool shouldRepaint(covariant MeshGradientPainter oldDelegate) =>
      oldDelegate.points != points || oldDelegate.options != options;
}
