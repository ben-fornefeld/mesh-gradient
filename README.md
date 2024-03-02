# Mesh Gradient

A widget to create beautiful fluid-like mesh gradients in Flutter.

[![Pub Version](https://img.shields.io/badge/dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white)](https://pub.dev/packages/mesh_gradient)

![AnimatedMeshGradient Demo](https://github.com/ben-fornefeld/mesh_gradient/blob/main/example/demo/demo-animated.gif)

## Features

- `Controllable static Mesh Gradients`: Control the look of your Mesh Gradient with Colors and Positions.
- `Fluid animation Mesh Gradients`: Widget animates smoothly between the four specified colors, creating a visually appealing fluid effect.
- `Customizable options`: Control the animation speed, frequency, and amplitude to achieve the desired visual effect.
- `Frozen mesh gradient`: Set a seed which gives back a static snapshot of the gradient animation.
- `Highly performant`: Built with Flutter CustomPainter and FragmentShader, the widget ensures optimal performance and smooth animation even on lower-end devices.
- `Easy integration`: Simply add the widget to your Flutter project and customize the colors and options to suit your application's design.

## Getting Started

Follow these steps to integrate `Mesh Gradient's` into your Flutter projects:

### Usage

Import the package in your Dart file:

```dart
import 'package:mesh_gradient/mesh_gradient.dart';
```

To use the widget, add it to your widget tree like this:

### Animated Mesh Gradient

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

### MeshGradient

The `MeshGradient` widget allows you to create static mesh gradients with customizable points and options, which are blended together. Here's how you can use it in your project:

```dart
MeshGradient(
  points: [
    MeshGradientPoint(position: Offset(0.2, 0.3), color: Colors.red),
    MeshGradientPoint(position: Offset(0.4, 0.5), color: Colors.blue),
    MeshGradientPoint(position: Offset(0.6, 0.7), color: Colors.green),
    MeshGradientPoint(position: Offset(0.8, 0.9), color: Colors.yellow),
  ],
  options: MeshGradientOptions(blend: 3, noiseIntensity: 0.5),
)
```

### Options

## AnimatedMeshGradient

The `AnimatedMeshGradient` allows you to customize its appearance and behavior with the following options:

- `colors`: A list of four `Color` objects that define the gradient colors used in the animation.
- `speed`: The animation speed, controlling how fast the fluid effect moves. A higher value means faster animation.
- `frequency`: The frequency of the fluid wave. Higher values create more ripples.
- `amplitude`: The amplitude of the fluid wave. Higher values create more pronounced deformations.
- `seed`: A seed value that gives back a static snapshot of the animation. This stops the animation.

## MeshGradient

- `blend`: Defines the blending strength between the colors. Default is 3.
- `noiseIntensity`: Defines the intensity of the noise effect. Default is 0.5.

Feel free to experiment with different values to achieve the perfect look for your application!

## Credits

`Mesh Gradient` makes use of the following packages:

- [flutter_shaders](https://pub.dev/packages/flutter_shaders)

## Issues and Contributions

If you encounter any issues or have suggestions for improvements, please feel free to [open an issue](https://github.com/ben-fornefeld/mesh_gradient/issues). Contributions are also welcome!

## License

This package is licensed under the [MIT License](https://opensource.org/license/mit).
