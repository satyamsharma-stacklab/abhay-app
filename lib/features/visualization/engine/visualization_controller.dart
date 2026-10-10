import 'dart:async';

import 'visualization.dart';
import 'visualization_step.dart';

/// Visualization ko chalane wala controller.
/// Ye kisi bhi algorithm ko nahi jaanta, sirf steps ki list par chalta hai.
class VisualizationController {
  final Visualization visualization;

  /// Abhi kaunsa step dikh raha hai. -1 matlab "shuruaati state" (koi step shuru nahi hua).
  int _currentIndex = -1;

  /// Auto-play chal raha hai ya nahi.
  bool _isPlaying = false;

  /// Speed multiplier: 1.0 normal, 2.0 double fast, 0.5 aadha.
  double _speed = 1.0;

  Timer? _timer;

  /// UI ko batane ke liye: jab bhi kuch badle, ye function call hoga.
  void Function()? onChanged;

  /// Allowed speeds.
  static const double minSpeed = 0.25;
  static const double maxSpeed = 4.0;

  VisualizationController(this.visualization);

  // ---------- Getters (sirf padhne ke liye) ----------

  int get currentIndex => _currentIndex;
  int get totalSteps => visualization.steps.length;
  bool get isPlaying => _isPlaying;
  double get speed => _speed;

  /// Abhi ka step. Shuru mein null hota hai (initialState dikhana hai).
  VisualizationStep? get currentStep =>
      _currentIndex >= 0 ? visualization.steps[_currentIndex] : null;

  /// Aakhri step par pahunch gaye ya nahi (steps khali ho to bhi true).
  bool get isFinished =>
      visualization.steps.isEmpty || _currentIndex >= totalSteps - 1;

  bool get isAtStart => _currentIndex < 0;

  // ---------- Controls ----------

  /// Ek step aage. Aakhir mein ruk jata hai.
  void next() {
    if (isFinished) {
      _stopTimer();
      _notify();
      return;
    }
    _currentIndex++;
    if (isFinished) _stopTimer();
    _notify();
  }

  /// Ek step peeche. Shuru se peeche nahi jata.
  void previous() {
    _stopTimer();
    if (_currentIndex >= 0) _currentIndex--;
    _notify();
  }

  /// Auto-play shuru. Agar pehle se khatam ho chuka hai to restart karke chalata hai.
  void play() {
    if (visualization.steps.isEmpty) return;
    if (isFinished) _currentIndex = -1;
    _isPlaying = true;
    _scheduleNext();
    _notify();
  }

  /// Auto-play roko (current step wahi rehta hai).
  void pause() {
    _stopTimer();
    _notify();
  }

  /// Shuru se dobara.
  void restart() {
    _stopTimer();
    _currentIndex = -1;
    _notify();
  }

  /// Speed badlo. Min/max ke andar rakhta hai.
  void setSpeed(double value) {
    _speed = value.clamp(minSpeed, maxSpeed).toDouble();
    if (_isPlaying) {
      _timer?.cancel();
      _scheduleNext();
    }
    _notify();
  }

  /// Controller band karte waqt timer saaf karo.
  void dispose() {
    _timer?.cancel();
    _timer = null;
    _isPlaying = false;
    onChanged = null;
  }

  // ---------- Andar ke helpers ----------

  void _scheduleNext() {
    _timer?.cancel();
    // Jis step par abhi hain uski duration; shuru mein pehle step ki duration.
    final stepForDelay = currentStep ?? visualization.steps.first;
    final ms = (stepForDelay.durationMs / _speed).round();
    _timer = Timer(Duration(milliseconds: ms), () {
      next();
      if (!isFinished && _isPlaying) _scheduleNext();
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
    _isPlaying = false;
  }

  void _notify() => onChanged?.call();
}