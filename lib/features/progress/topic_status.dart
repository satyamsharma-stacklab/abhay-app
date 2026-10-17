import '../../core/models/roadmap_topic.dart';

/// Mock topics ko asli progress ke hisaab se status deta hai.
/// complete = checkpoint sahi ho chuka, playable = khula hai, baaki locked.
List<RoadmapTopic> resolveTopics(
  List<RoadmapTopic> base,
  Set<String> completed,
) {
  return [
    for (final t in base)
      RoadmapTopic(
        id: t.id,
        title: t.title,
        playable: t.playable,
        status: completed.contains(t.id)
            ? TopicStatus.completed
            : (t.playable ? TopicStatus.unlocked : TopicStatus.locked),
      ),
  ];
}

/// Home par "seekhna jaari rakho" ke liye: pehla khula topic.
/// Sab complete ho to aakhri playable, wo bhi na ho to pehla topic.
RoadmapTopic currentTopic(List<RoadmapTopic> resolved) {
  for (final t in resolved) {
    if (t.status == TopicStatus.unlocked) return t;
  }
  final playable = resolved.where((t) => t.playable).toList();
  return playable.isNotEmpty ? playable.last : resolved.first;
}