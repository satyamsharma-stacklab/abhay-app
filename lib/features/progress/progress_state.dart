/// Student ka poora progress ek jagah. Immutable: badalna ho to copyWith.
/// Sirf data rakhta hai, koi logic nahi (logic ProgressService mein hai).
class ProgressState {
  /// Jin topics ka checkpoint kabhi sahi hua (topic id, jaise 'binary-search').
  final Set<String> completedTopics;

  /// Kul XP.
  final int xp;

  /// Lagatar din jin mein kam se kam ek checkpoint sahi hua.
  final int streak;

  /// Aakhri din jab koi checkpoint sahi hua (sirf date, time nahi). Null = kabhi nahi.
  final DateTime? lastActiveDate;

  /// Aaj kitne checkpoints sahi hue (daily goal ke liye).
  final int todayCorrect;

  /// Aaj kin topics par practice XP mil chuka (roz ek topic par ek baar).
  final Set<String> todayPracticed;

  const ProgressState({
    this.completedTopics = const {},
    this.xp = 0,
    this.streak = 0,
    this.lastActiveDate,
    this.todayCorrect = 0,
    this.todayPracticed = const {},
  });

  ProgressState copyWith({
    Set<String>? completedTopics,
    int? xp,
    int? streak,
    DateTime? lastActiveDate,
    int? todayCorrect,
    Set<String>? todayPracticed,
  }) {
    return ProgressState(
      completedTopics: completedTopics ?? this.completedTopics,
      xp: xp ?? this.xp,
      streak: streak ?? this.streak,
      lastActiveDate: lastActiveDate ?? this.lastActiveDate,
      todayCorrect: todayCorrect ?? this.todayCorrect,
      todayPracticed: todayPracticed ?? this.todayPracticed,
    );
  }
}