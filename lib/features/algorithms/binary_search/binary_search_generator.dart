import '../../visualization/engine/algorithm_generator.dart';
import '../../visualization/engine/checkpoint.dart';
import '../../visualization/engine/visualization.dart';
import '../../visualization/engine/visualization_state.dart';
import '../../visualization/engine/visualization_step.dart';

/// Binary Search ke steps banata hai (sorted array maan kar).
/// Same input -> hamesha same steps. Koi random ya time use nahi.
class BinarySearchGenerator implements AlgorithmGenerator {
  @override
  String get algorithmId => 'binary_search';

  @override
  String get title => 'Binary Search';

  @override
  Visualization generate({required List<int> input, int? target}) {
    final a = List<int>.of(input);
    final t = target ?? 0;
    final initial = VisualizationState(array: a);
    final steps = <VisualizationStep>[];

    void add(
      String op,
      String text,
      int line,
      VisualizationState state,
      List<int> active,
    ) {
      steps.add(VisualizationStep(
        index: steps.length,
        state: state,
        operation: op,
        explanationHinglish: text,
        codeLine: line,
        highlights: active,
      ));
    }

    var lo = 0;
    var hi = a.length - 1;

    if (a.isNotEmpty) {
      add(
        'init',
        'Shuru mein LOW = 0 aur HIGH = $hi. Poora array abhi search '
            'range hai.',
        0,
        initial.copyWith(pointers: {'LOW': lo, 'HIGH': hi}),
        const [],
      );
    }

    var found = -1;
    while (lo <= hi) {
      final mid = (lo + hi) ~/ 2;
      final ptr = {'LOW': lo, 'MID': mid, 'HIGH': hi};
      add(
        'mid',
        'MID = ($lo + $hi) / 2 = $mid. Ab a[$mid] = ${a[mid]} ko '
            '$t se compare karenge.',
        2,
        initial.copyWith(pointers: ptr),
        [mid],
      );

      if (a[mid] == t) {
        found = mid;
        add(
          'found',
          'a[$mid] = ${a[mid]} barabar hai $t ke. Mil gaya! '
              'Index $mid par.',
          3,
          initial.copyWith(
            pointers: ptr,
            highlighted: [mid],
            labels: {mid: 'FOUND'},
          ),
          [mid],
        );
        break;
      } else if (a[mid] < t) {
        add(
          'go_right',
          'a[$mid] = ${a[mid]} chhota hai $t se. Left half bekaar, '
              'LOW = ${mid + 1}.',
          4,
          initial.copyWith(pointers: ptr),
          [mid],
        );
        lo = mid + 1;
      } else {
        add(
          'go_left',
          'a[$mid] = ${a[mid]} bada hai $t se. Right half bekaar, '
              'HIGH = ${mid - 1}.',
          5,
          initial.copyWith(pointers: ptr),
          [mid],
        );
        hi = mid - 1;
      }
    }

    if (found == -1) {
      add(
        'not_found',
        a.isEmpty
            ? 'Array khali hai, isliye $t nahi mil sakta.'
            : 'LOW ($lo) HIGH ($hi) se bada ho gaya. $t array mein '
                'nahi hai.',
        7,
        initial,
        const [],
      );
    }

    return Visualization(
      id: 'binary_search_viz',
      algorithmId: algorithmId,
      title: title,
      initialState: initial,
      steps: steps,
      checkpoint: const Checkpoint(
        question: 'Binary Search har step mein kya karta hai?',
        options: [
          'Array ko aadha karke ek half chhod deta hai',
          'Har element ko ek-ek karke check karta hai',
          'Array ko pehle reverse karta hai',
          'Sirf last element dekhta hai',
        ],
        correctIndex: 0,
        explanationHinglish:
            'Binary Search MID dekhta hai aur target ke hisaab se left ya '
            'right half chhod deta hai. Isliye ye O(log n) hai.',
      ),
      complexity: const Complexity(time: 'O(log n)', space: 'O(1)'),
    );
  }
}