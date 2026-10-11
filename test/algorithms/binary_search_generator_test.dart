import 'package:flutter_test/flutter_test.dart';
import 'package:abhay/features/algorithms/binary_search/binary_search_generator.dart';

void main() {
  final gen = BinarySearchGenerator();
  const arr = [2, 5, 8, 12, 16, 23, 38];

  test('target mil jaye to aakhri step found hai', () {
    final v = gen.generate(input: arr, target: 23);
    final last = v.steps.last;
    expect(last.operation, 'found');
    expect(last.state.highlighted, [5]);
    expect(last.state.labels[5], 'FOUND');
  });

  test('target nahi mile to aakhri step not_found hai', () {
    final v = gen.generate(input: arr, target: 7);
    expect(v.steps.last.operation, 'not_found');
    expect(v.steps.any((s) => s.operation == 'found'), isFalse);
  });

  test('pehla step init hai aur LOW/HIGH sahi hain', () {
    final v = gen.generate(input: arr, target: 23);
    expect(v.steps.first.operation, 'init');
    expect(v.steps.first.state.pointers, {'LOW': 0, 'HIGH': 6});
  });

  test('pehla MID middle index hai', () {
    final v = gen.generate(input: arr, target: 23);
    expect(v.steps[1].operation, 'mid');
    expect(v.steps[1].state.pointers['MID'], 3);
  });

  test('single element mil jata hai', () {
    final v = gen.generate(input: [9], target: 9);
    expect(v.steps.last.operation, 'found');
  });

  test('single element na mile to not_found', () {
    final v = gen.generate(input: [9], target: 4);
    expect(v.steps.last.operation, 'not_found');
  });

  test('khali array par sirf not_found step', () {
    final v = gen.generate(input: [], target: 1);
    expect(v.steps.length, 1);
    expect(v.steps.first.operation, 'not_found');
  });

  test('deterministic: same input same steps', () {
    final a = gen.generate(input: arr, target: 12);
    final b = gen.generate(input: arr, target: 12);
    expect(a.steps.length, b.steps.length);
    for (var i = 0; i < a.steps.length; i++) {
      expect(a.steps[i].explanationHinglish, b.steps[i].explanationHinglish);
      expect(a.steps[i].state.pointers, b.steps[i].state.pointers);
    }
  });

  test('step index 0 se lagataar badhta hai', () {
    final v = gen.generate(input: arr, target: 38);
    for (var i = 0; i < v.steps.length; i++) {
      expect(v.steps[i].index, i);
    }
  });

  test('checkpoint ka sahi jawab pehla option hai', () {
    final v = gen.generate(input: arr, target: 5);
    expect(v.checkpoint.isCorrect(0), isTrue);
    expect(v.checkpoint.isCorrect(1), isFalse);
  });
}