/// A class that provides configuration options for the [AnimatedMeshGradient] widget.
///
/// This class allows you to customize the appearance and behavior of the animated mesh gradient
/// by setting various parameters such as frequency, amplitude, and speed of the animation.
class AnimatedMeshGradientOptions {
  /// Creates an instance of [AnimatedMeshGradientOptions] with the given settings.
  ///
  /// The [frequency], [amplitude], and [speed] parameters can be used to control the visual
  /// and animation characteristics of the mesh gradient. Defaults are provided for each parameter.
  ///
  /// - [frequency]: Determines how often the gradient oscillates. Default value is 5.
  /// - [amplitude]: Controls the height of the gradient's oscillations. Default value is 30.
  /// - [speed]: Affects the rate at which the animation progresses. Default value is 2.
  AnimatedMeshGradientOptions({
    this.frequency = 5,
    this.amplitude = 30,
    this.speed = 2,
  });

  /// The frequency of the gradient's oscillations.
  ///
  /// A higher value results in more frequent oscillations. This parameter directly influences
  /// the visual complexity of the gradient pattern.
  final double frequency;

  /// The amplitude of the gradient's oscillations.
  ///
  /// This parameter determines the height of the oscillations, affecting how pronounced
  /// the gradient transitions appear within the animated mesh.
  final double amplitude;

  /// The speed of the animation.
  ///
  /// This parameter is a multiplier that affects how quickly the animation progresses.
  /// Higher values result in faster animations. The speed interacts with both the frequency
  /// and amplitude to create dynamic visual effects.
  final double speed;
}
