import 'package:flutter/material.dart';

import '../../core/constants/strings.dart';
import '../../core/mock/mock_data.dart';
import '../../shared/widgets/abhay_card.dart';
import '../../shared/widgets/section_header.dart';
import '../algorithms/binary_search/binary_search_page.dart';
import '../algorithms/bubble_sort/bubble_sort_page.dart';
import '../algorithms/insertion_sort/insertion_sort_page.dart';
import '../algorithms/linear_search/linear_search_page.dart';
import '../algorithms/selection_sort/selection_sort_page.dart';

/// Playable topics ki list. Jo algorithm ready hai wo khulta hai,
/// baaki par "Jald aa raha hai" dikhta hai.
class VisualizePage extends StatelessWidget {
  const VisualizePage({super.key});

  /// Searches aur teeno sorts ready hain.
  static const _readyIds = {
    'linear-search',
    'binary-search',
    'bubble-sort',
    'selection-sort',
    'insertion-sort',
  };

  /// Topic id se uska page banata hai. Nayi algorithm = nayi line yahan.
  Widget _pageFor(String id) {
    switch (id) {
      case 'linear-search':
        return const LinearSearchPage();
      case 'binary-search':
        return const BinarySearchPage();
      case 'bubble-sort':
        return const BubbleSortPage();
      case 'selection-sort':
        return const SelectionSortPage();
      case 'insertion-sort':
        return const InsertionSortPage();
      default:
        throw ArgumentError('Is topic ka page nahi hai: $id');
    }
  }

  void _open(BuildContext context, String id) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => _pageFor(id)),
    );
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