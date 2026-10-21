import 'package:flutter/foundation.dart';

import 'auth_repository.dart';

/// App ki login halat.
/// unknown: abhi saved token check ho raha hai (app abhi khula hai).
enum AuthStatus { unknown, loggedOut, loggedIn }

/// App ka ek hi login state. UI isse sunti hai.
/// Screens signup/login/logout isi se bulati hain.
class AuthController extends ChangeNotifier {
  AuthController({required AuthRepository repository}) : _repo = repository;

  final AuthRepository _repo;

  AuthStatus _status = AuthStatus.unknown;
  AuthUser? _user;
  String? _error;
  bool _busy = false;

  AuthStatus get status => _status;
  AuthUser? get user => _user;

  /// Aakhri galti ka Hinglish message (null = koi galti nahi).
  String? get error => _error;

  /// Signup/login chal raha hai (button disable karne ke liye).
  bool get busy => _busy;

  bool get isLoggedIn => _status == AuthStatus.loggedIn;

  /// App khulne par ek baar: saved token se login bahaal karo.
  Future<void> restore() async {
    final user = await _repo.restore();
    _user = user;
    _status = user == null ? AuthStatus.loggedOut : AuthStatus.loggedIn;
    notifyListeners();
  }

  /// true = ho gaya. false = nahi hua, wajah error mein hai.
  Future<bool> signup({
    required String name,
    required String email,
    required String password,
  }) {
    return _run(
      () => _repo.signup(name: name, email: email, password: password),
    );
  }

  Future<bool> login({
    required String email,
    required String password,
  }) {
    return _run(() => _repo.login(email: email, password: password));
  }

  Future<void> logout() async {
    await _repo.logout();
    _user = null;
    _error = null;
    _status = AuthStatus.loggedOut;
    notifyListeners();
  }

  /// Screen se galti hatane ke liye (jaise user dobara type kare).
  void clearError() {
    if (_error == null) {
      return;
    }
    _error = null;
    notifyListeners();
  }

  // Signup/login ka common kaam. Pehle se chal raha ho to dusri baar
  // (double tap) ignore.
  Future<bool> _run(Future<AuthResult> Function() action) async {
    if (_busy) {
      return false;
    }
    _busy = true;
    _error = null;
    notifyListeners();

    final result = await action();

    _busy = false;
    if (result.isOk) {
      _user = result.user;
      _status = AuthStatus.loggedIn;
    } else {
      _error = result.error;
    }
    notifyListeners();
    return result.isOk;
  }
}