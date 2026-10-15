import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/app.dart';
import 'features/progress/progress_controller.dart';
import 'features/progress/progress_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final progress = ProgressController(
    repository: ProgressRepository(prefs),
  );
  runApp(AbhayApp(progress: progress));
}