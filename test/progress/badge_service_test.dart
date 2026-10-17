import 'package:flutter_test/flutter_test.dart';
import 'package:abhay/features/progress/badge_service.dart';
import 'package:abhay/features/progress/progress_state.dart';

const svc = BadgeService();

Set<String> earned(ProgressState s, {int streak = 0}) => svc
    .badgesFor(s, streak: streak)
    .where((b) => b.earned)
    .map((b) => b.id)
    .toSet();

void main() {
  test('khali progress: koi badge nahi, 5 badges list mein', () {
    expect(earned(const ProgressState()), isEmpty);
    expect(svc.badgesFor(const ProgressState(), streak: 0).length, 5);
  });

  test('koi bhi ek topic: First Visualization', () {
    final s = const ProgressState(completedTopics: {'linear-search'});
    expect(earned(s), {'first-viz'});
  });

  test('binary-search complete: Binary Search Master', () {
    final s = const ProgressState(completedTopics: {'binary-search'});
    expect(earned(s), {'first-viz', 'binary-master'});
  });

  test('do sorts: Sorting Explorer nahi', () {
    final s = const ProgressState(
        completedTopics: {'bubble-sort', 'selection-sort'});
    expect(earned(s).contains('sorting-explorer'), isFalse);
  });

  test('teeno sorts: Sorting Explorer', () {
    final s = const ProgressState(
        completedTopics: {'bubble-sort', 'selection-sort', 'insertion-sort'});
    expect(earned(s).contains('sorting-explorer'), isTrue);
  });

  test('streak 6 nahi, 7 par 7 Day Streak', () {
    const s = ProgressState();
    expect(earned(s, streak: 6).contains('streak-7'), isFalse);
    expect(earned(s, streak: 7).contains('streak-7'), isTrue);
  });

  test('Contest Starter abhi hamesha locked', () {
    final s = const ProgressState(completedTopics: {'a', 'b', 'c'});
    expect(earned(s, streak: 30).contains('contest-starter'), isFalse);
  });
}