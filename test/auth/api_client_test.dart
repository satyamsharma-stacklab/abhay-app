import 'dart:convert';

import 'package:abhay/features/auth/api_client.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

// Nakli server: jo bhi request aaye, har baar ek jawab dekar record karta hai.
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

http.Response json(int status, Object body) {
  return http.Response(
    jsonEncode(body),
    status,
    headers: <String, String>{'content-type': 'application/json'},
  );
}

void main() {
  group('ApiClient', () {
    test('post: sahi address, JSON body aur header jaate hain', () async {
      final seen = <http.Request>[];
      final client = makeClient((r) => json(200, <String, dynamic>{}),
          seen: seen);
      await client.post('/api/auth/login', body: <String, dynamic>{'a': 1});
      expect(seen.single.method, 'POST');
      expect(seen.single.url.toString(), 'http://test/api/auth/login');
      expect(jsonDecode(seen.single.body), <String, dynamic>{'a': 1});
      expect(seen.single.headers['Content-Type'], contains('application/json'));
    });

    test('token diya ho to Bearer header lagta hai', () async {
      final seen = <http.Request>[];
      final client = makeClient((r) => json(200, <String, dynamic>{}),
          seen: seen);
      await client.get('/api/me', token: 'abc123');
      expect(seen.single.headers['Authorization'], 'Bearer abc123');
    });

    test('token na ho to Authorization header nahi jaata', () async {
      final seen = <http.Request>[];
      final client = makeClient((r) => json(200, <String, dynamic>{}),
          seen: seen);
      await client.get('/health');
      expect(seen.single.headers.containsKey('Authorization'), isFalse);
    });

    test('200 par isOk true aur body milti hai', () async {
      final client = makeClient(
        (r) => json(200, <String, dynamic>{'status': 'ok'}),
      );
      final res = await client.get('/health');
      expect(res.isOk, isTrue);
      expect(res.body['status'], 'ok');
    });

    test('401 par isOk false aur server ka error message milta hai', () async {
      final client = makeClient(
        (r) => json(401, <String, dynamic>{'error': 'Email ya password galat'}),
      );
      final res = await client.post('/api/auth/login');
      expect(res.isOk, isFalse);
      expect(res.status, 401);
      expect(res.errorMessage, 'Email ya password galat');
    });

    test('kharab JSON par crash nahi, khali body milti hai', () async {
      final client = makeClient((r) => http.Response('yeh json nahi', 500));
      final res = await client.get('/api/topics');
      expect(res.status, 500);
      expect(res.body, isEmpty);
      expect(res.errorMessage, isNull);
    });

    test('JSON array (object nahi) par bhi khali body', () async {
      final client = makeClient((r) => json(200, <int>[1, 2, 3]));
      final res = await client.get('/x');
      expect(res.body, isEmpty);
    });

    test('network fail par ApiNetworkException', () async {
      final mock = MockClient((r) async => throw http.ClientException('down'));
      final client = ApiClient(baseUrl: 'http://test', client: mock);
      expect(
        () => client.get('/health'),
        throwsA(isA<ApiNetworkException>()),
      );
    });

    test('timeout par ApiNetworkException', () async {
      final mock = MockClient((r) async {
        await Future<void>.delayed(const Duration(milliseconds: 200));
        return json(200, <String, dynamic>{});
      });
      final client = ApiClient(
        baseUrl: 'http://test',
        client: mock,
        timeout: const Duration(milliseconds: 20),
      );
      expect(
        () => client.get('/health'),
        throwsA(isA<ApiNetworkException>()),
      );
    });
  });
}