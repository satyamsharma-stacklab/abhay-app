import 'package:flutter_test/flutter_test.dart';
import 'package:abhay/features/visualization/engine/algorithm_generator.dart';
import 'package:abhay/features/visualization/engine/checkpoint.dart';
import 'package:abhay/features/visualization/engine/visualization.dart';
import 'package:abhay/features/visualization/engine/visualization_controller.dart';
import 'package:abhay/features/visualization/engine/visualization_state.dart';
import 'package:abhay/features/visualization/engine/visualization_step.dart';

/// Sirf test ke liye: har input element ke liye ek step banata hai.
class FakeGenerator implements AlgorithmGenerator {
  @override
  String get algorithmId => 'fake';

  @override
  String get title => 'Fake';

  @override
  Visualization generate({required List<int> input, int? target}) {
    final initial = VisualizationState(array: input);
    final steps = <VisualizationStep>[
      for (var i = 0; i < input.length; i++)
        VisualizationStep(
          index: i,
          state: initial.copyWith(pointers: {'I': i}),
          operation: 'visit',
          explanationHinglish: 'Index $i dekha',
          codeLine: i,
          highlights: [i],
          durationMs: 100,
        ),
    ];
    return Visualization(
      id: 'fake_viz',
      algorithmId: algorithmId,
      title: title,
      initialState: initial,
      steps: steps,
      checkpoint: const Checkpoint(
        question: 'Q?',
        options: ['A', 'B'],
        correctIndex: 0,
        explanationHinglish: 'A sahi hai',
      ),
      complexity: const Complexity(time: 'O(n)', space: 'O(1)'),
    );
  }
}

VisualizationController makeController(List<int> input) {
  return VisualizationController(FakeGenerator().generate(input: input));
}

void main() {
  group('shuruaat', () {
    test('start par koi step nahi, isAtStart true', () {
      final c = makeController([1, 2, 3]);
      expect(c.currentIndex, -1);
      expect(c.currentStep, isNull);
      expect(c.isAtStart, isTrue);
      expect(c.isFinished, isFalse);
      expect(c.isPlaying, isFalse);
      c.dispose();
    });

    test('generator deterministic hai: same input, same steps', () {
      final a = FakeGenerator().generate(input: [5, 6, 7]);
      final b = FakeGenerator().generate(input: [5, 6, 7]);
      expect(a.steps.length, b.steps.length);
      for (var i = 0; i < a.steps.length; i++) {
        expect(
          a.steps[i].explanationHinglish,
          b.steps[i].explanationHinglish,
        );
        expect(a.steps[i].state.pointers, b.steps[i].state.pointers);
      }
    });
  });

  group('next / previous bounds', () {
    test('next ek-ek step aage badhata hai', () {
      final c = makeController([1, 2, 3]);
      c.next();
      expect(c.currentIndex, 0);
      c.next();
      expect(c.currentIndex, 1);
      c.dispose();
    });

    test('next aakhri step ke baad aage nahi jata', () {
      final c = makeController([1, 2, 3]);
      for (var i = 0; i < 10; i++) {
        c.next();
      }
      expect(c.currentIndex, 2);
      expect(c.isFinished, isTrue);
      c.dispose();
    });

    test('previous shuru se peeche nahi jata', () {
      final c = makeController([1, 2, 3]);
      c.previous();
      c.previous();
      expect(c.currentIndex, -1);
      c.dispose();
    });

    test('previous ek step peeche laata hai', () {
      final c = makeController([1, 2, 3]);
      c.next();
      c.next();
      c.previous();
      expect(c.currentIndex, 0);
      c.dispose();
    });
  });

  group('restart aur finish', () {
    test('restart wapas shuru par le jata hai', () {
      final c = makeController([1, 2, 3]);
      c.next();
      c.next();
      c.restart();
      expect(c.currentIndex, -1);
      expect(c.isFinished, isFalse);
      c.dispose();
    });

    test('khali steps par isFinished true aur next crash nahi karta', () {
      final c = makeController([]);
      expect(c.isFinished, isTrue);
      c.next();
      c.play();
      expect(c.currentIndex, -1);
      expect(c.isPlaying, isFalse);
      c.dispose();
    });
  });

  group('speed', () {
    test('speed limits ke andar rehti hai', () {
      final c = makeController([1, 2]);
      c.setSpeed(100);
      expect(c.speed, VisualizationController.maxSpeed);
      c.setSpeed(0);
      expect(c.speed, VisualizationController.minSpeed);
      c.setSpeed(2);
      expect(c.speed, 2.0);
      c.dispose();
    });
  });

  group('onChanged', () {
    test('next par listener call hota hai', () {
      final c = makeController([1, 2]);
      var calls = 0;
      c.onChanged = () => calls++;
      c.next();
      expect(calls, 1);
      c.dispose();
    });
  });

  group('play / pause', () {
    test('play auto-advance karta hai aur aakhir par ruk jata hai', () async {
      final c = makeController([1, 2, 3]);
      c.setSpeed(4.0);
      c.play();
      expect(c.isPlaying, isTrue);
      await Future<void>.delayed(const Duration(milliseconds: 400));
      expect(c.isFinished, isTrue);
      expect(c.currentIndex, 2);
      expect(c.isPlaying, isFalse);
      c.dispose();
    });

    test('pause auto-play rok deta hai', () async {
      final c = makeController([1, 2, 3, 4, 5]);
      c.setSpeed(1.0);
      c.play();
      await Future<void>.delayed(const Duration(milliseconds: 130));
      c.pause();
      final stoppedAt = c.currentIndex;
      expect(c.isPlaying, isFalse);
      await Future<void>.delayed(const Duration(milliseconds: 300));
      expect(c.currentIndex, stoppedAt);
      c.dispose();
    });

    test('finish ke baad play dobara shuru se chalata hai', () {
      final c = makeController([1, 2]);
      c.next();
      c.next();
      expect(c.isFinished, isTrue);
      c.play();
      expect(c.currentIndex, -1);
      expect(c.isPlaying, isTrue);
      c.dispose();
    });
  });
}