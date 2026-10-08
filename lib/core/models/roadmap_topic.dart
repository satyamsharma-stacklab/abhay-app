enum TopicStatus { locked, unlocked, completed }

class RoadmapTopic {
  const RoadmapTopic({
    required this.id,
    required this.title,
    required this.status,
    this.playable = false,
  });

  final String id;
  final String title;
  final TopicStatus status;

  /// Is topic ki visualization abhi app mein available hai ya nahi.
  final bool playable;
}
