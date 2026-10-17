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
import '../progress/progress_scope.dart';
import '../progress/topic_status.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.onOpenTab});

  final ValueChanged<int> onOpenTab;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = MockData.user; // naam aur goal target abhi mock
    final progress = ProgressScope.of(context);

    final topics =
        resolveTopics(MockData.topics, progress.state.completedTopics);
    final current = currentTopic(topics);
    final upcoming =
        MockData.contests.where((c) => c.status == ContestStatus.upcoming).toList();

    // Daily goal: aaj ke sahi checkpoints / target.
    final done = progress.todayCorrect;
    final target = user.dailyGoalTarget;
    final fraction =
        target <= 0 ? 0.0 : (done / target).clamp(0.0, 1.0).toDouble();

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
                value: '${progress.streak}',
                label: 'din streak'),
            StatChip(icon: Icons.bolt, value: '${progress.state.xp}', label: 'XP'),
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
                value: fraction,
                minHeight: 10,
                borderRadius: BorderRadius.circular(8),
              ),
              const SizedBox(height: 8),
              Text('$done/$target visualization complete'),
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
        // Weak topics abhi track nahi hote (baad ke part mein), isliye khali.
        const SectionHeader(AppStrings.homeWeakTopics),
        const AbhayCard(child: Text(AppStrings.homeNoWeakTopics)),
      ],
    );
  }
}