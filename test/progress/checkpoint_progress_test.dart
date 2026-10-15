import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:abhay/features/algorithms/binary_search/binary_search_page.dart';
import 'package:abhay/features/progress/progress_controller.dart';
import 'package:abhay/features/progress/progress_repository.dart';
import 'package:abhay/features/progress/progress_scope.dart';

Future<ProgressController> openPage(WidgetTester tester) async {
  tester.view.physicalSize = const Size(800, 3000);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  SharedPreferences.setMockInitialValues({});
  final prefs = await SharedPreferences.getInstance();
  final controller = ProgressController(
    repository: ProgressRepository(prefs),
    now: () => DateTime(2026, 10, 15, 10),
  );
  await tester.pumpWidget(
    ProgressScope(
      controller: controller,
      child: const MaterialApp(home: BinarySearchPage()),
    ),
  );
  return controller;
}

Future<void> answer(WidgetTester tester, int option) async {
  await tester.tap(find.byKey(Key('option-$option')));
  await tester.pump();
  await tester.tap(find.byKey(const Key('btn-submit')));
  await tester.pump();
}

void main() {
  testWidgets('sahi jawab par topic complete, 20 XP, streak 1', (tester) async {
    final c = await openPage(tester);
    await answer(tester, 0);
    expect(c.isCompleted('binary-search'), isTrue);
    expect(c.state.xp, 20);
    expect(c.streak, 1);
    expect(c.todayCorrect, 1);
  });

  testWidgets('galat jawab par koi XP ya progress nahi', (tester) async {
    final c = await openPage(tester);
    await answer(tester, 1);
    expect(c.isCompleted('binary-search'), isFalse);
    expect(c.state.xp, 0);
    expect(c.streak, 0);
  });
}