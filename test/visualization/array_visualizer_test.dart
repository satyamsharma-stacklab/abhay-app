import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:abhay/features/visualization/engine/visualization_state.dart';
import 'package:abhay/features/visualization/widgets/array_visualizer.dart';
import 'package:abhay/features/visualization/widgets/pointer_marker.dart';

/// Test ke liye widget ko MaterialApp mein lapet do.
Widget wrap(Widget child) {
  return MaterialApp(home: Scaffold(body: child));
}

void main() {
  group('ArrayVisualizer', () {
    testWidgets('har value ka box dikhta hai', (tester) async {
      const state = VisualizationState(array: [10, 20, 30]);
      await tester.pumpWidget(wrap(const ArrayVisualizer(state: state)));

      expect(find.byKey(const Key('cell-0')), findsOneWidget);
      expect(find.byKey(const Key('cell-1')), findsOneWidget);
      expect(find.byKey(const Key('cell-2')), findsOneWidget);
      expect(find.text('10'), findsOneWidget);
      expect(find.text('20'), findsOneWidget);
      expect(find.text('30'), findsOneWidget);
    });

    testWidgets('khali array par message dikhta hai', (tester) async {
      const state = VisualizationState(array: []);
      await tester.pumpWidget(wrap(const ArrayVisualizer(state: state)));

      expect(find.text('Array khali hai.'), findsOneWidget);
      expect(find.byKey(const Key('cell-0')), findsNothing);
    });

    testWidgets('pointers sahi index ke upar dikhte hain', (tester) async {
      const state = VisualizationState(
        array: [1, 2, 3, 4, 5],
        pointers: {'LOW': 0, 'MID': 2, 'HIGH': 4},
      );
      await tester.pumpWidget(wrap(const ArrayVisualizer(state: state)));

      expect(find.byKey(const Key('pointer-LOW')), findsOneWidget);
      expect(find.byKey(const Key('pointer-MID')), findsOneWidget);
      expect(find.byKey(const Key('pointer-HIGH')), findsOneWidget);
    });

    testWidgets('active index par aankh icon dikhta hai', (tester) async {
      const state = VisualizationState(array: [1, 2, 3]);
      await tester.pumpWidget(
        wrap(const ArrayVisualizer(state: state, activeIndices: [1])),
      );

      expect(find.byIcon(Icons.visibility), findsOneWidget);
    });

    testWidgets('highlighted index par tick icon dikhta hai', (tester) async {
      const state = VisualizationState(
        array: [1, 2, 3],
        highlighted: [0, 2],
      );
      await tester.pumpWidget(wrap(const ArrayVisualizer(state: state)));

      expect(find.byIcon(Icons.check_circle), findsNWidgets(2));
    });

    testWidgets('label index ke neeche dikhta hai', (tester) async {
      const state = VisualizationState(
        array: [1, 2, 3],
        labels: {1: 'FOUND'},
      );
      await tester.pumpWidget(wrap(const ArrayVisualizer(state: state)));

      expect(find.text('FOUND'), findsOneWidget);
    });
  });

  group('PointerMarker', () {
    testWidgets('naam aur arrow icon dono dikhte hain', (tester) async {
      await tester.pumpWidget(
        wrap(const PointerMarker(names: ['LOW', 'MID'])),
      );

      expect(find.text('LOW'), findsOneWidget);
      expect(find.text('MID'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_downward), findsOneWidget);
    });
  });
}