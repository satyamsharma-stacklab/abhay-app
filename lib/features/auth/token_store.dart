import 'package:shared_preferences/shared_preferences.dart';

/// Login token kahan save hota hai, uska chhota interface.
/// Abhi shared_preferences se, baad mein release se pehle
/// flutter_secure_storage se badal denge (sirf ek file badlegi).
abstract class TokenStore {
  Future<String?> read();
  Future<void> save(String token);
  Future<void> clear();
}

/// shared_preferences wala asli store.
class PrefsTokenStore implements TokenStore {
  PrefsTokenStore(this._prefs);

  final SharedPreferences _prefs;

  static const String _key = 'auth_token';

  @override
  Future<String?> read() async => _prefs.getString(_key);

  @override
  Future<void> save(String token) async {
    await _prefs.setString(_key, token);
  }

  @override
  Future<void> clear() async {
    await _prefs.remove(_key);
  }
}

/// Tests ke liye: sirf memory mein rakhta hai.
class MemoryTokenStore implements TokenStore {
  String? _token;

  @override
  Future<String?> read() async => _token;

  @override
  Future<void> save(String token) async {
    _token = token;
  }

  @override
  Future<void> clear() async {
    _token = null;
  }
}