import 'package:flutter_test/flutter_test.dart';
import 'package:abhay/features/visualization/engine/checkpoint.dart';

void main() {
  const checkpoint = Checkpoint(
    question: 'Binary Search ke liye array kaisa hona chahiye?',
    options: ['Unsorted', 'Sorted', 'Sirf negative', 'Khali'],
    correctIndex: 1,
    explanationHinglish: 'Binary Search sirf sorted array par chalta hai.',
  );

  test('sahi option par true deta hai', () {
    expect(checkpoint.isCorrect(1), isTrue);
  });

  test('galat option par false deta hai', () {
    expect(checkpoint.isCorrect(0), isFalse);
    expect(checkpoint.isCorrect(3), isFalse);
  });

  test('range se bahar index par false deta hai', () {
    expect(checkpoint.isCorrect(-1), isFalse);
    expect(checkpoint.isCorrect(99), isFalse);
  });
}