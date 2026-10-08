import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// NOTE: 'abhay' = project name. Agar aapne `flutter create` mein alag naam diya hai
// to ye imports us naam se badal do (pubspec.yaml ka `name:` dekho).
import 'package:abhay/app/app.dart';
import 'package:abhay/core/models/user_progress.dart';

Finder navLabel(String label) =>
    find.descendant(of: find.byType(NavigationBar), matching: find.text(label));

void main() {
  testWidgets('app Home par khulta hai aur 5 tabs dikhte hain', (tester) async {
    await tester.pumpWidget(const AbhayApp());
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('page-home')), findsOneWidget);
    for (final l in ['Home', 'Roadmap', 'Visualize', 'Contest', 'Profile']) {
      expect(navLabel(l), findsOneWidget);
    }
  });

  testWidgets('saare 5 tabs khulte hain', (tester) async {
    await tester.pumpWidget(const AbhayApp());
    await tester.pumpAndSettle();

    const tabs = {
      'Roadmap': 'page-roadmap',
      'Visualize': 'page-visualize',
      'Contest': 'page-contest',
      'Profile': 'page-profile',
      'Home': 'page-home',
    };
    for (final e in tabs.entries) {
      await tester.tap(navLabel(e.key));
      await tester.pumpAndSettle();
      expect(find.byKey(Key(e.value)), findsOneWidget, reason: '${e.key} tab nahi khula');
    }
  });

  testWidgets('Home ka button Visualize tab kholta hai', (tester) async {
    await tester.pumpWidget(const AbhayApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Visualization dekho'));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('page-visualize')), findsOneWidget);
  });

  testWidgets('roadmap par completed/unlocked/locked labels dikhte hain', (tester) async {
    tester.view.physicalSize = const Size(800, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const AbhayApp());
    await tester.pumpAndSettle();
    await tester.tap(navLabel('Roadmap'));
    await tester.pumpAndSettle();

    expect(find.text('Complete'), findsWidgets);
    expect(find.text('Khula hai'), findsWidgets);
    expect(find.text('Locked'), findsWidgets);
  });

  testWidgets('contest tab mein 3 sub-tabs hain', (tester) async {
    await tester.pumpWidget(const AbhayApp());
    await tester.pumpAndSettle();
    await tester.tap(navLabel('Contest'));
    await tester.pumpAndSettle();

    expect(find.text('Upcoming'), findsOneWidget);
    expect(find.text('Live'), findsOneWidget);
    expect(find.text('Completed'), findsOneWidget);
  });

  testWidgets('dark mode switch theme badalta hai', (tester) async {
    await tester.pumpWidget(const AbhayApp());
    await tester.pumpAndSettle();
    await tester.tap(navLabel('Profile'));
    await tester.pumpAndSettle();

    MaterialApp app() => tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(app().themeMode, ThemeMode.dark);

    await tester.tap(find.byType(Switch));
    await tester.pumpAndSettle();
    expect(app().themeMode, ThemeMode.light);
  });

  test('dailyGoalFraction 0 se 1 ke beech rehta hai', () {
    const a = UserProgress(
        name: 'x', xp: 0, streak: 0, dailyGoalDone: 1, dailyGoalTarget: 4, currentTopicId: 'a');
    const b = UserProgress(
        name: 'x', xp: 0, streak: 0, dailyGoalDone: 9, dailyGoalTarget: 4, currentTopicId: 'a');
    const c = UserProgress(
        name: 'x', xp: 0, streak: 0, dailyGoalDone: 1, dailyGoalTarget: 0, currentTopicId: 'a');
    expect(a.dailyGoalFraction, 0.25);
    expect(b.dailyGoalFraction, 1.0);
    expect(c.dailyGoalFraction, 0.0);
  });
}
