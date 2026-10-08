import 'package:flutter/material.dart';

import '../../app/shell.dart';
import '../../core/constants/strings.dart';
import '../../core/mock/mock_data.dart';
import '../../core/models/contest_info.dart';
import '../../core/utils/format.dart';
import '../../shared/widgets/abhay_button.dart';
import '../../shared/widgets/abhay_card.dart';
import '../../shared/widgets/section_header.dart';
import '../../shared/widgets/stat_chip.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.onOpenTab});

  final ValueChanged<int> onOpenTab;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = MockData.user;
    final current = MockData.topics.firstWhere((t) => t.id == user.currentTopicId);
    final upcoming =
        MockData.contests.where((c) => c.status == ContestStatus.upcoming).toList();

    return ListView(
      key: const Key('page-home'),
      padding: const EdgeInsets.all(16),
      children: [
        Text('Namaste, ${user.name}!',
            style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            StatChip(
                icon: Icons.local_fire_department,
                value: '${user.streak}',
                label: 'din streak'),
            StatChip(icon: Icons.bolt, value: '${user.xp}', label: 'XP'),
          ],
        ),
        const SizedBox(height: 20),
        AbhayCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppStrings.homeGoal, style: theme.textTheme.titleMedium),
              const SizedBox(height: 10),
              LinearProgressIndicator(
                value: user.dailyGoalFraction,
                minHeight: 10,
                borderRadius: BorderRadius.circular(8),
              ),
              const SizedBox(height: 8),
              Text('${user.dailyGoalDone}/${user.dailyGoalTarget} visualization complete'),
            ],
          ),
        ),
        const SectionHeader(AppStrings.homeContinue),
        AbhayCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(current.title,
                  style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(height: 4),
              const Text('Dekho, samjho, phir ek sawaal solve karo.'),
              const SizedBox(height: 14),
              AbhayButton(
                label: AppStrings.homeStartVisualization,
                icon: Icons.play_arrow,
                expand: true,
                onPressed: () => onOpenTab(AbhayShell.tabVisualize),
              ),
            ],
          ),
        ),
        const SectionHeader(AppStrings.homeUpcomingContest),
        if (upcoming.isEmpty)
          const AbhayCard(child: Text(AppStrings.contestEmpty))
        else
          AbhayCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(upcoming.first.title, style: theme.textTheme.titleMedium),
                const SizedBox(height: 4),
                Text('${upcoming.first.type} • ${formatDateTime(upcoming.first.startsAt)} • '
                    '${upcoming.first.durationMinutes} min'),
              ],
            ),
          ),
        const SectionHeader(AppStrings.homeWeakTopics),
        if (user.weakTopics.isEmpty)
          const AbhayCard(child: Text(AppStrings.homeNoWeakTopics))
        else
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final t in user.weakTopics)
                Chip(avatar: const Icon(Icons.warning_amber_rounded, size: 18), label: Text(t)),
            ],
          ),
      ],
    );
  }
}
