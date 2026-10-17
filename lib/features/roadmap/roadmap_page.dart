import 'package:flutter/material.dart';

import '../../core/constants/strings.dart';
import '../../core/mock/mock_data.dart';
import '../../core/models/roadmap_topic.dart';
import '../../shared/widgets/abhay_card.dart';
import '../../shared/widgets/section_header.dart';
import '../progress/progress_scope.dart';
import '../progress/topic_status.dart';

class RoadmapPage extends StatelessWidget {
  const RoadmapPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Asli progress se status (progress badalne par ye apne aap rebuild hota hai).
    final progress = ProgressScope.of(context);
    final topics =
        resolveTopics(MockData.topics, progress.state.completedTopics);
    return ListView.builder(
      key: const Key('page-roadmap'),
      padding: const EdgeInsets.all(16),
      itemCount: topics.length + 1,
      itemBuilder: (context, i) {
        if (i == 0) {
          return const SectionHeader(AppStrings.roadmapTitle,
              subtitle: AppStrings.roadmapSubtitle);
        }
        return _TopicTile(index: i, topic: topics[i - 1]);
      },
    );
  }
}

class _TopicTile extends StatelessWidget {
  const _TopicTile({required this.index, required this.topic});

  final int index;
  final RoadmapTopic topic;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    // Color ke saath icon + text label bhi hai, taaki sirf color par depend na rahe.
    final (IconData icon, String label, Color color) = switch (topic.status) {
      TopicStatus.completed => (Icons.check_circle, AppStrings.statusCompleted, scheme.primary),
      TopicStatus.unlocked =>
        (Icons.play_circle_fill, AppStrings.statusUnlocked, scheme.tertiary),
      TopicStatus.locked => (Icons.lock, AppStrings.statusLocked, scheme.outline),
    };

    final locked = topic.status == TopicStatus.locked;

    return AbhayCard(
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: scheme.surfaceContainerHighest,
            child: Text('$index', style: theme.textTheme.labelLarge),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(topic.title,
                    style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: locked ? scheme.onSurfaceVariant : null)),
                if (!topic.playable)
                  Text(AppStrings.comingSoon, style: theme.textTheme.bodySmall),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Icon(icon, color: color),
          const SizedBox(width: 6),
          Text(label, style: theme.textTheme.labelMedium?.copyWith(color: color)),
        ],
      ),
    );
  }
}