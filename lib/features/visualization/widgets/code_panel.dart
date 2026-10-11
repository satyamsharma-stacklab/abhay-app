import 'package:flutter/material.dart';

import '../../../core/constants/strings.dart';

/// Code ki lines dikhata hai, current line highlight hoti hai.
/// activeLine 0 se shuru (VisualizationStep.codeLine ke jaisa).
/// Highlight ke saath arrow icon bhi hai, sirf colour par depend nahi.
class CodePanel extends StatelessWidget {
  final List<String> lines;
  final int? activeLine;

  const CodePanel({super.key, required this.lines, this.activeLine});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context).textTheme;

    return Container(
      key: const Key('code-panel'),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 4),
            child: Text(
              AppStrings.codeTitle,
              style: theme.labelMedium?.copyWith(fontWeight: FontWeight.w800),
            ),
          ),
          for (var i = 0; i < lines.length; i++)
            _CodeLine(
              key: Key('code-line-$i'),
              number: i + 1,
              text: lines[i],
              isActive: i == activeLine,
            ),
        ],
      ),
    );
  }
}

class _CodeLine extends StatelessWidget {
  final int number;
  final String text;
  final bool isActive;

  const _CodeLine({
    super.key,
    required this.number,
    required this.text,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final style = TextStyle(
      fontFamily: 'monospace',
      fontSize: 13,
      fontWeight: isActive ? FontWeight.w800 : FontWeight.w400,
      color: isActive ? scheme.onPrimaryContainer : scheme.onSurface,
    );

    return Container(
      color: isActive ? scheme.primaryContainer : null,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
      child: Row(
        children: [
          SizedBox(
            width: 18,
            child: isActive
                ? Icon(Icons.arrow_right, size: 18, color: scheme.primary)
                : null,
          ),
          SizedBox(width: 24, child: Text('$number', style: style)),
          Expanded(child: Text(text, style: style)),
        ],
      ),
    );
  }
}