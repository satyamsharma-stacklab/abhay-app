import 'package:flutter/material.dart';

enum AbhayButtonStyle { primary, secondary }

class AbhayButton extends StatelessWidget {
  const AbhayButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.style = AbhayButtonStyle.primary,
    this.expand = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final AbhayButtonStyle style;

  /// Poori width lene ke liye. Sirf Column ke andar use karo, Row mein nahi.
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final size = Size(expand ? double.infinity : 48, 48);
    final text = Text(label, textAlign: TextAlign.center);

    if (style == AbhayButtonStyle.secondary) {
      final s = OutlinedButton.styleFrom(minimumSize: size);
      return icon == null
          ? OutlinedButton(onPressed: onPressed, style: s, child: text)
          : OutlinedButton.icon(onPressed: onPressed, style: s, icon: Icon(icon), label: text);
    }

    final s = FilledButton.styleFrom(minimumSize: size);
    return icon == null
        ? FilledButton(onPressed: onPressed, style: s, child: text)
        : FilledButton.icon(onPressed: onPressed, style: s, icon: Icon(icon), label: text);
  }
}
