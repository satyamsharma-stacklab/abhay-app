import 'package:flutter/foundation.dart';

import 'progress_repository.dart';
import 'progress_service.dart';
import 'progress_state.dart';

/// App ka ek hi progress state. UI isse sunti hai, checkpoint sahi hone par
/// recordCorrect bulata hai. Galat jawab par ise bulana hi nahi hai.
class ProgressController extends ChangeNotifier {
  final ProgressRepository _repo;
  final ProgressService _service;

  /// Abhi ka time bahar se aata hai, taaki test mein fix kar sakein.
  final DateTime Function() _now;

  ProgressState _state;

    ProgressController({
    required ProgressRepository repository,
    this._service = const ProgressService(),
    DateTime Function()? now,
  })  : _repo = repository,
        _now = now ?? DateTime.now,
        _state = repository.load();

  ProgressState get state => _state;

  /// Home par dikhane ke liye: din badalne par purani streak nahi dikhti.
  int get streak => _service.streakFor(_state, _now());

  /// Aaj ke sahi checkpoints (daily goal ke liye).
  int get todayCorrect => _service.todayCorrectFor(_state, _now());

  bool isCompleted(String topicId) =>
      _state.completedTopics.contains(topicId);

  /// Checkpoint SAHI hone par. Pehle UI update, phir save.
  Future<void> recordCorrect(String topicId) async {
    _state = _service.recordCorrect(_state, topicId, _now());
    notifyListeners();
    await _repo.save(_state);
  }

  /// Saara progress mita do.
  Future<void> reset() async {
    _state = const ProgressState();
    notifyListeners();
    await _repo.clear();
  }
}
