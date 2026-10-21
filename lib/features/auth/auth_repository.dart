// Private fields (_api, _store) ko named parameter se seedha nahi
// bhar sakte, isliye initializer list use hoti hai.
// ignore_for_file: prefer_initializing_formals

import 'api_client.dart';
import 'token_store.dart';

/// Login hua user (server ke "user" object se).
class AuthUser {
  const AuthUser({
    required this.id,
    required this.name,
    required this.email,
  });

  final String id;
  final String name;
  final String email;

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    return AuthUser(
      id: (json['id'] ?? '') as String,
      name: (json['name'] ?? '') as String,
      email: (json['email'] ?? '') as String,
    );
  }
}

/// Signup, login, logout ka nateeja. Galti hone par message Hinglish mein.
class AuthResult {
  const AuthResult.ok(this.user) : error = null;
  const AuthResult.fail(this.error) : user = null;

  final AuthUser? user;
  final String? error;

  bool get isOk => user != null;
}

/// Server se baat karke token save/hatata hai. Token kabhi print nahi hota.
class AuthRepository {
  AuthRepository({required ApiClient api, required TokenStore store})
      : _api = api,
        _store = store;

  final ApiClient _api;
  final TokenStore _store;

  static const String networkError =
      'Server tak nahi pahunch paaye. Internet check karo.';
  static const String genericError = 'Kuch gadbad hui. Dobara try karo.';

  Future<AuthResult> signup({
    required String name,
    required String email,
    required String password,
  }) {
    return _authenticate('/api/auth/signup', <String, dynamic>{
      'name': name,
      'email': email,
      'password': password,
    });
  }

  Future<AuthResult> login({
    required String email,
    required String password,
  }) {
    return _authenticate('/api/auth/login', <String, dynamic>{
      'email': email,
      'password': password,
    });
  }

  /// App khulne par: saved token se pata karta hai ki login bana hai ya nahi.
  /// Token kharab/expire ho to hata deta hai. Internet na ho to token
  /// rehne deta hai aur null deta hai (baad mein phir try hoga).
  Future<AuthUser?> restore() async {
    final token = await _store.read();
    if (token == null) {
      return null;
    }
    try {
      final res = await _api.get('/api/me', token: token);
      if (res.isOk) {
        return _userFrom(res.body);
      }
      if (res.status == 401) {
        await _store.clear();
      }
      return null;
    } on ApiNetworkException {
      return null;
    }
  }

  Future<void> logout() => _store.clear();

  Future<AuthResult> _authenticate(
    String path,
    Map<String, dynamic> body,
  ) async {
    try {
      final res = await _api.post(path, body: body);
      if (!res.isOk) {
        return AuthResult.fail(res.errorMessage ?? genericError);
      }
      final token = res.body['token'];
      final user = _userFrom(res.body);
      if (token is! String || user == null) {
        return const AuthResult.fail(genericError);
      }
      await _store.save(token);
      return AuthResult.ok(user);
    } on ApiNetworkException {
      return const AuthResult.fail(networkError);
    }
  }

  AuthUser? _userFrom(Map<String, dynamic> body) {
    final raw = body['user'];
    return raw is Map<String, dynamic> ? AuthUser.fromJson(raw) : null;
  }
}