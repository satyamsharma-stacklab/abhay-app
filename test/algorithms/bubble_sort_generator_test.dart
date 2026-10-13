import 'package:flutter_test/flutter_test.dart';
import 'package:abhay/features/algorithms/bubble_sort/bubble_sort_code.dart';
import 'package:abhay/features/algorithms/bubble_sort/bubble_sort_generator.dart';

void main() {
  final gen = BubbleSortGenerator();

  List<String> ops(List<int> input) =>
      gen.generate(input: input).steps.map((s) => s.operation).toList();

  test('reverse array: compare/swap/pass_done ka pura pattern', () {
    expect(ops([3, 2, 1]), [
      'init',
      'compare', 'swap',
      'compare', 'swap',
      'pass_done',
      'compare', 'swap',
      'done',
    ]);
  });

  test('already sorted: ek pass ke baad early exit', () {
    expect(ops([1, 2, 3]), [
      'init',
      'compare', 'no_swap',
      'compare', 'no_swap',
      'done',
    ]);
  });

  test('nearly sorted: doosre pass mein early exit', () {
    final v = gen.generate(input: [2, 1, 3, 4]);
    final o = v.steps.map((s) => s.operation).toList();
    expect(o.where((x) => x == 'compare').length, 5);
    expect(o.where((x) => x == 'pass_done').length, 1);
    expect(o.last, 'done');
    expect(v.steps.last.codeLine, 8);
  });

  test('single element par sirf done, tick ke saath', () {
    final v = gen.generate(input: [5]);
    expect(v.steps.length, 1);
    expect(v.steps.first.operation, 'done');
    expect(v.steps.first.state.highlighted, [0]);
  });

  test('khali array par sirf done', () {
    final v = gen.generate(input: []);
    expect(v.steps.length, 1);
    expect(v.steps.first.operation, 'done');
    expect(v.steps.first.state.highlighted, isEmpty);
  });

  test('barabar elements par swap nahi hota', () {
    final v = gen.generate(input: [2, 2, 1]);
    expect(v.steps[2].operation, 'no_swap');
    expect(v.steps.last.state.array, [1, 2, 2]);
  });

  test('swap step: array badla hua, pointers J aur J+1', () {
    final v = gen.generate(input: [3, 2, 1]);
    final s = v.steps[2];
    expect(s.operation, 'swap');
    expect(s.state.array, [2, 3, 1]);
    expect(s.state.pointers, {'J': 0, 'J+1': 1});
    expect(s.highlights, [0, 1]);
  });

  test('pehle pass ke baad aakhri index sorted (tick) hai', () {
    final v = gen.generate(input: [3, 2, 1]);
    final s = v.steps[5];
    expect(s.operation, 'pass_done');
    expect(s.state.highlighted, [2]);
    expect(s.state.array, [2, 1, 3]);
  });

  test('aakhri step par array sorted aur saare index tick', () {
    final v = gen.generate(input: [5, 1, 4, 2, 8]);
    final last = v.steps.last;
    expect(last.operation, 'done');
    expect(last.state.array, [1, 2, 4, 5, 8]);
    expect(last.state.highlighted, [0, 1, 2, 3, 4]);
  });

  test('input list badalti nahi', () {
    final input = [3, 2, 1];
    gen.generate(input: input);
    expect(input, [3, 2, 1]);
  });

  test('purane steps baad ke swaps se nahi badalte', () {
    final v = gen.generate(input: [3, 2, 1]);
    expect(v.initialState.array, [3, 2, 1]);
    expect(v.steps[1].operation, 'compare');
    expect(v.steps[1].state.array, [3, 2, 1]);
    expect(v.steps.last.state.array, [1, 2, 3]);
  });

  test('deterministic: same input same steps', () {
    final a = gen.generate(input: [4, 3, 2, 1]);
    final b = gen.generate(input: [4, 3, 2, 1]);
    expect(a.steps.length, b.steps.length);
    for (var i = 0; i < a.steps.length; i++) {
      expect(a.steps[i].operation, b.steps[i].operation);
      expect(a.steps[i].explanationHinglish, b.steps[i].explanationHinglish);
      expect(a.steps[i].state.array, b.steps[i].state.array);
    }
  });

  test('step index 0 se lagataar badhta hai', () {
    final v = gen.generate(input: [4, 3, 2, 1]);
    for (var i = 0; i < v.steps.length; i++) {
      expect(v.steps[i].index, i);
    }
  });

  test('har step ki codeLine code lines ke andar hai', () {
    final v = gen.generate(input: [4, 3, 2, 1]);
    final max = bubbleSortCodeLines.length - 1;
    for (final s in v.steps) {
      expect(s.codeLine, isNotNull);
      expect(s.codeLine!, inInclusiveRange(0, max));
    }
  });

  test('checkpoint ka sahi jawab pehla option hai', () {
    final v = gen.generate(input: [3, 2, 1]);
    expect(v.checkpoint.isCorrect(0), isTrue);
    expect(v.checkpoint.isCorrect(1), isFalse);
  });

  test('complexity O(n^2) aur O(1) hai', () {
    final v = gen.generate(input: [3, 2, 1]);
    expect(v.complexity.time, 'O(n^2)');
    expect(v.complexity.space, 'O(1)');
  });
}