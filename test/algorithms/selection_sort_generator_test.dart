import 'package:flutter_test/flutter_test.dart';
import 'package:abhay/features/algorithms/selection_sort/selection_sort_code.dart';
import 'package:abhay/features/algorithms/selection_sort/selection_sort_generator.dart';

void main() {
  final gen = SelectionSortGenerator();

  List<String> ops(List<int> input) =>
      gen.generate(input: input).steps.map((s) => s.operation).toList();

  test('reverse array: new_min aur swap ka pura pattern', () {
    expect(ops([3, 2, 1]), [
      'init',
      'compare', 'new_min',
      'compare', 'new_min',
      'swap',
      'compare',
      'no_swap',
      'done',
    ]);
  });

  test('already sorted: sirf no_swap, koi new_min nahi', () {
    expect(ops([1, 2, 3]), [
      'init',
      'compare', 'compare',
      'no_swap',
      'compare',
      'no_swap',
      'done',
    ]);
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

  test('do elements: swap ke baad sorted', () {
    final v = gen.generate(input: [2, 1]);
    expect(
      v.steps.map((s) => s.operation).toList(),
      ['init', 'compare', 'new_min', 'swap', 'done'],
    );
    expect(v.steps.last.state.array, [1, 2]);
  });

  test('swap step: array badla, pointers I aur MIN, tick pehle index par', () {
    final v = gen.generate(input: [3, 2, 1]);
    final s = v.steps[5];
    expect(s.operation, 'swap');
    expect(s.state.array, [1, 2, 3]);
    expect(s.state.pointers, {'I': 0, 'MIN': 2});
    expect(s.highlights, [0, 2]);
    expect(s.state.highlighted, [0]);
  });

  test('compare step: pointers I, J, MIN aur active J, MIN', () {
    final v = gen.generate(input: [3, 2, 1]);
    final s = v.steps[1];
    expect(s.operation, 'compare');
    expect(s.state.pointers, {'I': 0, 'J': 1, 'MIN': 0});
    expect(s.highlights, [1, 0]);
  });

  test('new_min step par MIN naye index par aa jata hai', () {
    final v = gen.generate(input: [3, 2, 1]);
    final s = v.steps[2];
    expect(s.operation, 'new_min');
    expect(s.state.pointers, {'I': 0, 'J': 1, 'MIN': 1});
  });

  test('barabar elements par new_min nahi aata', () {
    final o = ops([2, 2, 2]);
    expect(o.contains('new_min'), isFalse);
    expect(o.last, 'done');
  });

  test('aakhri step par array sorted aur saare index tick', () {
    final v = gen.generate(input: [64, 25, 12, 22, 11]);
    final last = v.steps.last;
    expect(last.operation, 'done');
    expect(last.state.array, [11, 12, 22, 25, 64]);
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
    final v = gen.generate(input: [64, 25, 12, 22, 11]);
    final max = selectionSortCodeLines.length - 1;
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