import 'package:flutter/material.dart';
import '../progress/badge_service.dart';
import '../../core/constants/strings.dart';
import '../../core/mock/mock_data.dart';
import '../../core/models/roadmap_topic.dart';
import '../../shared/widgets/abhay_card.dart';
import '../../shared/widgets/section_header.dart';
import '../../shared/widgets/stat_chip.dart';
import '../progress/progress_scope.dart';
import '../progress/topic_status.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key, required this.themeMode});

  final ValueNotifier<ThemeMode> themeMode;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = MockData.user; // naam abhi mock
    final progress = ProgressScope.of(context);
    final badges = const BadgeService().badgesFor(progress.state, streak: progress.streak);
    final completed = resolveTopics(
            MockData.topics, progress.state.completedTopics)
        .where((t) => t.status == TopicStatus.completed)
        .toList();

    return ListView(
      key: const Key('page-profile'),
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 32,
              child: Text(user.name.isEmpty ? '?' : user.name[0].toUpperCase(),
                  style: theme.textTheme.headlineSmall),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(user.name,
                  style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
            ),
          ],
        ),
        const SizedBox(height: 16),
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
        const SizedBox(height: 16),
        AbhayCard(
          padding: EdgeInsets.zero,
          child: ValueListenableBuilder<ThemeMode>(
            valueListenable: themeMode,
            builder: (context, mode, child) {
              return SwitchListTile(
                title: const Text(AppStrings.profileDarkMode),
                secondary: const Icon(Icons.dark_mode_outlined),
                value: mode == ThemeMode.dark,
                onChanged: (v) => themeMode.value = v ? ThemeMode.dark : ThemeMode.light,
              );
            },
          ),
        ),
        const SectionHeader(AppStrings.profileBadges),
        for (final b in badges)
          AbhayCard(
            child: Row(
              children: [
                Icon(b.earned ? Icons.military_tech : Icons.lock_outline,
                    size: 30,
                    color: b.earned ? theme.colorScheme.primary : theme.colorScheme.outline),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(b.title,
                          style: theme.textTheme.titleSmall
                              ?.copyWith(fontWeight: FontWeight.w700)),
                      Text(b.description, style: theme.textTheme.bodySmall),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Text(b.earned ? 'Mil gaya' : 'Locked', style: theme.textTheme.labelMedium),
              ],
            ),
          ),
        const SectionHeader(AppStrings.profileCompletedTopics),
        if (completed.isEmpty)
          const AbhayCard(child: Text(AppStrings.profileNoCompleted))
        else
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final t in completed)
                Chip(avatar: const Icon(Icons.check_circle, size: 18), label: Text(t.title)),
            ],
          ),
      ],
    );
  }
}