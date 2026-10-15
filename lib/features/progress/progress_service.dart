import 'progress_state.dart';

/// Progress ka saara hisaab. Pure Dart: UI, storage ya DateTime.now() nahi.
/// Date hamesha bahar se aati hai, isliye same input -> same result.
class ProgressService {
  const ProgressService();

  /// Pehli baar checkpoint sahi hone par XP.
  static const int firstCorrectXp = 20;

  /// Completed topic par dobara sahi hone par (roz ek baar) XP.
  static const int practiceXp = 5;

  /// Time hata kar sirf date (local din) rakhta hai.
  static DateTime dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

  /// Do dates ke beech kitne din (DST se bachne ke liye UTC mein).
  static int daysBetween(DateTime from, DateTime to) {
    final a = DateTime.utc(from.year, from.month, from.day);
    final b = DateTime.utc(to.year, to.month, to.day);
    return b.difference(a).inDays;
  }

  /// Checkpoint SAHI hone par chalao. Galat jawab par ise bulana hi nahi hai
  /// (rule: rewards understanding ke liye, galat par XP nahi).
  ProgressState recordCorrect(
    ProgressState state,
    String topicId,
    DateTime now,
  ) {
    final today = dateOnly(now);
    final last = state.lastActiveDate;

    // 1) Din ka hisaab: streak aur aaj ke counters.
    var streak = state.streak;
    var todayCorrect = state.todayCorrect;
    var todayPracticed = state.todayPracticed;

    if (last == null) {
      streak = 1;
      todayCorrect = 0;
      todayPracticed = const {};
    } else {
      final gap = daysBetween(last, today);
      if (gap >= 1) {
        // Naya din: kal tha to streak badhao, warna 1 se restart.
        streak = gap == 1 ? streak + 1 : 1;
        todayCorrect = 0;
        todayPracticed = const {};
      }
      // gap == 0: usi din, streak same. (gap < 0 = ghadi peeche, kuch nahi badalta.)
    }

    // 2) XP aur topic complete.
    var xp = state.xp;
    final completed = {...state.completedTopics};

    if (!completed.contains(topicId)) {
      completed.add(topicId);
      xp += firstCorrectXp;
    } else if (!todayPracticed.contains(topicId)) {
      xp += practiceXp;
    }

    return state.copyWith(
      completedTopics: completed,
      xp: xp,
      streak: streak,
      lastActiveDate: today,
      todayCorrect: todayCorrect + 1,
      todayPracticed: {...todayPracticed, topicId},
    );
  }

  /// UI ke liye: aaj ke counters (agar din badal gaya ho to 0 dikhao).
  int todayCorrectFor(ProgressState state, DateTime now) {
    final last = state.lastActiveDate;
    if (last == null) return 0;
    return daysBetween(last, dateOnly(now)) == 0 ? state.todayCorrect : 0;
  }

  /// UI ke liye: streak abhi bhi zinda hai ya toot gayi (2+ din ka gap).
  int streakFor(ProgressState state, DateTime now) {
    final last = state.lastActiveDate;
    if (last == null) return 0;
    return daysBetween(last, dateOnly(now)) <= 1 ? state.streak : 0;
  }
}