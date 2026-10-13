import '../../visualization/engine/algorithm_generator.dart';
import '../../visualization/engine/checkpoint.dart';
import '../../visualization/engine/visualization.dart';
import '../../visualization/engine/visualization_state.dart';
import '../../visualization/engine/visualization_step.dart';

/// Bubble Sort ke steps banata hai. `target` ignore hota hai.
/// Same input -> hamesha same steps. Koi random ya time use nahi.
class BubbleSortGenerator implements AlgorithmGenerator {
  @override
  String get algorithmId => 'bubble_sort';

  @override
  String get title => 'Bubble Sort';

  @override
  Visualization generate({required List<int> input, int? target}) {
    final a = List<int>.of(input);
    final n = a.length;
    final initial = VisualizationState(array: List<int>.of(a));
    final steps = <VisualizationStep>[];

    // Har step ke liye array aur sorted list ki COPY leni zaroori hai,
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
      'Bubble Sort shuru. Har pass mein paas-paas ke elements compare '
          'honge, aur bada element aage khisakta jayega.',
      0,
    );

    final sorted = <int>[];
    for (var i = 0; i < n - 1; i++) {
      var swapped = false;

      for (var j = 0; j < n - 1 - i; j++) {
        final ptr = {'J': j, 'J+1': j + 1};
        add(
          'compare',
          'a[$j] = ${a[j]} aur a[${j + 1}] = ${a[j + 1]} ko compare '
              'karte hain.',
          3,
          pointers: ptr,
          sorted: sorted,
          active: [j, j + 1],
        );

        if (a[j] > a[j + 1]) {
          final left = a[j];
          final right = a[j + 1];
          a[j] = right;
          a[j + 1] = left;
          swapped = true;
          add(
            'swap',
            '$left bada hai $right se, isliye dono ki jagah badal di. '
                'Ab a[$j] = $right aur a[${j + 1}] = $left.',
            4,
            pointers: ptr,
            sorted: sorted,
            active: [j, j + 1],
          );
        } else {
          add(
            'no_swap',
            '${a[j]} chhota ya barabar hai ${a[j + 1]} se. Swap ki '
                'zaroorat nahi.',
            3,
            pointers: ptr,
            sorted: sorted,
            active: [j, j + 1],
          );
        }
      }

      // Is pass ke baad aakhri unsorted jagah par sabse bada aa gaya.
      sorted.add(n - 1 - i);

      if (!swapped) {
        // Koi swap nahi hua: baaki array bhi sorted hai.
        add(
          'done',
          'Is pass mein koi swap nahi hua, matlab array sorted hai. '
              'Bubble Sort yahin ruk gaya.',
          8,
          sorted: List<int>.generate(n, (k) => k),
        );
        return _build(initial, steps);
      }

      if (i == n - 2) {
        add(
          'done',
          'Saare passes poore. Poora array sorted hai.',
          9,
          sorted: List<int>.generate(n, (k) => k),
        );
        return _build(initial, steps);
      }

      add(
        'pass_done',
        'Pass ${i + 1} poora. ${a[n - 1 - i]} apni sahi jagah (index '
            '${n - 1 - i}) par pahunch gaya.',
        8,
        sorted: sorted,
      );
    }

    return _build(initial, steps);
  }

  Visualization _build(
    VisualizationState initial,
    List<VisualizationStep> steps,
  ) {
    return Visualization(
      id: 'bubble_sort_viz',
      algorithmId: algorithmId,
      title: title,
      initialState: initial,
      steps: steps,
      checkpoint: const Checkpoint(
        question: 'Bubble Sort ka ek pass poora hone par kya hota hai?',
        options: [
          'Sabse bada element apni sahi jagah (aakhir) par pahunch jaata hai',
          'Sabse chhota element sabse pehle pahunch jaata hai',
          'Poora array reverse ho jaata hai',
          'Array mein kuch nahi badalta',
        ],
        correctIndex: 0,
        explanationHinglish:
            'Ek pass mein bada element swap hote hote aakhir tak khisak '
            'jaata hai, bubble ki tarah. Isliye ek pass ke baad aakhri '
            'jagah pakki ho jaati hai. Poora sort O(n^2) hai.',
      ),
      complexity: const Complexity(time: 'O(n^2)', space: 'O(1)'),
    );
  }
}