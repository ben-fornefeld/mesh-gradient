import 'dart:ui';

/// Represents a single point in a mesh gradient, consisting of a position and a color.
///
/// This class is used to define the characteristics of a point within a mesh gradient,
/// where each point has a specific position and color. The position is defined within
/// a normalized coordinate space, where both the x and y values must be between 0 and 1,
/// inclusive. This ensures that the point can be accurately placed within the gradient mesh.
///
/// The color of the point is used to determine the color of the gradient at that specific
/// position, allowing for the creation of complex and visually appealing gradients.
class MeshGradientPoint {
  /// Creates a [MeshGradientPoint] with the given position and color.
  ///
  /// The [position] parameter specifies the location of the point within the gradient mesh,
  /// and must have both x and y values between 0 and 1, inclusive. This is enforced through
  /// assertions during runtime.
  ///
  /// The [color] parameter specifies the color of the gradient at the point's position.
  ///
  /// Throws an [AssertionError] if the position is outside the allowed range.
  MeshGradientPoint({
    required this.position,
    required this.color,
  }) {
    assert(position.dx >= 0 && position.dx <= 1,
        'The x value of the position must be between 0 and 1');
    assert(position.dy >= 0 && position.dy <= 1,
        'The y value of the position must be between 0 and 1');
  }

  /// The position of the point within the gradient mesh.
  ///
  /// This is a normalized value, with both x and y ranging from 0 to 1, inclusive.
  final Offset position;

  /// The color of the gradient at this point's position.
  final Color color;
}
