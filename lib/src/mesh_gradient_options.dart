/// Options for the mesh gradient
class MeshGradientOptions {
  MeshGradientOptions({
    this.blend = 3,
    this.noiseIntensity = 0.5,
  });

  /// Defines the blending strength between the colors
  final double blend;

  /// Defines the intensity
  final double noiseIntensity;
}
