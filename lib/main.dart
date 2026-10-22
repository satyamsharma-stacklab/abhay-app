import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/app.dart';
import 'core/constants/api_config.dart';
import 'features/auth/api_client.dart';
import 'features/auth/auth_controller.dart';
import 'features/auth/auth_repository.dart';
import 'features/auth/token_store.dart';
import 'features/progress/progress_controller.dart';
import 'features/progress/progress_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final progress = ProgressController(
    repository: ProgressRepository(prefs),
  );

  // Login: server se baat karne wala client + token ka store.
  final auth = AuthController(
    repository: AuthRepository(
      api: ApiClient(baseUrl: ApiConfig.baseUrl),
      store: PrefsTokenStore(prefs),
    ),
  );

  runApp(AbhayApp(progress: progress, auth: auth));

  // App dikhne ke baad saved token se login bahaal karo (UI ko rokta nahi).
  auth.restore();
}