# Mesh Gradient

Widgets which create beautiful fluid-like mesh gradients in Flutter.

[![Pub Version](https://img.shields.io/badge/dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white)](https://pub.dev/packages/mesh_gradient)

![AnimatedMeshGradient Demo](https://github.com/ben-fornefeld/mesh_gradient/blob/main/example/demo/demo-animated.gif)

## Widgets

- `MeshGradient`: Recommended for _no_ / _complex_ animations since it is _highly customizable_
- `AnimatedMeshGradient`: Recommended for _easy_ animation implementation

# MeshGradient

The `MeshGradient` widget is a powerful and versatile tool for creating stunning visual effects in Flutter applications. It allows developers to craft acrylic-like mesh gradients with ease, offering a high degree of customization to achieve the desired aesthetic. This widget is particularly well-suited for applications that require dynamic, complex animations or a unique visual flair.

Key features of the `MeshGradient` widget include:

- **Customizable Points**: Developers can define multiple `MeshGradientPoint` objects, each specifying a position and color. This flexibility allows for intricate designs and animations.
- **Animation Support**: Through the `MeshGradientController`, the widget supports complex animations. Developers can animate individual points or sequences of points, controlling aspects like duration, curve, and sequence intervals.
- **Highly Customizable**: With the `MeshGradientOptions`, users can adjust the blend strength and noise intensity of the gradient, allowing for fine-tuned control over the gradient's appearance.

Example usage scenarios for the `MeshGradient` widget include creating dynamic backgrounds, animated illustrations, and interactive elements that respond to user input. Its ability to produce fluid and complex animations makes it an excellent choice for developers looking to add a visually captivating element to their Flutter applications.

You could add it to your widget tree like this:

```dart
MeshGradient(
  points: [
    MeshGradientPoint(
      position: const Offset(
         0.2,
        0.6,
      ),
      color: const Color.fromARGB(255, 251, 0, 105),
    ),
    MeshGradientPoint(
      position: const Offset(
        0.4,
        0.5,
      ),
      color: const Color.fromARGB(255, 69, 18, 255),
    ),
    MeshGradientPoint(
      position: const Offset(
        0.7,
        0.4,
      ),
      color: const Color.fromARGB(255, 0, 255, 198),
    ),
    MeshGradientPoint(
      position: const Offset(
        0.4,
        0.9,
      ),
      color: const Color.fromARGB(255, 64, 255, 0),
    ),
  ],
  options: MeshGradientOptions(),
)
```

or like this:

```dart

late final _controller;

@override
void initState() {
  super.initState();
  _controller = MeshGradientController(
    points: [
      MeshGradientPoint(
        position: const Offset(
          0.2,
          0.6,
        ),
        color: const Color.fromARGB(255, 251, 0, 105),
      ),
      MeshGradientPoint(
        position: const Offset(
          0.4,
          0.5,
        ),
        color: const Color.fromARGB(255, 69, 18, 255),
      ),
      MeshGradientPoint(
        position: const Offset(
          0.7,
          0.4,
        ),
        color: const Color.fromARGB(255, 0, 255, 198),
      ),
      MeshGradientPoint(
        position: const Offset(
          0.4,
          0.9,
        ),
        color: const Color.fromARGB(255, 64, 255, 0),
      ),
    ],
    vsync: this,
  );
}

@override
void dispose() {
  _controller.dispose();
  super.dispose();
}

// somewhere in your widget tree...

MeshGradient(
  controller: _controller
  options: MeshGradientOptions(),
)
```

The `MeshGradientController` class manages the animation of mesh gradient points. It utilizes `ValueNotifier` to track changes to mesh gradient points and supports animating individual points or sequences of points with customizable durations, curves, and other parameters. The controller requires a list of `MeshGradientPoint` objects and a `TickerProvider` for animations. It provides methods `animatePoint` for animating a single point and `animateSequence` for animating a sequence of points, both allowing customization of the animation's curve and duration. Additionally, it includes the `AnimationSequence` class to encapsulate details of an animation sequence for a mesh gradient point, including the point index, the new state of the point, and the animation interval.

## Usage

```dart
_controller.animateSequence(
  duration: const Duration(seconds: 5),
  sequences: [
    AnimationSequence(
      pointIndex: 0,
      newPoint: MeshGradientPoint(
        position: const Offset(0.9, 0.9),
        color: Colors.blue,
      ),
      interval: const Interval(
        0,
        0.7,
        curve: Curves.easeInOut,
      ),
    ),
    AnimationSequence(
      pointIndex: 1,
      newPoint: MeshGradientPoint(
        position: const Offset(0.1, 0.1),
        color: Colors.red,
      ),
      interval: const Interval(
        0,
        0.4,
        curve: Curves.ease,
      ),
    ),
  ]
);
```

```dart
_controller.animatePoint(
  0,
  MeshGradientPoint(
    position: const Offset(0.9, 0.9),
    color: Colors.blue,
  ),
  curve: Curves.easeInExpo,
  duration: const Duration(seconds: 2),
);
```

The first code snippet demonstrates how to use the `animateSequence` method of the `MeshGradientController` to animate a sequence of mesh gradient points. It specifies a total animation duration of 5 seconds and includes two animation sequences. The first sequence animates the point at index 0 to a new position and color with an animation interval from 0 to 0.7 using the `Curves.easeInOut` curve. The second sequence animates the point at index 1 to a different position and color with an animation interval from 0 to 0.4 using the `Curves.ease` curve.

The second code snippet shows how to animate a single mesh gradient point using the `animatePoint` method of the `MeshGradientController`. It animates the point at index 0 to a new position and color, with a specified curve of `Curves.easeInExpo` and a duration of 2 seconds.

## Options

- `blend`: controls the blending strength between the colors of the mesh gradient, with a higher value resulting in less blending effects. The default value is 3.
- `noiseIntensity`: controls the intensity of the acrylic noise applied to the gradient, affecting the granularity of the noise texture on the gradient. The default value is 0.2.

# Animated Mesh Gradient

The `AnimatedMeshGradient` widget is designed to create visually appealing, animated mesh gradients. It allows developers to easily implement fluid, dynamic gradients that can animate between different colors, creating a captivating visual effect in their applications. This widget is highly customizable, offering control over animation speed, frequency, and amplitude, making it suitable for a wide range of design requirements. Whether you're looking to add a subtle background animation or a striking visual element, the `AnimatedMeshGradient` widget provides a performant and easy-to-use solution.

Add it to your widget tree like this:

```dart
AnimatedMeshGradient(
  colors: [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow,
  ],
  options: AnimatedMeshGradientOptions(),
)
```

If you need to control the animation manually, you can use `AnimatedMeshGradientController` like this:

```dart
// Initialize the controller
late final AnimatedMeshGradientController _controller = AnimatedMeshGradientController();

...

// Reference in the widget
AnimatedMeshGradient(
  colors: [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow,
  ],
  options: AnimatedMeshGradientOptions(),
  controller: _controller,
)

...

// Use it to your needs
void toggleAnimation() {
  _controller.isAnimating.value ? _controller.stop() : _controller.start();
}

...

// If you need to react to controller changes in your widget,
// just wrap it with [ValueListenableBuilder]
ValueListenableBuilder(
  valueListenable: _controller.isAnimating,
  builder: (context, value, child) {
    return Text(value ? 'Dancing' : 'Chilling');
  }
)

```

## Options

- `colors`: A list of four `Color` objects that define the gradient colors used in the animation.
- `speed`: The animation speed, controlling how fast the fluid effect moves. A higher value means faster animation.
- `frequency`: The frequency of the fluid wave. Higher values create more ripples.
- `amplitude`: The amplitude of the fluid wave. Higher values create more pronounced deformations.
- `seed`: A seed value that gives back a static snapshot of the animation. This stops the animation.

# Credits

`Mesh Gradient` makes use of the following packages:

- [flutter_shaders](https://pub.dev/packages/flutter_shaders)

# Issues and Contributions

If you encounter any issues or have suggestions for improvements, please feel free to [open an issue](https://github.com/ben-fornefeld/mesh_gradient/issues). Contributions are also welcome!

# License

This package is licensed under the [MIT License](https://opensource.org/license/mit).
