import 'package:flutter_test/flutter_test.dart';
import 'package:abhay/features/algorithms/insertion_sort/insertion_sort_code.dart';
import 'package:abhay/features/algorithms/insertion_sort/insertion_sort_generator.dart';

void main() {
  final gen = InsertionSortGenerator();

  List<String> ops(List<int> input) =>
      gen.generate(input: input).steps.map((s) => s.operation).toList();

  test('reverse array: pick_key, compare, shift, insert ka pura pattern', () {
    expect(ops([3, 2, 1]), [
      'init',
      'pick_key', 'compare', 'shift', 'insert',
      'pick_key', 'compare', 'shift', 'compare', 'shift', 'insert',
      'done',
    ]);
  });

  test('already sorted: koi shift nahi, seedha insert', () {
    expect(ops([1, 2, 3]), [
      'init',
      'pick_key', 'compare', 'insert',
      'pick_key', 'compare', 'insert',
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

  test('do elements: ek shift ke baad sorted', () {
    final v = gen.generate(input: [2, 1]);
    expect(
      v.steps.map((s) => s.operation).toList(),
      ['init', 'pick_key', 'compare', 'shift', 'insert', 'done'],
    );
    expect(v.steps.last.state.array, [1, 2]);
  });

  test('init step: index 0 pehle se sorted (tick)', () {
    final v = gen.generate(input: [3, 2, 1]);
    expect(v.steps.first.operation, 'init');
    expect(v.steps.first.state.highlighted, [0]);
  });

  test('pick_key step: pointers I, J, KEY label aur active I', () {
    final v = gen.generate(input: [3, 2, 1]);
    final s = v.steps[1];
    expect(s.operation, 'pick_key');
    expect(s.state.array, [3, 2, 1]);
    expect(s.state.pointers, {'I': 1, 'J': 0});
    expect(s.state.labels, {1: 'KEY=2'});
    expect(s.highlights, [1]);
    expect(s.state.highlighted, [0]);
  });

  test('compare step: active sirf J, KEY label j+1 par', () {
    final v = gen.generate(input: [3, 2, 1]);
    final s = v.steps[2];
    expect(s.operation, 'compare');
    expect(s.state.pointers, {'I': 1, 'J': 0});
    expect(s.state.labels, {1: 'KEY=2'});
    expect(s.highlights, [0]);
  });

  test('shift step: array mein duplicate, KEY label khali jagah par', () {
    final v = gen.generate(input: [3, 2, 1]);
    final s = v.steps[3];
    expect(s.operation, 'shift');
    expect(s.state.array, [3, 3, 1]);
    expect(s.state.labels, {0: 'KEY=2'});
    expect(s.highlights, [0, 1]);
  });

  test('insert step: key sahi index par, 0..I tick', () {
    final v = gen.generate(input: [3, 2, 1]);
    final s = v.steps[4];
    expect(s.operation, 'insert');
    expect(s.state.array, [2, 3, 1]);
    expect(s.state.pointers, {'I': 1});
    expect(s.state.labels, {0: 'KEY=2'});
    expect(s.state.highlighted, [0, 1]);
    expect(s.highlights, [0]);
  });

  test('barabar elements: key aage nahi khisakti, stable rehta hai', () {
    final o = ops([2, 2, 1]);
    // Pehla round: 2 vs 2 barabar, shift nahi. Doosra round: 2 shifts.
    expect(o.where((x) => x == 'shift').length, 2);
    final v = gen.generate(input: [2, 2, 1]);
    expect(v.steps.last.state.array, [1, 2, 2]);
  });

  test('aakhri step par array sorted aur saare index tick', () {
    final v = gen.generate(input: [5, 2, 4, 6, 1]);
    final last = v.steps.last;
    expect(last.operation, 'done');
    expect(last.state.array, [1, 2, 4, 5, 6]);
    expect(last.state.highlighted, [0, 1, 2, 3, 4]);
  });

  test('input list badalti nahi', () {
    final input = [3, 2, 1];
    gen.generate(input: input);
    expect(input, [3, 2, 1]);
  });

  test('purane steps baad ke shifts se nahi badalte', () {
    final v = gen.generate(input: [3, 2, 1]);
    expect(v.initialState.array, [3, 2, 1]);
    expect(v.steps[1].state.array, [3, 2, 1]);
    expect(v.steps[3].state.array, [3, 3, 1]);
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
    final v = gen.generate(input: [5, 2, 4, 6, 1]);
    final max = insertionSortCodeLines.length - 1;
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