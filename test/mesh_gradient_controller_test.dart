import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mesh_gradient/mesh_gradient.dart';

void main() {
  group('MeshGradientController', () {
    late MeshGradientController controller;
    late List<MeshGradientPoint> initialPoints;

    setUp(() {
      initialPoints = [
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
      ];
    });

    tearDown(() {
      if (!controller.isDisposed()) {
        controller.dispose();
      }
    });

    testWidgets('initializes with correct points', (WidgetTester tester) async {
      controller = MeshGradientController(
        points: initialPoints,
        vsync: tester,
      );

      expect(controller.points.value, equals(initialPoints));
      expect(controller.isAnimating.value, isFalse);
      expect(controller.isDisposed(), isFalse);
    });

    group('disposal', () {
      testWidgets('isDisposed returns false initially',
          (WidgetTester tester) async {
        controller = MeshGradientController(
          points: initialPoints,
          vsync: tester,
        );

        expect(controller.isDisposed(), isFalse);
      });

      testWidgets('isDisposed returns true after disposal',
          (WidgetTester tester) async {
        controller = MeshGradientController(
          points: initialPoints,
          vsync: tester,
        );

        controller.dispose();

        expect(controller.isDisposed(), isTrue);
      });

      testWidgets('dispose can be called multiple times safely',
          (WidgetTester tester) async {
        controller = MeshGradientController(
          points: initialPoints,
          vsync: tester,
        );

        controller.dispose();
        controller.dispose();
        controller.dispose();

        expect(controller.isDisposed(), isTrue);
      });

      testWidgets('animatePoint throws StateError after disposal',
          (WidgetTester tester) async {
        controller = MeshGradientController(
          points: initialPoints,
          vsync: tester,
        );

        controller.dispose();

        expect(
          () => controller.animatePoint(
            0,
            MeshGradientPoint(
              position: const Offset(0.5, 0.5),
              color: Colors.purple,
            ),
          ),
          throwsA(isA<StateError>()),
        );
      });

      testWidgets('animateSequence throws StateError after disposal',
          (WidgetTester tester) async {
        controller = MeshGradientController(
          points: initialPoints,
          vsync: tester,
        );

        controller.dispose();

        expect(
          () => controller.animateSequence(
            duration: const Duration(milliseconds: 100),
            sequences: [
              AnimationSequence(
                pointIndex: 0,
                newPoint: MeshGradientPoint(
                  position: const Offset(0.5, 0.5),
                  color: Colors.purple,
                ),
                interval: const Interval(0.0, 1.0),
              ),
            ],
          ),
          throwsA(isA<StateError>()),
        );
      });

      testWidgets('dispose stops all active animations',
          (WidgetTester tester) async {
        controller = MeshGradientController(
          points: initialPoints,
          vsync: tester,
        );

        // start animation
        controller.animatePoint(
          0,
          MeshGradientPoint(
            position: const Offset(0.8, 0.8),
            color: Colors.purple,
          ),
          duration: const Duration(milliseconds: 500),
        );

        await tester.pump(const Duration(milliseconds: 50));
        expect(controller.isAnimating.value, isTrue);

        controller.dispose();

        expect(controller.isAnimating.value, isFalse);
        expect(controller.isDisposed(), isTrue);
      });
    });

    group('animatePoint', () {
      testWidgets('animates single point position and color',
          (WidgetTester tester) async {
        controller = MeshGradientController(
          points: initialPoints,
          vsync: tester,
        );

        final targetPoint = MeshGradientPoint(
          position: const Offset(0.8, 0.8),
          color: Colors.purple,
        );

        controller.animatePoint(
          0,
          targetPoint,
          duration: const Duration(milliseconds: 100),
        );

        await tester.pump();
        expect(controller.isAnimating.value, isTrue);

        await tester.pump(const Duration(milliseconds: 50));
        // point should be somewhere between start and end
        final midPoint = controller.points.value[0];
        expect(
            midPoint.position.dx, isNot(equals(initialPoints[0].position.dx)));
        expect(midPoint.position.dx, isNot(equals(targetPoint.position.dx)));

        await tester.pumpAndSettle();
        expect(controller.isAnimating.value, isFalse);
        expect(
            controller.points.value[0].position, equals(targetPoint.position));
        expect(controller.points.value[0].color, equals(targetPoint.color));
      });

      testWidgets('throws ArgumentError for invalid index',
          (WidgetTester tester) async {
        controller = MeshGradientController(
          points: initialPoints,
          vsync: tester,
        );

        expect(
          () => controller.animatePoint(
            10,
            MeshGradientPoint(
              position: const Offset(0.5, 0.5),
              color: Colors.purple,
            ),
          ),
          throwsA(isA<ArgumentError>()),
        );
      });

      testWidgets('completes animation future', (WidgetTester tester) async {
        controller = MeshGradientController(
          points: initialPoints,
          vsync: tester,
        );

        var completed = false;

        controller
            .animatePoint(
          0,
          MeshGradientPoint(
            position: const Offset(0.8, 0.8),
            color: Colors.purple,
          ),
          duration: const Duration(milliseconds: 100),
        )
            .then((_) {
          completed = true;
        });

        expect(completed, isFalse);
        await tester.pumpAndSettle();
        expect(completed, isTrue);
      });
    });

    group('stopAllAnimations', () {
      testWidgets('stops all active animations', (WidgetTester tester) async {
        controller = MeshGradientController(
          points: initialPoints,
          vsync: tester,
        );

        // start multiple animations
        controller.animatePoint(
          0,
          MeshGradientPoint(
            position: const Offset(0.8, 0.8),
            color: Colors.purple,
          ),
          duration: const Duration(milliseconds: 500),
        );

        controller.animatePoint(
          1,
          MeshGradientPoint(
            position: const Offset(0.9, 0.9),
            color: Colors.orange,
          ),
          duration: const Duration(milliseconds: 500),
        );

        await tester.pump(const Duration(milliseconds: 50));
        expect(controller.isAnimating.value, isTrue);

        controller.stopAllAnimations();

        expect(controller.isAnimating.value, isFalse);
      });

      testWidgets('can be called when no animations are active',
          (WidgetTester tester) async {
        controller = MeshGradientController(
          points: initialPoints,
          vsync: tester,
        );

        expect(() => controller.stopAllAnimations(), returnsNormally);
        expect(controller.isAnimating.value, isFalse);
      });
    });

    group('animateSequence', () {
      testWidgets('animates multiple points in sequence',
          (WidgetTester tester) async {
        controller = MeshGradientController(
          points: initialPoints,
          vsync: tester,
        );

        controller.animateSequence(
          duration: const Duration(milliseconds: 200),
          sequences: [
            AnimationSequence(
              pointIndex: 0,
              newPoint: MeshGradientPoint(
                position: const Offset(0.8, 0.8),
                color: Colors.purple,
              ),
              interval: const Interval(0.0, 0.5, curve: Curves.easeIn),
            ),
            AnimationSequence(
              pointIndex: 1,
              newPoint: MeshGradientPoint(
                position: const Offset(0.9, 0.9),
                color: Colors.orange,
              ),
              interval: const Interval(0.5, 1.0, curve: Curves.easeOut),
            ),
          ],
        );

        await tester.pump();
        expect(controller.isAnimating.value, isTrue);

        await tester.pumpAndSettle();
        expect(controller.isAnimating.value, isFalse);
        expect(controller.points.value[0].position, const Offset(0.8, 0.8));
        expect(controller.points.value[1].position, const Offset(0.9, 0.9));
      });

      testWidgets('throws ArgumentError for duplicate sequence indices',
          (WidgetTester tester) async {
        controller = MeshGradientController(
          points: initialPoints,
          vsync: tester,
        );

        expect(
          () => controller.animateSequence(
            duration: const Duration(milliseconds: 100),
            sequences: [
              AnimationSequence(
                pointIndex: 0,
                newPoint: MeshGradientPoint(
                  position: const Offset(0.8, 0.8),
                  color: Colors.purple,
                ),
                interval: const Interval(0.0, 0.5),
              ),
              AnimationSequence(
                pointIndex: 0,
                newPoint: MeshGradientPoint(
                  position: const Offset(0.9, 0.9),
                  color: Colors.orange,
                ),
                interval: const Interval(0.5, 1.0),
              ),
            ],
          ),
          throwsA(isA<ArgumentError>()),
        );
      });

      testWidgets('repeats sequence specified number of times',
          (WidgetTester tester) async {
        controller = MeshGradientController(
          points: initialPoints,
          vsync: tester,
        );

        var animationCount = 0;

        controller
            .animateSequence(
          duration: const Duration(milliseconds: 50),
          sequences: [
            AnimationSequence(
              pointIndex: 0,
              newPoint: MeshGradientPoint(
                position: const Offset(0.8, 0.8),
                color: Colors.purple,
              ),
              interval: const Interval(0.0, 1.0),
            ),
          ],
          repeatCount: 3,
        )
            .then((_) {
          animationCount++;
        });

        await tester.pump();
        expect(controller.isAnimating.value, isTrue);

        await tester.pumpAndSettle();
        expect(controller.isAnimating.value, isFalse);
        expect(animationCount, 1);
      });
    });

    group('repeatAnimation', () {
      testWidgets('repeats animation specified number of times',
          (WidgetTester tester) async {
        controller = MeshGradientController(
          points: initialPoints,
          vsync: tester,
        );

        var executionCount = 0;

        Future<void> testAnimation() async {
          executionCount++;
          await Future.delayed(const Duration(milliseconds: 10));
        }

        controller.repeatAnimation(
          animation: testAnimation,
          repeatCount: 3,
        );

        await tester.pumpAndSettle();
        expect(executionCount, 3);
      });
    });

    group('repeatPointAnimation', () {
      testWidgets('repeats point animation specified number of times',
          (WidgetTester tester) async {
        controller = MeshGradientController(
          points: initialPoints,
          vsync: tester,
        );

        controller.repeatPointAnimation(
          0,
          MeshGradientPoint(
            position: const Offset(0.8, 0.8),
            color: Colors.purple,
          ),
          duration: const Duration(milliseconds: 50),
          repeatCount: 3,
        );

        await tester.pump();
        expect(controller.isAnimating.value, isTrue);

        await tester.pumpAndSettle();
        expect(controller.isAnimating.value, isFalse);
        expect(controller.points.value[0].position, const Offset(0.8, 0.8));
      });
    });

    group('isAnimating', () {
      testWidgets('is false initially', (WidgetTester tester) async {
        controller = MeshGradientController(
          points: initialPoints,
          vsync: tester,
        );

        expect(controller.isAnimating.value, isFalse);
      });

      testWidgets('is true during animation', (WidgetTester tester) async {
        controller = MeshGradientController(
          points: initialPoints,
          vsync: tester,
        );

        controller.animatePoint(
          0,
          MeshGradientPoint(
            position: const Offset(0.8, 0.8),
            color: Colors.purple,
          ),
          duration: const Duration(milliseconds: 100),
        );

        await tester.pump();
        expect(controller.isAnimating.value, isTrue);

        // cleanup: let animation complete
        await tester.pumpAndSettle();
      });

      testWidgets('is false after animation completes',
          (WidgetTester tester) async {
        controller = MeshGradientController(
          points: initialPoints,
          vsync: tester,
        );

        controller.animatePoint(
          0,
          MeshGradientPoint(
            position: const Offset(0.8, 0.8),
            color: Colors.purple,
          ),
          duration: const Duration(milliseconds: 100),
        );

        await tester.pumpAndSettle();
        expect(controller.isAnimating.value, isFalse);
      });

      testWidgets('tracks multiple concurrent animations',
          (WidgetTester tester) async {
        controller = MeshGradientController(
          points: initialPoints,
          vsync: tester,
        );

        controller.animatePoint(
          0,
          MeshGradientPoint(
            position: const Offset(0.8, 0.8),
            color: Colors.purple,
          ),
          duration: const Duration(milliseconds: 200),
        );

        controller.animatePoint(
          1,
          MeshGradientPoint(
            position: const Offset(0.9, 0.9),
            color: Colors.orange,
          ),
          duration: const Duration(milliseconds: 200),
        );

        await tester.pump();
        expect(controller.isAnimating.value, isTrue);

        await tester.pump(const Duration(milliseconds: 100));
        expect(controller.isAnimating.value, isTrue);

        await tester.pumpAndSettle();
        expect(controller.isAnimating.value, isFalse);
      });
    });

    group('AnimationSequence', () {
      test('creates with correct values', () {
        final sequence = AnimationSequence(
          pointIndex: 0,
          newPoint: MeshGradientPoint(
            position: const Offset(0.5, 0.5),
            color: Colors.red,
          ),
          interval: const Interval(0.0, 1.0),
        );

        expect(sequence.pointIndex, 0);
        expect(sequence.newPoint.position, const Offset(0.5, 0.5));
        expect(sequence.newPoint.color, Colors.red);
        expect(sequence.interval.begin, 0.0);
        expect(sequence.interval.end, 1.0);
      });
    });
  });
}
