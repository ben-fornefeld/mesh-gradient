# Mesh Gradient

A widget to create beatiful fluid-like mesh gradients in Flutter.

[![Pub Version](https://img.shields.io/badge/dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white)](https://pub.dev/packages/mesh_gradient)

![AnimatedMeshGradient Demo](example/demo/demo-animated.gif)

## Features

- `Fluid animation`: The widget animates smoothly between the four specified colors, creating a visually appealing fluid effect.
- `Customizable options`: Control the animation speed, frequency, and amplitude to achieve the desired visual effect.
- `Frozen mesh gradient`: Set a seed which gives back a static snapshot of the gradient animation.
- `Highly performant`: Built with Flutter CustomPainter and FragmentShader, the widget ensures optimal performance and smooth animation even on lower-end devices.
- `Easy integration`: Simply add the widget to your Flutter project and customize the colors and options to suit your application's design.

## Getting Started

Follow these steps to integrate `Mesh Gradient` into your Flutter project:

### Usage

Import the package in your Dart file:

```dart
import 'package:mesh_gradient/mesh_gradient.dart';
```

To use the widget, add it to your widget tree like this:

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

### Options

The `AnimatedMeshGradient` allows you to customize its appearance and behavior with the following options:

- `colors`: A list of four `Color` objects that define the gradient colors used in the animation.
- `speed`: The animation speed, controlling how fast the fluid effect moves. A higher value means faster animation.
- `frequency`: The frequency of the fluid wave. Higher values create more ripples.
- `amplitude`: The amplitude of the fluid wave. Higher values create more pronounced deformations.
- `seed`: A seed value that gives back a static snapshot of the animation. This stops the animation.

Feel free to experiment with different values to achieve the perfect look for your application!

## Credits

`Mesh Gradient` makes use of the following packages:

- [flutter_shaders](https://pub.dev/packages/flutter_shaders)

## Issues and Contributions

If you encounter any issues or have suggestions for improvements, please feel free to [open an issue](https://github.com/ben-fornefeld/mesh_gradient/issues). Contributions are also welcome!

## License

This package is licensed under the [MIT License](https://opensource.org/license/mit).
