import 'dart:convert';

import 'package:abhay/features/auth/api_client.dart';
import 'package:abhay/features/auth/auth_repository.dart';
import 'package:abhay/features/auth/token_store.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

// Nakli server: har request record hoti hai, handler jawab deta hai.
// Handler exception phenke to wo "internet nahi" jaisa kaam karta hai.
ApiClient makeClient(
  http.Response Function(http.Request) handler, {
  List<http.Request>? seen,
}) {
  final mock = MockClient((request) async {
    seen?.add(request);
    return handler(request);
  });
  return ApiClient(baseUrl: 'http://test', client: mock);
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

void main() {
  late MemoryTokenStore store;

  setUp(() {
    store = MemoryTokenStore();
  });

  group('AuthRepository signup/login', () {
    test('signup ok: user milta hai, token save hota hai, sahi request jaati hai',
        () async {
      final seen = <http.Request>[];
      final repo = AuthRepository(
        api: makeClient(
          (_) => reply(201, <String, dynamic>{
            'user': _userJson,
            'token': 'tok123',
          }),
          seen: seen,
        ),
        store: store,
      );

      final result = await repo.signup(
        name: 'Abhay',
        email: 'abhay@example.com',
        password: 'secret123',
      );

      expect(result.isOk, isTrue);
      expect(result.user!.name, 'Abhay');
      expect(result.user!.email, 'abhay@example.com');
      expect(await store.read(), 'tok123');
      expect(seen.single.method, 'POST');
      expect(seen.single.url.path, '/api/auth/signup');
      final sent = jsonDecode(seen.single.body) as Map<String, dynamic>;
      expect(sent['name'], 'Abhay');
      expect(sent['email'], 'abhay@example.com');
      expect(sent['password'], 'secret123');
    });

    test('login ok: token save hota hai', () async {
      final seen = <http.Request>[];
      final repo = AuthRepository(
        api: makeClient(
          (_) => reply(200, <String, dynamic>{
            'user': _userJson,
            'token': 'tok456',
          }),
          seen: seen,
        ),
        store: store,
      );

      final result =
          await repo.login(email: 'abhay@example.com', password: 'secret123');

      expect(result.isOk, isTrue);
      expect(await store.read(), 'tok456');
      expect(seen.single.url.path, '/api/auth/login');
    });

    test('login 401: server ka Hinglish message milta hai, token save nahi hota',
        () async {
      final repo = AuthRepository(
        api: makeClient(
          (_) => reply(401, <String, dynamic>{
            'error': 'Email ya password galat hai',
          }),
        ),
        store: store,
      );

      final result =
          await repo.login(email: 'abhay@example.com', password: 'galat');

      expect(result.isOk, isFalse);
      expect(result.error, 'Email ya password galat hai');
      expect(await store.read(), isNull);
    });

    test('error mein message na ho to genericError milta hai', () async {
      final repo = AuthRepository(
        api: makeClient((_) => reply(500, <String, dynamic>{})),
        store: store,
      );

      final result =
          await repo.login(email: 'abhay@example.com', password: 'secret123');

      expect(result.isOk, isFalse);
      expect(result.error, AuthRepository.genericError);
      expect(await store.read(), isNull);
    });

    test('network error: networkError message milta hai, token save nahi hota',
        () async {
      final repo = AuthRepository(
        api: makeClient((_) => throw http.ClientException('internet nahi')),
        store: store,
      );

      final result =
          await repo.login(email: 'abhay@example.com', password: 'secret123');

      expect(result.isOk, isFalse);
      expect(result.error, AuthRepository.networkError);
      expect(await store.read(), isNull);
    });

    test('success jawab mein token na ho to genericError, token save nahi',
        () async {
      final repo = AuthRepository(
        api: makeClient(
          (_) => reply(200, <String, dynamic>{'user': _userJson}),
        ),
        store: store,
      );

      final result =
          await repo.login(email: 'abhay@example.com', password: 'secret123');

      expect(result.isOk, isFalse);
      expect(result.error, AuthRepository.genericError);
      expect(await store.read(), isNull);
    });
  });

  group('AuthRepository restore/logout', () {
    test('saved token nahi hai: null milta hai, server ko request nahi jaati',
        () async {
      final seen = <http.Request>[];
      final repo = AuthRepository(
        api: makeClient((_) => reply(200, <String, dynamic>{}), seen: seen),
        store: store,
      );

      expect(await repo.restore(), isNull);
      expect(seen, isEmpty);
    });

    test('valid token: user milta hai, Bearer header jaata hai', () async {
      await store.save('tok123');
      final seen = <http.Request>[];
      final repo = AuthRepository(
        api: makeClient(
          (_) => reply(200, <String, dynamic>{'user': _userJson}),
          seen: seen,
        ),
        store: store,
      );

      final user = await repo.restore();

      expect(user, isNotNull);
      expect(user!.email, 'abhay@example.com');
      expect(seen.single.method, 'GET');
      expect(seen.single.url.path, '/api/me');
      expect(seen.single.headers['Authorization'], 'Bearer tok123');
      expect(await store.read(), 'tok123');
    });

    test('token expire (401): null milta hai aur token hat jaata hai',
        () async {
      await store.save('purana');
      final repo = AuthRepository(
        api: makeClient(
          (_) => reply(401, <String, dynamic>{'error': 'Token galat hai'}),
        ),
        store: store,
      );

      expect(await repo.restore(), isNull);
      expect(await store.read(), isNull);
    });

    test('internet nahi: null milta hai, lekin token rehta hai', () async {
      await store.save('tok123');
      final repo = AuthRepository(
        api: makeClient((_) => throw http.ClientException('internet nahi')),
        store: store,
      );

      expect(await repo.restore(), isNull);
      expect(await store.read(), 'tok123');
    });

    test('server 500: null milta hai, lekin token rehta hai', () async {
      await store.save('tok123');
      final repo = AuthRepository(
        api: makeClient((_) => reply(500, <String, dynamic>{})),
        store: store,
      );

      expect(await repo.restore(), isNull);
      expect(await store.read(), 'tok123');
    });

    test('logout: token hat jaata hai', () async {
      await store.save('tok123');
      final repo = AuthRepository(
        api: makeClient((_) => reply(200, <String, dynamic>{})),
        store: store,
      );

      await repo.logout();

      expect(await store.read(), isNull);
    });
  });
}