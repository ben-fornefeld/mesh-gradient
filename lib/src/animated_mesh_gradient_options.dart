class AnimatedMeshGradientOptions {
  AnimatedMeshGradientOptions({
    this.frequency = 5,
    this.amplitude = 30,
    this.speed = 2,
  });

  /// Sets the frequency of the gradient.
  final double frequency;

  /// Sets the amplitude of the gradient.
  final double amplitude;

  /// Sets the speed of the animation. This is a factor and is used in the computation, which makes it behave differently based on the other values provided.
  final double speed;
}
