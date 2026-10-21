import 'package:flutter/foundation.dart';

/// Backend ka address. Poore app mein sirf yahin likha jata hai.
class ApiConfig {
  const ApiConfig._();

  /// Android emulator mein "localhost" emulator khud hota hai,
  /// computer nahi. Computer tak pahunchne ke liye 10.0.2.2 chahiye.
  static const String _androidEmulatorHost = 'http://10.0.2.2:3000';

  /// Chrome (web) aur baaki jagah computer ka apna localhost.
  static const String _localHost = 'http://localhost:3000';

  /// Asli base address. Release mein baad mein deployed server aayega.
  static String get baseUrl {
    if (kIsWeb) {
      return _localHost;
    }
    if (defaultTargetPlatform == TargetPlatform.android) {
      return _androidEmulatorHost;
    }
    return _localHost;
  }
}