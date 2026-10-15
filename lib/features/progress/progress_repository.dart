import 'package:shared_preferences/shared_preferences.dart';

import 'progress_state.dart';

/// ProgressState ko phone mein save/load karta hai.
/// SharedPreferences bahar se aata hai, isliye test mein mock chalta hai.
class ProgressRepository {
  final SharedPreferences _prefs;

  ProgressRepository(this._prefs);

  static const _kCompleted = 'progress.completedTopics';
  static const _kXp = 'progress.xp';
  static const _kStreak = 'progress.streak';
  static const _kLastActive = 'progress.lastActiveDate';
  static const _kTodayCorrect = 'progress.todayCorrect';
  static const _kTodayPracticed = 'progress.todayPracticed';

  /// Save kiya hua progress padho. Kuch na mile ya kharab ho to khali state.
  ProgressState load() {
    return ProgressState(
      completedTopics: (_prefs.getStringList(_kCompleted) ?? const []).toSet(),
      xp: _prefs.getInt(_kXp) ?? 0,
      streak: _prefs.getInt(_kStreak) ?? 0,
      lastActiveDate: parseDate(_prefs.getString(_kLastActive)),
      todayCorrect: _prefs.getInt(_kTodayCorrect) ?? 0,
      todayPracticed:
          (_prefs.getStringList(_kTodayPracticed) ?? const []).toSet(),
    );
  }

  /// Poora state save karo. Date na ho to purani key hata do.
  Future<void> save(ProgressState s) async {
    await _prefs.setStringList(_kCompleted, s.completedTopics.toList()..sort());
    await _prefs.setInt(_kXp, s.xp);
    await _prefs.setInt(_kStreak, s.streak);
    await _prefs.setInt(_kTodayCorrect, s.todayCorrect);
    await _prefs.setStringList(
      _kTodayPracticed,
      s.todayPracticed.toList()..sort(),
    );
    final d = s.lastActiveDate;
    if (d == null) {
      await _prefs.remove(_kLastActive);
    } else {
      await _prefs.setString(_kLastActive, formatDate(d));
    }
  }

  /// Saara progress mita do (reset ya logout ke liye).
  Future<void> clear() async {
    for (final k in [
      _kCompleted,
      _kXp,
      _kStreak,
      _kLastActive,
      _kTodayCorrect,
      _kTodayPracticed,
    ]) {
      await _prefs.remove(k);
    }
  }

  /// DateTime -> '2026-10-15'.
  static String formatDate(DateTime d) {
    final m = d.month.toString().padLeft(2, '0');
    final day = d.day.toString().padLeft(2, '0');
    return '${d.year}-$m-$day';
  }

  /// '2026-10-15' -> DateTime(2026, 10, 15). Galat text par null.
  static DateTime? parseDate(String? text) {
    if (text == null) return null;
    final parts = text.split('-');
    if (parts.length != 3) return null;
    final y = int.tryParse(parts[0]);
    final m = int.tryParse(parts[1]);
    final d = int.tryParse(parts[2]);
    if (y == null || m == null || d == null) return null;
    if (m < 1 || m > 12 || d < 1 || d > 31) return null;
    return DateTime(y, m, d);
  }
}