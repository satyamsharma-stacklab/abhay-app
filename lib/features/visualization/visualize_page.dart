import 'package:flutter/material.dart';

import '../../core/constants/strings.dart';
import '../../core/mock/mock_data.dart';
import '../../shared/widgets/abhay_card.dart';
import '../../shared/widgets/section_header.dart';
import '../algorithms/binary_search/binary_search_page.dart';

/// Playable topics ki list. Jo algorithm ready hai wo khulta hai,
/// baaki par "Jald aa raha hai" dikhta hai.
class VisualizePage extends StatelessWidget {
  const VisualizePage({super.key});

  /// Abhi sirf Binary Search ready hai.
  static const _readyIds = {'binary-search'};

  void _open(BuildContext context, String id) {
    if (id == 'binary-search') {
      Navigator.of(context).push(
        MaterialPageRoute<void>(builder: (_) => const BinarySearchPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final items = MockData.topics.where((t) => t.playable).toList();

    return ListView(
      key: const Key('page-visualize'),
      padding: const EdgeInsets.all(16),
      children: [
        const SectionHeader(
          AppStrings.visualizeTitle,
          subtitle: AppStrings.visualizeIntro,
        ),
        for (final t in items)
          AbhayCard(
            child: Row(
              children: [
                const Icon(Icons.play_circle_outline, size: 32),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    t.title,
                    style: theme.textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                ),
                const SizedBox(width: 8),
                if (_readyIds.contains(t.id))
                  FilledButton(
                    key: Key('open-${t.id}'),
                    onPressed: () => _open(context, t.id),
                    child: const Text(AppStrings.vizOpen),
                  )
                else
                  const Chip(label: Text(AppStrings.comingSoon)),
              ],
            ),
          ),
      ],
    );
  }
}