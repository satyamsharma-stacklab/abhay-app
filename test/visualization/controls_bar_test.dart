import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:abhay/features/visualization/widgets/controls_bar.dart';

Widget build({
  bool isPlaying = false,
  bool canGoPrevious = true,
  bool canGoNext = true,
  double speed = 1.0,
  VoidCallback? onPlay,
  VoidCallback? onPause,
  VoidCallback? onNext,
  VoidCallback? onPrevious,
  VoidCallback? onRestart,
  ValueChanged<double>? onSpeedChanged,
}) {
  return MaterialApp(
    home: Scaffold(
      body: ControlsBar(
        isPlaying: isPlaying,
        canGoPrevious: canGoPrevious,
        canGoNext: canGoNext,
        speed: speed,
        onPlay: onPlay ?? () {},
        onPause: onPause ?? () {},
        onNext: onNext ?? () {},
        onPrevious: onPrevious ?? () {},
        onRestart: onRestart ?? () {},
        onSpeedChanged: onSpeedChanged ?? (_) {},
      ),
    ),
  );
}

void main() {
  testWidgets('rukne par play icon dikhta hai', (tester) async {
    await tester.pumpWidget(build());
    expect(find.byIcon(Icons.play_arrow), findsOneWidget);
    expect(find.byIcon(Icons.pause), findsNothing);
  });

  testWidgets('chalte waqt pause icon dikhta hai', (tester) async {
    await tester.pumpWidget(build(isPlaying: true));
    expect(find.byIcon(Icons.pause), findsOneWidget);
    expect(find.byIcon(Icons.play_arrow), findsNothing);
  });

  testWidgets('play dabane par onPlay call hota hai', (tester) async {
    var played = false;
    await tester.pumpWidget(build(onPlay: () => played = true));
    await tester.tap(find.byKey(const Key('btn-play-pause')));
    expect(played, isTrue);
  });

  testWidgets('pause dabane par onPause call hota hai', (tester) async {
    var paused = false;
    await tester.pumpWidget(
      build(isPlaying: true, onPause: () => paused = true),
    );
    await tester.tap(find.byKey(const Key('btn-play-pause')));
    expect(paused, isTrue);
  });

  testWidgets('next aur previous callbacks chalte hain', (tester) async {
    var next = 0;
    var prev = 0;
    await tester.pumpWidget(
      build(onNext: () => next++, onPrevious: () => prev++),
    );
    await tester.tap(find.byKey(const Key('btn-next')));
    await tester.tap(find.byKey(const Key('btn-previous')));
    expect(next, 1);
    expect(prev, 1);
  });

  testWidgets('disabled buttons par callback nahi chalta', (tester) async {
    var next = 0;
    var prev = 0;
    await tester.pumpWidget(
      build(
        canGoPrevious: false,
        canGoNext: false,
        onNext: () => next++,
        onPrevious: () => prev++,
      ),
    );
    await tester.tap(find.byKey(const Key('btn-next')));
    await tester.tap(find.byKey(const Key('btn-previous')));
    expect(next, 0);
    expect(prev, 0);
  });

  testWidgets('restart callback chalta hai', (tester) async {
    var restarted = false;
    await tester.pumpWidget(build(onRestart: () => restarted = true));
    await tester.tap(find.byKey(const Key('btn-restart')));
    expect(restarted, isTrue);
  });

  testWidgets('speed chip dabane par naya speed milta hai', (tester) async {
    double? picked;
    await tester.pumpWidget(build(onSpeedChanged: (s) => picked = s));
    await tester.tap(find.byKey(const Key('speed-2.0')));
    expect(picked, 2.0);
  });
}