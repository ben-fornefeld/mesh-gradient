# Animated Mesh Gradient

[![1.0.0](https://img.shields.io/pub/v/mesh_gradient_widget.svg)](https://pub.dev/packages/animated_mesh_gradient)

Animated Mesh Gradient is an eye-catching widget that renders an animated mesh gradient with a beautiful blurry effect between four user-defined colors. It can be used in Flutter applications to create stunning and dynamic user interfaces.

![Demo](https://github.com/ben-fornefeld/animated_mesh_gradient/blob/52762443a630b79c4eeae87839b94127418854c9/demo/demo-iphone.gif)

## Features

- `Fluid animation`: The widget animates smoothly between the four specified colors, creating a visually appealing fluid effect.
- `Customizable options`: Control the animation speed, frequency, and amplitude to achieve the desired visual effect.
- `Highly performant`: Built with Flutter CustomPainter and FragmentShader, the widget ensures optimal performance and smooth animation even on lower-end devices.
- `Easy integration`: Simply add the widget to your Flutter project and customize the colors and options to suit your application's design.

## Getting Started

Follow these steps to integrate the Animated Mesh Gradient into your Flutter project:

### Usage

Import the package in your Dart file:

```dart
import 'package:animated_mesh_gradient/animated_mesh_gradient.dart';
```

To use the widget, add it to your widget tree like this:

```dart
AnimatedMeshGradient(
  colors: [Colors.red, Colors.blue, Colors.green, Colors.yellow],
  options: AnimatedMeshGradientOptions(),
)
```

### Options

The `AnimatedMeshGradient` allows you to customize its appearance and behavior with the following options:

- `colors`: A list of four `Color` objects that define the gradient colors used in the animation.
- `speed`: The animation speed, controlling how fast the fluid effect moves. A higher value means faster animation.
- `frequency`: The frequency of the fluid wave. Higher values create more ripples.
- `amplitude`: The amplitude of the fluid wave. Higher values create more pronounced deformations.

Feel free to experiment with different values to achieve the perfect look for your application!

## Credits

The Animated Mesh Gradient makes use of the following packages:

- [flutter_shaders](https://pub.dev/packages/flutter_shaders)

## Issues and Contributions

If you encounter any issues or have suggestions for improvements, please feel free to [open an issue](https://github.com/ben-fornefeld/animated_mesh_gradient/issues). Contributions are also welcome!

## License

This package is licensed under the [MIT License](https://opensource.org/license/mit).
