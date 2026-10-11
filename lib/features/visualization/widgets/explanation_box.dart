import 'package:flutter/material.dart';

import '../../../core/constants/strings.dart';

/// Current step ka Hinglish explanation dikhata hai.
/// text null ho to shuruaati message dikhata hai.
class ExplanationBox extends StatelessWidget {
  final String? text;

  const ExplanationBox({super.key, this.text});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context).textTheme;

    return Container(
      key: const Key('explanation-box'),
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: scheme.secondaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.lightbulb_outline, color: scheme.onSecondaryContainer),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.explainTitle,
                  style: theme.labelMedium?.copyWith(
                    color: scheme.onSecondaryContainer,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  text ?? AppStrings.explainEmpty,
                  key: const Key('explanation-text'),
                  style: theme.bodyLarge
                      ?.copyWith(color: scheme.onSecondaryContainer),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}