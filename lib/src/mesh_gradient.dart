import 'package:flutter/material.dart';
import 'package:flutter_shaders/flutter_shaders.dart';
import 'package:mesh_gradient/src/mesh_gradient_options.dart';
import 'package:mesh_gradient/src/mesh_gradient_painter.dart';
import 'package:mesh_gradient/src/mesh_gradient_point.dart';

enum MeshGradientAnimation { dancer }

class MeshGradient extends StatefulWidget {
  const MeshGradient({
    super.key,
    required this.points,
    required this.options,
    this.child,
  });

  final List<MeshGradientPoint> points;
  final Widget? child;
  final MeshGradientOptions options;

  @override
  State<MeshGradient> createState() => _MeshGradientState();
}

class _MeshGradientState extends State<MeshGradient> {
  static const String _shaderAssetPath =
      'packages/mesh_gradient/shaders/point_mesh_gradient.frag';

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ShaderBuilder(
      assetKey: _shaderAssetPath,
      (context, shader, child) {
        return CustomPaint(
          painter: MeshGradientPainter(
            shader: shader,
            points: widget.points,
            options: widget.options,
          ),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}
