import 'dart:ui';

/// Holds a point and its color for the mesh gradient
class MeshGradientPoint {
  MeshGradientPoint({
    required this.position,
    required this.color,
  }) {
    assert(position.dx >= 0 && position.dx <= 1,
        'The x value of the position must be between 0 and 1');
    assert(position.dy >= 0 && position.dy <= 1,
        'The y value of the position must be between 0 and 1');
  }

  final Offset position;
  final Color color;
}
