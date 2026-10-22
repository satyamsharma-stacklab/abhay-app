import 'package:flutter/material.dart';

import '../core/constants/strings.dart';
import '../features/auth/auth_controller.dart';
import '../features/auth/auth_scope.dart';
import '../features/progress/progress_controller.dart';
import '../features/progress/progress_scope.dart';
import 'routes.dart';
import 'theme.dart';

class AbhayApp extends StatefulWidget {
  const AbhayApp({super.key, required this.progress, this.auth});

  /// Poore app ka progress (main.dart mein load hoke aata hai).
  final ProgressController progress;

  /// Login state. Optional: purane tests bina login ke bhi app chalate hain.
  final AuthController? auth;

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
    final app = ProgressScope(
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

    final auth = widget.auth;
    if (auth == null) {
      return app;
    }
    return AuthScope(controller: auth, child: app);
  }
}