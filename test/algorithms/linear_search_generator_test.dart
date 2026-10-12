import 'package:flutter_test/flutter_test.dart';
import 'package:abhay/features/algorithms/linear_search/linear_search_generator.dart';
import 'package:abhay/features/algorithms/linear_search/linear_search_code.dart';

void main() {
  final gen = LinearSearchGenerator();
  // Unsorted array: Linear Search ko sorted hona zaroori nahi.
  const arr = [7, 3, 9, 1, 5];

  test('target mil jaye to aakhri step found hai', () {
    final v = gen.generate(input: arr, target: 9);
    final last = v.steps.last;
    expect(last.operation, 'found');
    expect(last.state.highlighted, [2]);
    expect(last.state.labels[2], 'FOUND');
    expect(last.state.pointers, {'I': 2});
  });

  test('target nahi mile to aakhri step not_found hai', () {
    final v = gen.generate(input: arr, target: 100);
    expect(v.steps.last.operation, 'not_found');
    expect(v.steps.any((s) => s.operation == 'found'), isFalse);
  });

  test('pehla step check hai aur I = 0 hai', () {
    final v = gen.generate(input: arr, target: 9);
    expect(v.steps.first.operation, 'check');
    expect(v.steps.first.state.pointers, {'I': 0});
  });

  test('pehle element par mil jaye to sirf check aur found', () {
    final v = gen.generate(input: arr, target: 7);
    expect(v.steps.map((s) => s.operation).toList(), ['check', 'found']);
  });

  test('beech mein mile to check-next ka pattern chalta hai', () {
    final v = gen.generate(input: arr, target: 9);
    expect(
      v.steps.map((s) => s.operation).toList(),
      ['check', 'next', 'check', 'next', 'check', 'found'],
    );
  });

  test('aakhri element par mile to found, next nahi', () {
    final v = gen.generate(input: arr, target: 5);
    expect(v.steps.last.operation, 'found');
    expect(v.steps.last.state.pointers, {'I': 4});
  });

  test('na mile to aakhri element ke baad next step nahi', () {
    final v = gen.generate(input: arr, target: 100);
    final ops = v.steps.map((s) => s.operation).toList();
    // 5 check + 4 next + 1 not_found = 10 steps
    expect(v.steps.length, 10);
    expect(ops[ops.length - 2], 'check');
    expect(ops.last, 'not_found');
  });

  test('duplicate ho to pehla match milta hai', () {
    final v = gen.generate(input: [4, 8, 4, 4], target: 4);
    expect(v.steps.last.operation, 'found');
    expect(v.steps.last.state.highlighted, [0]);
  });

  test('single element mil jata hai', () {
    final v = gen.generate(input: [9], target: 9);
    expect(v.steps.last.operation, 'found');
  });

  test('single element na mile to not_found', () {
    final v = gen.generate(input: [9], target: 4);
    expect(v.steps.map((s) => s.operation).toList(), ['check', 'not_found']);
  });

  test('khali array par sirf not_found step', () {
    final v = gen.generate(input: [], target: 1);
    expect(v.steps.length, 1);
    expect(v.steps.first.operation, 'not_found');
  });

  test('deterministic: same input same steps', () {
    final a = gen.generate(input: arr, target: 1);
    final b = gen.generate(input: arr, target: 1);
    expect(a.steps.length, b.steps.length);
    for (var i = 0; i < a.steps.length; i++) {
      expect(a.steps[i].explanationHinglish, b.steps[i].explanationHinglish);
      expect(a.steps[i].state.pointers, b.steps[i].state.pointers);
    }
  });

  test('step index 0 se lagataar badhta hai', () {
    final v = gen.generate(input: arr, target: 5);
    for (var i = 0; i < v.steps.length; i++) {
      expect(v.steps[i].index, i);
    }
  });

  test('har step ki codeLine code lines ke andar hai', () {
    final v = gen.generate(input: arr, target: 100);
    for (final s in v.steps) {
      expect(s.codeLine, isNotNull);
      expect(s.codeLine!, inInclusiveRange(0, linearSearchCodeLines.length - 1));
    }
  });

  test('checkpoint ka sahi jawab pehla option hai', () {
    final v = gen.generate(input: arr, target: 5);
    expect(v.checkpoint.isCorrect(0), isTrue);
    expect(v.checkpoint.isCorrect(1), isFalse);
  });

  test('complexity O(n) aur O(1) hai', () {
    final v = gen.generate(input: arr, target: 5);
    expect(v.complexity.time, 'O(n)');
    expect(v.complexity.space, 'O(1)');
  });
}