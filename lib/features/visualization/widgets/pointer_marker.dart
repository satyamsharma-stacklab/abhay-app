import 'package:flutter/material.dart';

/// Index ke upar chhota label, jaise LOW / MID / HIGH.
/// Naam ke saath arrow icon bhi hai, sirf colour par depend nahi.
class PointerMarker extends StatelessWidget {
  /// Ek index par ek se zyada pointer ho sakte hain.
  final List<String> names;

  const PointerMarker({super.key, required this.names});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final style = Theme.of(context).textTheme.labelSmall?.copyWith(
          color: scheme.primary,
          fontWeight: FontWeight.w800,
        );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final name in names)
          Text(name, key: Key('pointer-$name'), style: style),
        Icon(Icons.arrow_downward, size: 16, color: scheme.primary),
      ],
    );
  }
}