import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:abhay/features/visualization/visualize_page.dart';

void main() {
  testWidgets('Binary Search ka Dekho button page kholta hai',
      (tester) async {
    tester.view.physicalSize = const Size(800, 3000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: VisualizePage())),
    );
    await tester.tap(find.byKey(const Key('open-binary-search')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('page-binary-search')), findsOneWidget);
  });
}