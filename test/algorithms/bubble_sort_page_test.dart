import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:abhay/features/algorithms/bubble_sort/bubble_sort_page.dart';

/// Lambi screen set karo taaki ListView ke saare widgets ban jayein.
Future<void> openPage(WidgetTester tester) async {
  tester.view.physicalSize = const Size(800, 3000);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(const MaterialApp(home: BubbleSortPage()));
}

void main() {
  testWidgets('page khulta hai: player aur checkpoint dikhte hain',
      (tester) async {
    await openPage(tester);
    expect(find.byKey(const Key('page-bubble-sort')), findsOneWidget);
    expect(find.byKey(const Key('visualization-player')), findsOneWidget);
    expect(find.byKey(const Key('checkpoint-card')), findsOneWidget);
  });

  testWidgets('appbar mein title dikhta hai', (tester) async {
    await openPage(tester);
    expect(find.text('Bubble Sort'), findsOneWidget);
  });

  testWidgets('sahi jawab par sahi feedback', (tester) async {
    await openPage(tester);
    await tester.tap(find.byKey(const Key('option-0')));
    await tester.pump();
    await tester.tap(find.byKey(const Key('btn-submit')));
    await tester.pump();
    expect(find.text('Sahi jawab!'), findsOneWidget);
  });

  testWidgets('galat jawab par galat feedback', (tester) async {
    await openPage(tester);
    await tester.tap(find.byKey(const Key('option-1')));
    await tester.pump();
    await tester.tap(find.byKey(const Key('btn-submit')));
    await tester.pump();
    expect(find.text('Galat, phir se socho.'), findsOneWidget);
  });

  testWidgets('option chune bina submit disabled hai', (tester) async {
    await openPage(tester);
    final btn = tester.widget<FilledButton>(
      find.byKey(const Key('btn-submit')),
    );
    expect(btn.onPressed, isNull);
  });
}