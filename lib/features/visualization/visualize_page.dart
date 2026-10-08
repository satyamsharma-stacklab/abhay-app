import 'package:flutter/material.dart';

import '../../core/constants/strings.dart';
import '../../core/mock/mock_data.dart';
import '../../shared/widgets/abhay_card.dart';
import '../../shared/widgets/section_header.dart';

/// Abhi sirf list dikhati hai. Asli visualization engine Part 3-5 mein judega.
class VisualizePage extends StatelessWidget {
  const VisualizePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final items = MockData.topics.where((t) => t.playable).toList();

    return ListView(
      key: const Key('page-visualize'),
      padding: const EdgeInsets.all(16),
      children: [
        const SectionHeader(AppStrings.visualizeTitle, subtitle: AppStrings.visualizeIntro),
        for (final t in items)
          AbhayCard(
            child: Row(
              children: [
                const Icon(Icons.play_circle_outline, size: 32),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(t.title,
                      style: theme.textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.w700)),
                ),
                const SizedBox(width: 8),
                const Chip(label: Text(AppStrings.comingSoon)),
              ],
            ),
          ),
      ],
    );
  }
}
