import 'dart:ui';

/// Represents a single point in a mesh gradient, consisting of a position and a color.
///
/// This class is used to define the characteristics of a point within a mesh gradient,
/// where each point has a specific position and color. The position is defined within
/// a normalized coordinate space. This ensures that the point can be accurately placed within the gradient mesh, no matter the device.
///
/// The color of the point is used to determine the color of the gradient at that specific
/// position, allowing for the creation of complex and visually appealing gradients.
class MeshGradientPoint {
  /// Creates a [MeshGradientPoint] with the given position and color.
  ///
  /// The [position] parameter is an [Offset] with normalized x & y coordinates. Specify the location of the point within the gradient mesh, with top-left being (0,0) and bottom-right being (1,1).
  /// If you need to position points out of the rendered bounds, just use higher values than 0-1.
  ///
  /// The [color] parameter specifies the color of the gradient at the point's position.
  ///
  /// Throws an [AssertionError] if the position is outside the allowed range.
  MeshGradientPoint({
    required this.position,
    required this.color,
  });

  /// The position of the point within the gradient mesh.
  /// This is a normalized value, with top-left being (0,0) and bottom-right being (1,1). Values outside of 0-1 are allowed, to place [MeshGradientPoint]s out of the rendered bounds.
  final Offset position;

  /// The color of the gradient at this point's position.
  final Color color;
}
