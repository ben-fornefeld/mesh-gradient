import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mesh_gradient/mesh_gradient.dart';

void main() {
  group('MeshGradient', () {
    testWidgets('renders without error', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MeshGradient(
              points: [
                MeshGradientPoint(
                  position: const Offset(0.2, 0.6),
                  color: Colors.red,
                ),
                MeshGradientPoint(
                  position: const Offset(0.4, 0.5),
                  color: Colors.blue,
                ),
                MeshGradientPoint(
                  position: const Offset(0.7, 0.4),
                  color: Colors.green,
                ),
                MeshGradientPoint(
                  position: const Offset(0.4, 0.9),
                  color: Colors.yellow,
                ),
              ],
              options: MeshGradientOptions(),
            ),
          ),
        ),
      );

      expect(find.byType(MeshGradient), findsOneWidget);
    });

    test('MeshGradientPoint creates with correct values', () {
      final point = MeshGradientPoint(
        position: const Offset(0.5, 0.5),
        color: Colors.red,
      );

      expect(point.position, const Offset(0.5, 0.5));
      expect(point.color, Colors.red);
    });
  });

  group('AnimatedMeshGradient', () {
    test('AnimatedMeshGradientOptions creates with defaults', () {
      final options = AnimatedMeshGradientOptions();

      expect(options.speed, isNotNull);
      expect(options.frequency, isNotNull);
      expect(options.amplitude, isNotNull);
    });
  });
}
