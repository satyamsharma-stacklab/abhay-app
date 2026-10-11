import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:abhay/features/visualization/engine/checkpoint.dart';
import 'package:abhay/features/visualization/engine/visualization.dart';
import 'package:abhay/features/visualization/engine/visualization_state.dart';
import 'package:abhay/features/visualization/engine/visualization_step.dart';
import 'package:abhay/features/visualization/widgets/visualization_player.dart';

/// Sirf test ke liye chhoti si visualization (3 step).
Visualization makeViz() {
  const initial = VisualizationState(array: [10, 20, 30]);
  final steps = <VisualizationStep>[
    for (var i = 0; i < 3; i++)
      VisualizationStep(
        index: i,
        state: initial.copyWith(pointers: {'I': i}),
        operation: 'visit',
        explanationHinglish: 'Index $i dekha',
        codeLine: i,
        highlights: [i],
        durationMs: 100,
      ),
  ];
  return Visualization(
    id: 'v',
    algorithmId: 'fake',
    title: 'Fake',
    initialState: initial,
    steps: steps,
    checkpoint: const Checkpoint(
      question: 'Q?',
      options: ['A', 'B'],
      correctIndex: 0,
      explanationHinglish: 'A sahi',
    ),
    complexity: const Complexity(time: 'O(n)', space: 'O(1)'),
  );
}

Widget wrap(Widget child) {
  return MaterialApp(
    home: Scaffold(body: SingleChildScrollView(child: child)),
  );
}

void main() {
  const lines = ['line a', 'line b', 'line c'];

  testWidgets('shuru mein initial state aur shuruaati message', (t) async {
    await t.pumpWidget(
      wrap(VisualizationPlayer(visualization: makeViz(), codeLines: lines)),
    );
    expect(find.text('10'), findsOneWidget);
    expect(
      find.text('Play ya Next dabao, step yahan samjhaya jayega.'),
      findsOneWidget,
    );
    expect(find.byIcon(Icons.arrow_right), findsNothing);
  });

  testWidgets('Next dabane par pehla step dikhta hai', (t) async {
    await t.pumpWidget(
      wrap(VisualizationPlayer(visualization: makeViz(), codeLines: lines)),
    );
    await t.tap(find.byKey(const Key('btn-next')));
    await t.pump();
    expect(find.text('Index 0 dekha'), findsOneWidget);
    expect(find.byIcon(Icons.arrow_right), findsOneWidget);
  });

  testWidgets('Previous aur Restart kaam karte hain', (t) async {
    await t.pumpWidget(wrap(VisualizationPlayer(visualization: makeViz())));
    await t.tap(find.byKey(const Key('btn-next')));
    await t.pump();
    await t.tap(find.byKey(const Key('btn-next')));
    await t.pump();
    expect(find.text('Index 1 dekha'), findsOneWidget);

    await t.tap(find.byKey(const Key('btn-previous')));
    await t.pump();
    expect(find.text('Index 0 dekha'), findsOneWidget);

    await t.tap(find.byKey(const Key('btn-restart')));
    await t.pump();
    expect(
      find.text('Play ya Next dabao, step yahan samjhaya jayega.'),
      findsOneWidget,
    );
  });

  testWidgets('aakhri step par Next disabled ho jata hai', (t) async {
    await t.pumpWidget(wrap(VisualizationPlayer(visualization: makeViz())));
    for (var i = 0; i < 3; i++) {
      await t.tap(find.byKey(const Key('btn-next')));
      await t.pump();
    }
    expect(find.text('Index 2 dekha'), findsOneWidget);
    final next = t.widget<IconButton>(find.byKey(const Key('btn-next')));
    expect(next.onPressed, isNull);
  });

  testWidgets('codeLines na do to CodePanel nahi dikhta', (t) async {
    await t.pumpWidget(wrap(VisualizationPlayer(visualization: makeViz())));
    expect(find.byKey(const Key('code-panel')), findsNothing);
  });

  testWidgets('Play dabane par steps khud aage badhte hain', (t) async {
    await t.pumpWidget(wrap(VisualizationPlayer(visualization: makeViz())));
    await t.tap(find.byKey(const Key('btn-play-pause')));
    await t.pump();
    await t.pump(const Duration(milliseconds: 150));
    await t.pump(const Duration(milliseconds: 150));
    await t.pump(const Duration(milliseconds: 150));
    expect(find.text('Index 2 dekha'), findsOneWidget);
    // Widget hatao taaki timer saaf ho jaye.
    await t.pumpWidget(const SizedBox());
  });
}