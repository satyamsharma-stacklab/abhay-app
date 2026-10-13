import 'package:flutter/material.dart';

import '../../../core/constants/strings.dart';
import '../engine/checkpoint.dart';

/// Ek checkpoint sawaal: options, jawab, feedback.
/// Sahi/galat dono par icon + text hai, sirf colour nahi.
/// Har algorithm ka page isi card ko reuse karta hai.
class CheckpointCard extends StatefulWidget {
  final Checkpoint checkpoint;

  const CheckpointCard({super.key, required this.checkpoint});

  @override
  State<CheckpointCard> createState() => _CheckpointCardState();
}

class _CheckpointCardState extends State<CheckpointCard> {
  int? _selected;
  bool? _result;

  void _submit() {
    final s = _selected;
    if (s == null) return;
    setState(() => _result = widget.checkpoint.isCorrect(s));
  }

  @override
  Widget build(BuildContext context) {
    final cp = widget.checkpoint;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Card(
      key: const Key('checkpoint-card'),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.cpTitle,
              style: theme.textTheme.labelLarge
                  ?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            Text(cp.question, style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            RadioGroup<int>(
              groupValue: _selected,
              onChanged: (v) {
                if (_result == null) setState(() => _selected = v);
              },
              child: Column(
                children: [
                  for (var i = 0; i < cp.options.length; i++)
                    RadioListTile<int>(
                      key: Key('option-$i'),
                      value: i,
                      title: Text(cp.options[i]),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            if (_result == null)
              FilledButton(
                key: const Key('btn-submit'),
                onPressed: _selected == null ? null : _submit,
                child: const Text(AppStrings.cpSubmit),
              )
            else
              Container(
                key: const Key('feedback'),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _result!
                      ? scheme.tertiaryContainer
                      : scheme.errorContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(_result! ? Icons.check_circle : Icons.cancel),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _result!
                                ? AppStrings.cpCorrect
                                : AppStrings.cpWrong,
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(cp.explanationHinglish),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}