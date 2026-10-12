import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:abhay/features/visualization/visualize_page.dart';

/// Visualize tab kholo, lambi screen ke saath.
Future<void> openVisualize(WidgetTester tester) async {
  tester.view.physicalSize = const Size(800, 3000);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(
    const MaterialApp(home: Scaffold(body: VisualizePage())),
  );
}

void main() {
  testWidgets('Binary Search ka Dekho button page kholta hai',
      (tester) async {
    await openVisualize(tester);
    await tester.tap(find.byKey(const Key('open-binary-search')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('page-binary-search')), findsOneWidget);
  });

  testWidgets('Linear Search ka Dekho button page kholta hai',
      (tester) async {
    await openVisualize(tester);
    await tester.tap(find.byKey(const Key('open-linear-search')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('page-linear-search')), findsOneWidget);
  });

  testWidgets('Sorts par abhi Dekho button nahi, Jald aa raha hai',
      (tester) async {
    await openVisualize(tester);
    expect(find.byKey(const Key('open-bubble-sort')), findsNothing);
    expect(find.text('Jald aa raha hai'), findsWidgets);
  });
}