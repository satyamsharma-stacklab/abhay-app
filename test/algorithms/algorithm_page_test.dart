import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:abhay/features/algorithms/algorithm_page.dart';
import 'package:abhay/features/algorithms/binary_search/binary_search_code.dart';
import 'package:abhay/features/algorithms/binary_search/binary_search_generator.dart';
import 'package:abhay/features/algorithms/bubble_sort/bubble_sort_code.dart';
import 'package:abhay/features/algorithms/bubble_sort/bubble_sort_generator.dart';

Future<void> open(WidgetTester tester, Widget page) async {
  tester.view.physicalSize = const Size(800, 3000);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(MaterialApp(home: page));
}

void main() {
  testWidgets('target ho to title mein target dikhta hai', (tester) async {
    await open(
      tester,
      AlgorithmPage(
        generator: BinarySearchGenerator(),
        codeLines: binarySearchCodeLines,
        input: const [1, 3, 5],
        target: 3,
        pageKey: 'page-test',
      ),
    );
    expect(find.text('Binary Search (target 3)'), findsOneWidget);
    expect(find.byKey(const Key('page-test')), findsOneWidget);
  });

  testWidgets('target na ho to sirf title dikhta hai', (tester) async {
    await open(
      tester,
      AlgorithmPage(
        generator: BubbleSortGenerator(),
        codeLines: bubbleSortCodeLines,
        input: const [3, 1, 2],
        pageKey: 'page-test',
      ),
    );
    expect(find.text('Bubble Sort'), findsOneWidget);
    expect(find.byKey(const Key('visualization-player')), findsOneWidget);
    expect(find.byKey(const Key('checkpoint-card')), findsOneWidget);
  });
}