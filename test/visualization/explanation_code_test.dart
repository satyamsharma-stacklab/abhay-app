import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:abhay/features/visualization/widgets/code_panel.dart';
import 'package:abhay/features/visualization/widgets/explanation_box.dart';

Widget wrap(Widget child) {
  return MaterialApp(home: Scaffold(body: child));
}

void main() {
  group('ExplanationBox', () {
    testWidgets('text dikhata hai', (tester) async {
      await tester.pumpWidget(wrap(const ExplanationBox(text: 'Mid dekha')));
      expect(find.text('Mid dekha'), findsOneWidget);
    });

    testWidgets('text null ho to shuruaati message', (tester) async {
      await tester.pumpWidget(wrap(const ExplanationBox()));
      expect(
        find.text('Play ya Next dabao, step yahan samjhaya jayega.'),
        findsOneWidget,
      );
    });
  });

  group('CodePanel', () {
    const lines = ['int lo = 0;', 'while (lo <= hi) {', '  mid = ...;'];

    testWidgets('saari lines dikhti hain', (tester) async {
      await tester.pumpWidget(wrap(const CodePanel(lines: lines)));
      expect(find.byKey(const Key('code-line-0')), findsOneWidget);
      expect(find.byKey(const Key('code-line-2')), findsOneWidget);
      expect(find.text('int lo = 0;'), findsOneWidget);
    });

    testWidgets('active line par arrow dikhta hai', (tester) async {
      await tester.pumpWidget(
        wrap(const CodePanel(lines: lines, activeLine: 1)),
      );
      expect(find.byIcon(Icons.arrow_right), findsOneWidget);
    });

    testWidgets('activeLine null ho to koi arrow nahi', (tester) async {
      await tester.pumpWidget(wrap(const CodePanel(lines: lines)));
      expect(find.byIcon(Icons.arrow_right), findsNothing);
    });
  });
}