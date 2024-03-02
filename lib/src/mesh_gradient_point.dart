import 'dart:ui';

/// Holds a point and its color for the mesh gradient
class MeshGradientPoint {
  MeshGradientPoint({
    required this.position,
    required this.color,
  });

  final Offset position;
  final Color color;
}
