/// A class that encapsulates the configuration options for a mesh gradient.
///
/// This class allows for the customization of the mesh gradient's appearance
/// by adjusting the blend strength and noise intensity.
class MeshGradientOptions {
  /// Constructs an instance of [MeshGradientOptions] with optional parameters.
  ///
  /// The [blend] parameter controls the blending strength between the colors
  /// of the mesh gradient, with a default value of 3.
  /// The [noiseIntensity] parameter controls the intensity of the noise
  /// applied to the gradient, with a default value of 0.2.
  MeshGradientOptions({
    this.blend = 3,
    this.noiseIntensity = 0.2,
  });

  /// The blending strength between the colors of the mesh gradient.
  ///
  /// A higher value results in a stronger blending effect. The default value is 3.
  final double blend;

  /// The intensity of the noise applied to the mesh gradient.
  ///
  /// This value affects the granularity of the noise texture on the gradient.
  /// The default value is 0.5.
  final double noiseIntensity;
}
