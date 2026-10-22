import 'package:flutter/widgets.dart';

import 'auth_controller.dart';

/// AuthController ko widget tree mein neeche tak pahunchata hai.
/// Login badalne par jo widget isse sunte hain wo apne aap rebuild hote hain.
class AuthScope extends InheritedNotifier<AuthController> {
  const AuthScope({
    super.key,
    required AuthController controller,
    required super.child,
  }) : super(notifier: controller);

  /// Scope na ho to null (purane tests aur chhote widgets ke liye).
  static AuthController? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<AuthScope>()
        ?.notifier;
  }

  /// Scope zaroori ho to (Login/Signup/Profile jaise asli screens).
  static AuthController of(BuildContext context) {
    final c = maybeOf(context);
    assert(c != null, 'AuthScope widget tree mein nahi mila');
    return c!;
  }
}