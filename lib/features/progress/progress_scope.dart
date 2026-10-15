import 'package:flutter/widgets.dart';

import 'progress_controller.dart';

/// ProgressController ko widget tree mein neeche tak pahunchata hai.
/// Controller badalne par jo widget isse sunte hain wo apne aap rebuild hote hain.
class ProgressScope extends InheritedNotifier<ProgressController> {
  const ProgressScope({
    super.key,
    required ProgressController controller,
    required super.child,
  }) : super(notifier: controller);

  /// Scope na ho to null (purane tests aur chhote widgets ke liye).
  static ProgressController? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<ProgressScope>()
        ?.notifier;
  }

  /// Scope zaroori ho to (Home/Profile jaise asli screens).
  static ProgressController of(BuildContext context) {
    final c = maybeOf(context);
    assert(c != null, 'ProgressScope widget tree mein nahi mila');
    return c!;
  }
}