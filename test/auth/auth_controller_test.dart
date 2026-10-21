import 'dart:convert';

import 'package:abhay/features/auth/api_client.dart';
import 'package:abhay/features/auth/auth_controller.dart';
import 'package:abhay/features/auth/auth_repository.dart';
import 'package:abhay/features/auth/token_store.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

// Nakli server: handler jawab deta hai. Handler exception phenke to
// wo "internet nahi" jaisa kaam karta hai.
AuthController makeController(
  http.Response Function(http.Request) handler,
  TokenStore store, {
  List<http.Request>? seen,
}) {
  final mock = MockClient((request) async {
    seen?.add(request);
    return handler(request);
  });
  final api = ApiClient(baseUrl: 'http://test', client: mock);
  return AuthController(
    repository: AuthRepository(api: api, store: store),
  );
}

http.Response reply(int status, Object body) {
  return http.Response(
    jsonEncode(body),
    status,
    headers: <String, String>{'content-type': 'application/json'},
  );
}

const Map<String, dynamic> _userJson = <String, dynamic>{
  'id': 'u1',
  'name': 'Abhay',
  'email': 'abhay@example.com',
};

http.Response okLogin(http.Request _) {
  return reply(200, <String, dynamic>{'user': _userJson, 'token': 'tok123'});
}

void main() {
  late MemoryTokenStore store;

  setUp(() {
    store = MemoryTokenStore();
  });

  group('AuthController', () {
    test('shuru mein status unknown hai, user nahi, galti nahi', () {
      final c = makeController(okLogin, store);

      expect(c.status, AuthStatus.unknown);
      expect(c.user, isNull);
      expect(c.error, isNull);
      expect(c.busy, isFalse);
      expect(c.isLoggedIn, isFalse);
    });

    test('restore: saved token nahi to loggedOut', () async {
      final c = makeController(okLogin, store);

      await c.restore();

      expect(c.status, AuthStatus.loggedOut);
      expect(c.user, isNull);
    });

    test('restore: valid token to loggedIn aur user mil jaata hai', () async {
      await store.save('tok123');
      final c = makeController(
        (_) => reply(200, <String, dynamic>{'user': _userJson}),
        store,
      );

      await c.restore();

      expect(c.status, AuthStatus.loggedIn);
      expect(c.isLoggedIn, isTrue);
      expect(c.user!.email, 'abhay@example.com');
    });

    test('restore: token expire (401) to loggedOut aur token hat jaata hai',
        () async {
      await store.save('purana');
      final c = makeController(
        (_) => reply(401, <String, dynamic>{'error': 'Token galat hai'}),
        store,
      );

      await c.restore();

      expect(c.status, AuthStatus.loggedOut);
      expect(await store.read(), isNull);
    });

    test('login ok: true milta hai, loggedIn, token save', () async {
      final c = makeController(okLogin, store);

      final ok =
          await c.login(email: 'abhay@example.com', password: 'secret123');

      expect(ok, isTrue);
      expect(c.status, AuthStatus.loggedIn);
      expect(c.user!.name, 'Abhay');
      expect(c.error, isNull);
      expect(c.busy, isFalse);
      expect(await store.read(), 'tok123');
    });

    test('signup ok: true milta hai, loggedIn, token save', () async {
      final c = makeController(
        (_) => reply(201, <String, dynamic>{
          'user': _userJson,
          'token': 'tok789',
        }),
        store,
      );

      final ok = await c.signup(
        name: 'Abhay',
        email: 'abhay@example.com',
        password: 'secret123',
      );

      expect(ok, isTrue);
      expect(c.isLoggedIn, isTrue);
      expect(await store.read(), 'tok789');
    });

    test('login galat password: false, error mein message, loggedIn nahi',
        () async {
      final c = makeController(
        (_) => reply(401, <String, dynamic>{
          'error': 'Email ya password galat hai',
        }),
        store,
      );

      final ok = await c.login(email: 'abhay@example.com', password: 'galat');

      expect(ok, isFalse);
      expect(c.error, 'Email ya password galat hai');
      expect(c.isLoggedIn, isFalse);
      expect(c.busy, isFalse);
      expect(await store.read(), isNull);
    });

    test('login network error: networkError message milta hai', () async {
      final c = makeController(
        (_) => throw http.ClientException('internet nahi'),
        store,
      );

      final ok =
          await c.login(email: 'abhay@example.com', password: 'secret123');

      expect(ok, isFalse);
      expect(c.error, AuthRepository.networkError);
    });

    test('clearError: galti hat jaati hai aur UI ko khabar milti hai',
        () async {
      final c = makeController(
        (_) => reply(401, <String, dynamic>{'error': 'Email ya password galat hai'}),
        store,
      );
      await c.login(email: 'abhay@example.com', password: 'galat');
      var notified = 0;
      c.addListener(() => notified++);

      c.clearError();

      expect(c.error, isNull);
      expect(notified, 1);
    });

    test('clearError: galti na ho to UI ko khabar nahi jaati', () {
      final c = makeController(okLogin, store);
      var notified = 0;
      c.addListener(() => notified++);

      c.clearError();

      expect(notified, 0);
    });

    test('login ke dauraan busy true, khatam hone par false', () async {
      final c = makeController(okLogin, store);
      final busySeen = <bool>[];
      c.addListener(() => busySeen.add(c.busy));

      await c.login(email: 'abhay@example.com', password: 'secret123');

      expect(busySeen, <bool>[true, false]);
    });

    test('double tap: dusri login call ignore hoti hai, request ek hi jaati',
        () async {
      final seen = <http.Request>[];
      final c = makeController(okLogin, store, seen: seen);

      final first =
          c.login(email: 'abhay@example.com', password: 'secret123');
      final second =
          c.login(email: 'abhay@example.com', password: 'secret123');

      expect(await second, isFalse);
      expect(await first, isTrue);
      expect(seen.length, 1);
    });

    test('logout: loggedOut, user None, token hat jaata hai', () async {
      final c = makeController(okLogin, store);
      await c.login(email: 'abhay@example.com', password: 'secret123');

      await c.logout();

      expect(c.status, AuthStatus.loggedOut);
      expect(c.user, isNull);
      expect(c.error, isNull);
      expect(await store.read(), isNull);
    });
  });
}