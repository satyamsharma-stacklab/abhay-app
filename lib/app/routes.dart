import 'package:flutter/material.dart';

import 'shell.dart';

class AppRoutes {
  AppRoutes._();

  static const shell = '/';

  static RouteFactory generator(ValueNotifier<ThemeMode> themeMode) {
    return (RouteSettings settings) {
      switch (settings.name) {
        case shell:
          return MaterialPageRoute<void>(
            settings: settings,
            builder: (_) => AbhayShell(themeMode: themeMode),
          );
        default:
          return MaterialPageRoute<void>(
            settings: settings,
            builder: (_) => _NotFoundPage(routeName: settings.name),
          );
      }
    };
  }
}

class _NotFoundPage extends StatelessWidget {
  const _NotFoundPage({this.routeName});

  final String? routeName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Page nahi mila')),
      body: Center(child: Text('Ye route exist nahi karta: ${routeName ?? '-'}')),
    );
  }
}
