import 'package:flutter_test/flutter_test.dart';
import 'package:abhay/features/progress/progress_service.dart';
import 'package:abhay/features/progress/progress_state.dart';

/// Oct 2026 ka koi din, dopahar ke time ke saath.
DateTime d(int day) => DateTime(2026, 10, day, 10, 30);

void main() {
  const svc = ProgressService();
  const empty = ProgressState();

  test('pehli baar sahi: topic complete, 20 XP, streak 1', () {
    final s = svc.recordCorrect(empty, 'binary-search', d(15));
    expect(s.completedTopics, {'binary-search'});
    expect(s.xp, 20);
    expect(s.streak, 1);
    expect(s.lastActiveDate, DateTime(2026, 10, 15));
    expect(s.todayCorrect, 1);
  });

  test('usi din usi topic par dobara: XP nahi, streak same', () {
    var s = svc.recordCorrect(empty, 'a', d(15));
    s = svc.recordCorrect(s, 'a', d(15));
    expect(s.xp, 20);
    expect(s.streak, 1);
    expect(s.todayCorrect, 2);
  });

  test('agle din usi topic par dobara: +5 practice XP, streak 2', () {
    var s = svc.recordCorrect(empty, 'a', d(15));
    s = svc.recordCorrect(s, 'a', d(16));
    expect(s.xp, 25);
    expect(s.streak, 2);
    expect(s.todayCorrect, 1);
  });

  test('usi din doosra topic: dono ke 20-20 XP', () {
    var s = svc.recordCorrect(empty, 'a', d(15));
    s = svc.recordCorrect(s, 'b', d(15));
    expect(s.completedTopics, {'a', 'b'});
    expect(s.xp, 40);
    expect(s.streak, 1);
    expect(s.todayCorrect, 2);
  });

  test('din chhoot jaye to streak 1 se restart', () {
    var s = svc.recordCorrect(empty, 'a', d(15));
    s = svc.recordCorrect(s, 'a', d(17));
    expect(s.streak, 1);
    expect(s.xp, 25);
  });

  test('teen din lagatar: streak 3', () {
    var s = svc.recordCorrect(empty, 'a', d(15));
    s = svc.recordCorrect(s, 'b', d(16));
    s = svc.recordCorrect(s, 'c', d(17));
    expect(s.streak, 3);
    expect(s.xp, 60);
  });

  test('time ka farq nahi padta: 23:59 ke baad 00:01 agla din', () {
    var s = svc.recordCorrect(empty, 'a', DateTime(2026, 10, 15, 23, 59));
    s = svc.recordCorrect(s, 'b', DateTime(2026, 10, 16, 0, 1));
    expect(s.streak, 2);
  });

  test('mahine ki seema: 31 Oct ke baad 1 Nov agla din hai', () {
    var s = svc.recordCorrect(empty, 'a', DateTime(2026, 10, 31, 9));
    s = svc.recordCorrect(s, 'b', DateTime(2026, 11, 1, 9));
    expect(s.streak, 2);
  });

  test('purana state badalta nahi (immutable)', () {
    svc.recordCorrect(empty, 'a', d(15));
    expect(empty.xp, 0);
    expect(empty.completedTopics, isEmpty);
    expect(empty.streak, 0);
  });

  test('todayCorrectFor: usi din ginti, agle din 0, kabhi nahi to 0', () {
    final s = svc.recordCorrect(empty, 'a', d(15));
    expect(svc.todayCorrectFor(s, d(15)), 1);
    expect(svc.todayCorrectFor(s, d(16)), 0);
    expect(svc.todayCorrectFor(empty, d(15)), 0);
  });

  test('streakFor: 1 din ka gap theek, 2 din ka gap streak tod deta hai', () {
    var s = svc.recordCorrect(empty, 'a', d(13));
    s = svc.recordCorrect(s, 'b', d(14));
    s = svc.recordCorrect(s, 'c', d(15));
    expect(svc.streakFor(s, d(15)), 3);
    expect(svc.streakFor(s, d(16)), 3);
    expect(svc.streakFor(s, d(17)), 0);
    expect(svc.streakFor(empty, d(15)), 0);
  });

  test('dateOnly time hata deta hai', () {
    expect(
      ProgressService.dateOnly(DateTime(2026, 10, 15, 23, 59, 59)),
      DateTime(2026, 10, 15),
    );
  });

  test('daysBetween: usi din 0, mahine ki seema par 1, DST mein bhi sahi', () {
    expect(ProgressService.daysBetween(d(15), d(15)), 0);
    expect(
      ProgressService.daysBetween(DateTime(2026, 10, 31), DateTime(2026, 11, 1)),
      1,
    );
    expect(
      ProgressService.daysBetween(DateTime(2026, 3, 28), DateTime(2026, 3, 30)),
      2,
    );
  });

  test('XP ke constants 20 aur 5 hain', () {
    expect(ProgressService.firstCorrectXp, 20);
    expect(ProgressService.practiceXp, 5);
  });
}