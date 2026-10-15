import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:abhay/features/progress/progress_repository.dart';
import 'package:abhay/features/progress/progress_service.dart';
import 'package:abhay/features/progress/progress_state.dart';

Future<ProgressRepository> makeRepo([Map<String, Object> initial = const {}]) async {
  SharedPreferences.setMockInitialValues(initial);
  return ProgressRepository(await SharedPreferences.getInstance());
}

void main() {
  test('kuch save nahi hua to khali state milta hai', () async {
    final repo = await makeRepo();
    final s = repo.load();
    expect(s.completedTopics, isEmpty);
    expect(s.xp, 0);
    expect(s.streak, 0);
    expect(s.lastActiveDate, isNull);
    expect(s.todayCorrect, 0);
    expect(s.todayPracticed, isEmpty);
  });

  test('save ke baad load wahi state deta hai', () async {
    final repo = await makeRepo();
    final original = ProgressState(
      completedTopics: const {'binary-search', 'bubble-sort'},
      xp: 45,
      streak: 3,
      lastActiveDate: DateTime(2026, 10, 15),
      todayCorrect: 2,
      todayPracticed: const {'binary-search'},
    );
    await repo.save(original);
    final loaded = repo.load();
    expect(loaded.completedTopics, original.completedTopics);
    expect(loaded.xp, 45);
    expect(loaded.streak, 3);
    expect(loaded.lastActiveDate, DateTime(2026, 10, 15));
    expect(loaded.todayCorrect, 2);
    expect(loaded.todayPracticed, {'binary-search'});
  });

  test('naya repository bhi purana data padhta hai (app restart)', () async {
    final repo = await makeRepo();
    await repo.save(
      ProgressState(xp: 20, lastActiveDate: DateTime(2026, 10, 15)),
    );
    final again = ProgressRepository(await SharedPreferences.getInstance());
    expect(again.load().xp, 20);
  });

  test('date na ho to save karne par purani date hat jaati hai', () async {
    final repo = await makeRepo();
    await repo.save(ProgressState(lastActiveDate: DateTime(2026, 10, 15)));
    await repo.save(const ProgressState());
    expect(repo.load().lastActiveDate, isNull);
  });

  test('clear saara progress mita deta hai', () async {
    final repo = await makeRepo();
    await repo.save(const ProgressState(xp: 99, streak: 5));
    await repo.clear();
    final s = repo.load();
    expect(s.xp, 0);
    expect(s.streak, 0);
  });

  test('kharab date text par lastActiveDate null', () async {
    final repo = await makeRepo({'progress.lastActiveDate': 'kuch-bhi'});
    expect(repo.load().lastActiveDate, isNull);
  });

  test('formatDate: single digit mahina/din zero ke saath', () {
    expect(ProgressRepository.formatDate(DateTime(2026, 3, 5)), '2026-03-05');
    expect(
      ProgressRepository.formatDate(DateTime(2026, 10, 15)),
      '2026-10-15',
    );
  });

  test('parseDate: sahi, galat aur null', () {
    expect(ProgressRepository.parseDate('2026-10-15'), DateTime(2026, 10, 15));
    expect(ProgressRepository.parseDate(null), isNull);
    expect(ProgressRepository.parseDate('2026-13-01'), isNull);
    expect(ProgressRepository.parseDate('2026-10'), isNull);
    expect(ProgressRepository.parseDate('a-b-c'), isNull);
  });

  test('service + repository saath: save/load ke baad streak chalti rahe',
      () async {
    final repo = await makeRepo();
    const svc = ProgressService();
    var s = svc.recordCorrect(
      repo.load(),
      'binary-search',
      DateTime(2026, 10, 15, 9),
    );
    await repo.save(s);
    s = svc.recordCorrect(repo.load(), 'bubble-sort', DateTime(2026, 10, 16, 9));
    await repo.save(s);
    final loaded = repo.load();
    expect(loaded.streak, 2);
    expect(loaded.xp, 40);
    expect(loaded.completedTopics, {'binary-search', 'bubble-sort'});
  });
}