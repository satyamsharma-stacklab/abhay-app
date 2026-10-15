import 'package:flutter/material.dart';

import '../core/constants/strings.dart';
import '../features/progress/progress_controller.dart';
import '../features/progress/progress_scope.dart';
import 'routes.dart';
import 'theme.dart';

class AbhayApp extends StatefulWidget {
  const AbhayApp({super.key, required this.progress});

  /// Poore app ka progress (main.dart mein load hoke aata hai).
  final ProgressController progress;

  @override
  State<AbhayApp> createState() => _AbhayAppState();
}

class _AbhayAppState extends State<AbhayApp> {
  final ValueNotifier<ThemeMode> _themeMode = ValueNotifier<ThemeMode>(ThemeMode.dark);
  late final RouteFactory _onGenerateRoute = AppRoutes.generator(_themeMode);

  @override
  void dispose() {
    _themeMode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ProgressScope(
      controller: widget.progress,
      child: ValueListenableBuilder<ThemeMode>(
        valueListenable: _themeMode,
        builder: (context, mode, child) {
          return MaterialApp(
            title: AppStrings.appName,
            debugShowCheckedModeBanner: false,
            theme: buildAbhayTheme(Brightness.light),
            darkTheme: buildAbhayTheme(Brightness.dark),
            themeMode: mode,
            initialRoute: AppRoutes.shell,
            onGenerateRoute: _onGenerateRoute,
          );
        },
      ),
    );
  }
}