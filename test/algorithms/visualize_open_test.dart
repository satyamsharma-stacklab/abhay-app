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

/// (topic id, us page ka key) ki list.
const _pages = {
  'binary-search': 'page-binary-search',
  'linear-search': 'page-linear-search',
  'bubble-sort': 'page-bubble-sort',
  'selection-sort': 'page-selection-sort',
  'insertion-sort': 'page-insertion-sort',
};

void main() {
  _pages.forEach((id, pageKey) {
    testWidgets('$id ka Dekho button page kholta hai', (tester) async {
      await openVisualize(tester);
      await tester.tap(find.byKey(Key('open-$id')));
      await tester.pumpAndSettle();
      expect(find.byKey(Key(pageKey)), findsOneWidget);
    });
  });

  testWidgets('saare playable topics par Dekho button hai', (tester) async {
    await openVisualize(tester);
    expect(find.text('Dekho'), findsNWidgets(_pages.length));
    expect(find.text('Jald aa raha hai'), findsNothing);
  });
}