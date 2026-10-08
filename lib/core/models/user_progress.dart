class UserProgress {
  const UserProgress({
    required this.name,
    required this.xp,
    required this.streak,
    required this.dailyGoalDone,
    required this.dailyGoalTarget,
    required this.currentTopicId,
    this.weakTopics = const [],
  });

  final String name;
  final int xp;
  final int streak;
  final int dailyGoalDone;
  final int dailyGoalTarget;
  final String currentTopicId;
  final List<String> weakTopics;

  /// 0.0 se 1.0 ke beech.
  double get dailyGoalFraction {
    if (dailyGoalTarget <= 0) return 0;
    return (dailyGoalDone / dailyGoalTarget).clamp(0.0, 1.0).toDouble();
  }
}
