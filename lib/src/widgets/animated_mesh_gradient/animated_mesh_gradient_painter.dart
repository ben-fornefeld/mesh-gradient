import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:mesh_gradient/src/widgets/animated_mesh_gradient/animated_mesh_gradient_options.dart';

/// A [CustomPainter] subclass that paints an animated mesh gradient on a canvas.
/// This painter uses a [FragmentShader] to create the gradient effect, which is animated over time.
class AnimatedMeshGradientPainter extends CustomPainter {
  /// Creates an [AnimatedMeshGradientPainter].
  ///
  /// Requires a [FragmentShader] to apply the mesh gradient effect, a [double] value for time to animate the gradient,
  /// a list of [Color]s to define the gradient colors, and [AnimatedMeshGradientOptions] to customize the animation.
  const AnimatedMeshGradientPainter({
    required this.shader,
    required this.time,
    required this.colors,
    required this.options,
  });

  /// The shader used to create the mesh gradient effect.
  final FragmentShader shader;

  /// The current time value, used to animate the gradient.
  final double time;

  /// The colors used in the mesh gradient.
  final List<Color> colors;

  /// The options to customize the animation of the mesh gradient.
  final AnimatedMeshGradientOptions options;

  @override
  void paint(Canvas canvas, Size size) {
    // Sets the size of the canvas to the shader.
    shader.setFloat(0, size.width);
    shader.setFloat(1, size.height);

    // Sets the current time to the shader to animate the gradient.
    shader.setFloat(2, time);

    // Sets the animation options to the shader.
    shader.setFloat(3, options.frequency);
    shader.setFloat(4, options.amplitude);
    shader.setFloat(5, options.speed);
    shader.setFloat(6, options.grain);

    // Converts and sets the gradient colors to the shader.
    int i = 7;
    for (Color color in colors) {
      shader.setFloat(i, color.r);
      i++;
      shader.setFloat(i, color.g);
      i++;
      shader.setFloat(i, color.b);
      i++;
    }

    // Draws the rectangle filled with the animated mesh gradient.
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..shader = shader,
    );
  }

  @override

  /// Determines whether the painter should repaint.
  ///
  /// Returns true if the time, options, or colors have changed, triggering a repaint.
  bool shouldRepaint(covariant AnimatedMeshGradientPainter oldDelegate) =>
      oldDelegate.time != time ||
      oldDelegate.options != options ||
      oldDelegate.colors != colors;
}
