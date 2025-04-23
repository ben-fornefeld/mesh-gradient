import 'package:flutter/material.dart';
import 'package:flutter_shaders/flutter_shaders.dart';
import 'package:mesh_gradient/src/widgets/mesh_gradient/mesh_gradient_controller.dart';
import 'package:mesh_gradient/src/widgets/mesh_gradient/mesh_gradient_options.dart';
import 'package:mesh_gradient/src/widgets/mesh_gradient/mesh_gradient_painter.dart';
import 'package:mesh_gradient/src/widgets/mesh_gradient/mesh_gradient_point.dart';

/// A widget that paints a mesh gradient using a custom shader.
///
/// This widget uses a [MeshGradientPainter] to paint the gradient based on the provided
/// [points] or the current state of the [controller]. It requires [options] to configure
/// the appearance of the gradient. Optionally, a [child] widget can be provided to be
/// displayed on top of the gradient.
class MeshGradient extends StatefulWidget {
  /// Creates a [MeshGradient] widget.
  ///
  /// Either [points] or [controller] must be provided, but not both. This is enforced
  /// by an assertion. [options] must also be provided to configure the gradient.
  MeshGradient({
    super.key,
    this.points,
    this.controller,
    required this.options,
    this.child,
  }) {
    assert(
        (points != null && controller == null) ||
            (controller != null && points == null),
        "You must provide either points or a controller, but not both.");
  }

  /// The list of points defining the mesh gradient.
  ///
  /// If null, the gradient is controlled by the [controller].
  final List<MeshGradientPoint>? points;

  /// The child widget to display on top of the gradient.
  final Widget? child;

  /// The options to configure the appearance of the mesh gradient.
  final MeshGradientOptions options;

  /// The controller to dynamically update the mesh gradient.
  ///
  /// If null, the gradient is defined by the static [points].
  final MeshGradientController? controller;

  @override
  State<MeshGradient> createState() => _MeshGradientState();
}

class _MeshGradientState extends State<MeshGradient> {
  /// The asset path to the shader used for rendering the mesh gradient.
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
    // Use ShaderBuilder to create a widget that will paint the gradient.
    return ShaderBuilder(
      assetKey: _shaderAssetPath,
      (context, shader, child) {
        // If a controller is provided, use a ValueListenableBuilder to rebuild
        // the gradient whenever the controller's points change.
        if (widget.controller != null) {
          return ValueListenableBuilder(
            valueListenable: widget.controller!.points,
            child: child,
            builder: (context, value, child) {
              return CustomPaint(
                willChange: true,
                painter: MeshGradientPainter(
                  shader: shader,
                  points: value,
                  options: widget.options,
                ),
                child: child,
              );
            },
          );
        }

        // If no controller is provided, paint the gradient using the static points.
        return CustomPaint(
          painter: MeshGradientPainter(
            shader: shader,
            points: widget.points!,
            options: widget.options,
          ),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}
