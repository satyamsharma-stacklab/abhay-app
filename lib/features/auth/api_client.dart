import 'dart:convert';

import 'package:http/http.dart' as http;

/// Server ne jo jawab diya: status code aur JSON body.
class ApiResponse {
  const ApiResponse(this.status, this.body);

  final int status;
  final Map<String, dynamic> body;

  bool get isOk => status >= 200 && status < 300;

  /// Server ka error message (jaise "Email ya password galat hai").
  String? get errorMessage {
    final e = body['error'];
    return e is String ? e : null;
  }
}

/// Internet na ho ya server tak pahunch na paye to ye error aata hai.
class ApiNetworkException implements Exception {
  const ApiNetworkException();
}

/// Backend se baat karne wala chhota client. http.Client bahar se aata hai,
/// taaki tests mein nakli client diya ja sake (asli internet nahi chahiye).
class ApiClient {
  ApiClient({
    required this.baseUrl,
    http.Client? client,
    this.timeout = const Duration(seconds: 15),
  }) : _client = client ?? http.Client();

  final String baseUrl;
  final Duration timeout;
  final http.Client _client;

  Future<ApiResponse> get(String path, {String? token}) {
    return _send(() => _client.get(_uri(path), headers: _headers(token)));
  }

  Future<ApiResponse> post(
    String path, {
    Map<String, dynamic>? body,
    String? token,
  }) {
    return _send(
      () => _client.post(
        _uri(path),
        headers: _headers(token),
        body: jsonEncode(body ?? <String, dynamic>{}),
      ),
    );
  }

  Uri _uri(String path) => Uri.parse('$baseUrl$path');

  Map<String, String> _headers(String? token) {
    return <String, String>{
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // Request bhejta hai, jawab ko ApiResponse mein badalta hai.
  // Network ya timeout ka masla ho to ApiNetworkException.
  Future<ApiResponse> _send(Future<http.Response> Function() request) async {
    try {
      final res = await request().timeout(timeout);
      return ApiResponse(res.statusCode, _decode(res.body));
    } on Exception {
      throw const ApiNetworkException();
    }
  }

  // Body JSON object na ho (ya khali ho) to khali map, crash nahi.
  Map<String, dynamic> _decode(String text) {
    try {
      final data = jsonDecode(text);
      return data is Map<String, dynamic> ? data : <String, dynamic>{};
    } on FormatException {
      return <String, dynamic>{};
    }
  }
}