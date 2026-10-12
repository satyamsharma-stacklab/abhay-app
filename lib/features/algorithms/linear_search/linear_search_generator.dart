import '../../visualization/engine/algorithm_generator.dart';
import '../../visualization/engine/checkpoint.dart';
import '../../visualization/engine/visualization.dart';
import '../../visualization/engine/visualization_state.dart';
import '../../visualization/engine/visualization_step.dart';

/// Linear Search ke steps banata hai (array sorted hona zaroori nahi).
/// Same input -> hamesha same steps. Koi random ya time use nahi.
class LinearSearchGenerator implements AlgorithmGenerator {
  @override
  String get algorithmId => 'linear_search';

  @override
  String get title => 'Linear Search';

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

    var found = -1;
    for (var i = 0; i < a.length; i++) {
      final ptr = {'I': i};

      // Step 1: i par element ko target se compare karo.
      add(
        'check',
        'I = $i. a[$i] = ${a[i]} ko $t se compare karte hain.',
        1,
        initial.copyWith(pointers: ptr),
        [i],
      );

      if (a[i] == t) {
        found = i;
        add(
          'found',
          'a[$i] = ${a[i]} barabar hai $t ke. Mil gaya! Index $i par.',
          1,
          initial.copyWith(
            pointers: ptr,
            highlighted: [i],
            labels: {i: 'FOUND'},
          ),
          [i],
        );
        break;
      }

      // Step 2: match nahi hua, agle element par jao.
      // Aakhri element ke baad "next" step nahi dikhate.
      if (i < a.length - 1) {
        add(
          'next',
          'a[$i] = ${a[i]} barabar nahi hai $t ke. Aage badho, '
              'I = ${i + 1}.',
          0,
          initial.copyWith(pointers: ptr),
          [i],
        );
      }
    }

    if (found == -1) {
      add(
        'not_found',
        a.isEmpty
            ? 'Array khali hai, isliye $t nahi mil sakta.'
            : 'Poora array check ho gaya. $t array mein nahi hai.',
        3,
        initial,
        const [],
      );
    }

    return Visualization(
      id: 'linear_search_viz',
      algorithmId: algorithmId,
      title: title,
      initialState: initial,
      steps: steps,
      checkpoint: const Checkpoint(
        question: 'Linear Search mein worst case mein kitne elements '
            'check karne padte hain?',
        options: [
          'Poore n elements',
          'Sirf aadhe elements',
          'Sirf log n elements',
          'Sirf pehla element',
        ],
        correctIndex: 0,
        explanationHinglish:
            'Agar target aakhri index par ho ya array mein ho hi nahi, '
            'to Linear Search ko har element dekhna padta hai. '
            'Isliye ye O(n) hai.',
      ),
      complexity: const Complexity(time: 'O(n)', space: 'O(1)'),
    );
  }
}