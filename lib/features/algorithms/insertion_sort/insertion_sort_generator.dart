import '../../visualization/engine/algorithm_generator.dart';
import '../../visualization/engine/checkpoint.dart';
import '../../visualization/engine/visualization.dart';
import '../../visualization/engine/visualization_state.dart';
import '../../visualization/engine/visualization_step.dart';

/// Insertion Sort ke steps banata hai. `target` ignore hota hai.
/// Same input -> hamesha same steps. Koi random ya time use nahi.
class InsertionSortGenerator implements AlgorithmGenerator {
  @override
  String get algorithmId => 'insertion_sort';

  @override
  String get title => 'Insertion Sort';

  @override
  Visualization generate({required List<int> input, int? target}) {
    final a = List<int>.of(input);
    final n = a.length;
    final initial = VisualizationState(array: List<int>.of(a));
    final steps = <VisualizationStep>[];

    // Har step mein array aur sorted list ki COPY leni zaroori hai,
    // warna baad ke shifts purane steps ko bhi badal denge.
    void add(
      String op,
      String text,
      int line, {
      Map<String, int> pointers = const {},
      Map<int, String> labels = const {},
      List<int> sorted = const [],
      List<int> active = const [],
    }) {
      steps.add(VisualizationStep(
        index: steps.length,
        state: VisualizationState(
          array: List<int>.of(a),
          pointers: pointers,
          highlighted: List<int>.of(sorted),
          labels: labels,
        ),
        operation: op,
        explanationHinglish: text,
        codeLine: line,
        highlights: active,
      ));
    }

    List<int> upTo(int count) => List<int>.generate(count, (k) => k);

    if (n <= 1) {
      add(
        'done',
        n == 0
            ? 'Array khali hai, sort karne ko kuch nahi.'
            : 'Sirf ek element hai, wo pehle se sorted hai.',
        0,
        sorted: upTo(n),
      );
      return _build(initial, steps);
    }

    add(
      'init',
      'Insertion Sort shuru. Index 0 akela sorted hai. Ek-ek element '
          'uthakar sorted hisse mein sahi jagah par daalenge.',
      0,
      sorted: [0],
    );

    for (var i = 1; i < n; i++) {
      final key = a[i];
      var j = i - 1;

      add(
        'pick_key',
        'KEY = a[$i] = $key utha li. Ab ise baayein sorted hisse mein '
            'sahi jagah par daalna hai.',
        1,
        pointers: {'I': i, 'J': j},
        labels: {i: 'KEY=$key'},
        sorted: upTo(i),
        active: [i],
      );

      while (j >= 0) {
        add(
          'compare',
          'a[$j] = ${a[j]} ko KEY = $key se compare karte hain.',
          3,
          pointers: {'I': i, 'J': j},
          labels: {j + 1: 'KEY=$key'},
          sorted: upTo(i),
          active: [j],
        );

        if (a[j] > key) {
          a[j + 1] = a[j];
          add(
            'shift',
            '${a[j]} bada hai $key se, isliye use ek jagah aage khisaya. '
                'Ab a[${j + 1}] = ${a[j + 1]}.',
            4,
            pointers: {'I': i, 'J': j},
            labels: {j: 'KEY=$key'},
            sorted: upTo(i),
            active: [j, j + 1],
          );
          j--;
        } else {
          break;
        }
      }

      final pos = j + 1;
      a[pos] = key;
      add(
        'insert',
        pos == i
            ? 'KEY = $key pehle se sahi jagah par hai (index $pos). '
                'Kuch khisakna nahi pada.'
            : 'KEY = $key ko index $pos par rakh diya. Ab index 0 se '
                '$i tak sorted hai.',
        7,
        pointers: {'I': i},
        labels: {pos: 'KEY=$key'},
        sorted: upTo(i + 1),
        active: [pos],
      );
    }

    add(
      'done',
      'Saare elements sahi jagah par aa gaye. Poora array sorted hai.',
      8,
      sorted: upTo(n),
    );
    return _build(initial, steps);
  }

  Visualization _build(
    VisualizationState initial,
    List<VisualizationStep> steps,
  ) {
    return Visualization(
      id: 'insertion_sort_viz',
      algorithmId: algorithmId,
      title: title,
      initialState: initial,
      steps: steps,
      checkpoint: const Checkpoint(
        question: 'Insertion Sort mein key ko sahi jagah daalne ke liye '
            'bade elements ke saath kya hota hai?',
        options: [
          'Wo ek jagah aage khisak jaate hain, aur key beech mein baithti hai',
          'Wo array ke aakhir mein swap ho jaate hain',
          'Poora array reverse ho jaata hai',
          'Sabse chhota element dhoondh kar pehle index par rakha jaata hai',
        ],
        correctIndex: 0,
        explanationHinglish:
            'Insertion Sort key se bade elements ko ek-ek jagah aage '
            'khisakata hai, phir key ko khali hui jagah par rakh deta hai, '
            'jaise haath mein taash ke patte jamate hain. Worst case '
            'O(n^2) hai.',
      ),
      complexity: const Complexity(time: 'O(n^2)', space: 'O(1)'),
    );
  }
}