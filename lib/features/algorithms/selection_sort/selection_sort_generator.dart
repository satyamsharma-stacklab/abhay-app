import '../../visualization/engine/algorithm_generator.dart';
import '../../visualization/engine/checkpoint.dart';
import '../../visualization/engine/visualization.dart';
import '../../visualization/engine/visualization_state.dart';
import '../../visualization/engine/visualization_step.dart';

/// Selection Sort ke steps banata hai. `target` ignore hota hai.
/// Same input -> hamesha same steps. Koi random ya time use nahi.
class SelectionSortGenerator implements AlgorithmGenerator {
  @override
  String get algorithmId => 'selection_sort';

  @override
  String get title => 'Selection Sort';

  @override
  Visualization generate({required List<int> input, int? target}) {
    final a = List<int>.of(input);
    final n = a.length;
    final initial = VisualizationState(array: List<int>.of(a));
    final steps = <VisualizationStep>[];

    // Har step mein array aur sorted list ki COPY leni zaroori hai,
    // warna baad ke swaps purane steps ko bhi badal denge.
    void add(
      String op,
      String text,
      int line, {
      Map<String, int> pointers = const {},
      List<int> sorted = const [],
      List<int> active = const [],
    }) {
      steps.add(VisualizationStep(
        index: steps.length,
        state: VisualizationState(
          array: List<int>.of(a),
          pointers: pointers,
          highlighted: List<int>.of(sorted),
        ),
        operation: op,
        explanationHinglish: text,
        codeLine: line,
        highlights: active,
      ));
    }

    if (n <= 1) {
      add(
        'done',
        n == 0
            ? 'Array khali hai, sort karne ko kuch nahi.'
            : 'Sirf ek element hai, wo pehle se sorted hai.',
        0,
        sorted: List<int>.generate(n, (i) => i),
      );
      return _build(initial, steps);
    }

    add(
      'init',
      'Selection Sort shuru. Har round mein bache hue elements mein '
          'sabse chhota dhoondh kar uski sahi jagah par rakhenge.',
      0,
    );

    final sorted = <int>[];
    for (var i = 0; i < n - 1; i++) {
      var min = i;

      for (var j = i + 1; j < n; j++) {
        add(
          'compare',
          'a[$j] = ${a[j]} ko ab tak ke sabse chhote a[$min] = ${a[min]} '
              'se compare karte hain.',
          3,
          pointers: {'I': i, 'J': j, 'MIN': min},
          sorted: sorted,
          active: [j, min],
        );

        if (a[j] < a[min]) {
          min = j;
          add(
            'new_min',
            '${a[j]} chhota hai. Naya minimum mil gaya, MIN = $j.',
            3,
            pointers: {'I': i, 'J': j, 'MIN': min},
            sorted: sorted,
            active: [j],
          );
        }
      }

      // Is round ka index ab pakka ho gaya (swap ho ya na ho).
      sorted.add(i);

      if (min != i) {
        final first = a[i];
        final smallest = a[min];
        a[i] = smallest;
        a[min] = first;
        add(
          'swap',
          'Sabse chhota $smallest index $min par mila. Use a[$i] ke '
              'saath badal diya. Ab a[$i] = $smallest.',
          5,
          pointers: {'I': i, 'MIN': min},
          sorted: sorted,
          active: [i, min],
        );
      } else {
        add(
          'no_swap',
          'a[$i] = ${a[i]} pehle se sabse chhota hai. Swap ki zaroorat '
              'nahi.',
          5,
          pointers: {'I': i, 'MIN': min},
          sorted: sorted,
          active: [i],
        );
      }
    }

    add(
      'done',
      'Saare rounds poore. Poora array sorted hai.',
      6,
      sorted: List<int>.generate(n, (k) => k),
    );
    return _build(initial, steps);
  }

  Visualization _build(
    VisualizationState initial,
    List<VisualizationStep> steps,
  ) {
    return Visualization(
      id: 'selection_sort_viz',
      algorithmId: algorithmId,
      title: title,
      initialState: initial,
      steps: steps,
      checkpoint: const Checkpoint(
        question: 'Selection Sort har round mein kya karta hai?',
        options: [
          'Bache hue elements mein sabse chhota dhoondh kar sahi jagah rakhta hai',
          'Paas-paas ke elements ko baar-baar swap karta hai',
          'Array ko beech se do hisson mein todta hai',
          'Har element ko ek-ek karke target se compare karta hai',
        ],
        correctIndex: 0,
        explanationHinglish:
            'Selection Sort har round mein unsorted hisse ka sabse chhota '
            'element chunta hai aur use aage ki sahi jagah par rakh deta '
            'hai. Compare bahut hote hain, isliye ye O(n^2) hai.',
      ),
      complexity: const Complexity(time: 'O(n^2)', space: 'O(1)'),
    );
  }
}