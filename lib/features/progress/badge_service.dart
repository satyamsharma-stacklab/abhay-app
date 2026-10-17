import '../../core/models/abhay_badge.dart';
import 'progress_state.dart';

/// Progress se badges nikalta hai. Pure Dart: UI ya storage nahi.
/// Badge sirf samajh (checkpoint sahi) aur lagatar seekhne par milte hain.
class BadgeService {
  const BadgeService();

  static const sortTopics = {'bubble-sort', 'selection-sort', 'insertion-sort'};
  static const streakTarget = 7;

  /// [streak] wo asli streak hai jo UI dikhati hai (toot gayi ho to 0).
  List<AbhayBadge> badgesFor(ProgressState state, {required int streak}) {
    final done = state.completedTopics;
    return [
      AbhayBadge(
        id: 'first-viz',
        title: 'First Visualization',
        description: 'Pehli visualization complete ki',
        earned: done.isNotEmpty,
      ),
      AbhayBadge(
        id: 'binary-master',
        title: 'Binary Search Master',
        description: 'Binary Search ka checkpoint pass karo',
        earned: done.contains('binary-search'),
      ),
      AbhayBadge(
        id: 'sorting-explorer',
        title: 'Sorting Explorer',
        description: 'Saari sorting visualizations complete karo',
        earned: sortTopics.every(done.contains),
      ),
      const AbhayBadge(
        id: 'contest-starter',
        title: 'Contest Starter',
        description: 'Pehla ABHAY contest join karo',
        earned: false,
      ),
      AbhayBadge(
        id: 'streak-7',
        title: '7 Day Streak',
        description: 'Lagatar 7 din seekho',
        earned: streak >= streakTarget,
      ),
    ];
  }
}