import 'package:flutter/material.dart';

import '../core/constants/strings.dart';
import 'routes.dart';
import 'theme.dart';

class AbhayApp extends StatefulWidget {
  const AbhayApp({super.key});

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
    return ValueListenableBuilder<ThemeMode>(
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
    );
  }
}
