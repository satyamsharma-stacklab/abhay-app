import 'package:flutter/material.dart';

import '../../core/constants/strings.dart';
import '../../core/mock/mock_data.dart';
import '../../core/models/contest_info.dart';
import '../../core/utils/format.dart';
import '../../shared/widgets/abhay_card.dart';

class ContestPage extends StatelessWidget {
  const ContestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Column(
        key: const Key('page-contest'),
        children: const [
          TabBar(tabs: [
            Tab(text: AppStrings.contestUpcoming),
            Tab(text: AppStrings.contestLive),
            Tab(text: AppStrings.contestCompleted),
          ]),
          Expanded(
            child: TabBarView(children: [
              _ContestList(status: ContestStatus.upcoming),
              _ContestList(status: ContestStatus.live),
              _ContestList(status: ContestStatus.completed),
            ]),
          ),
        ],
      ),
    );
  }
}

class _ContestList extends StatelessWidget {
  const _ContestList({required this.status});

  final ContestStatus status;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final items = MockData.contests.where((c) => c.status == status).toList();

    if (items.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(AppStrings.contestEmpty, textAlign: TextAlign.center),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        for (final c in items)
          AbhayCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(c.title,
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Text(c.type),
                const SizedBox(height: 8),
                Text('${formatDateTime(c.startsAt)} • ${c.durationMinutes} min • '
                    '${c.questionCount} questions'),
                if (c.scoreText != null) ...[
                  const SizedBox(height: 8),
                  Text('Score: ${c.scoreText}',
                      style:
                          theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                ],
              ],
            ),
          ),
      ],
    );
  }
}
