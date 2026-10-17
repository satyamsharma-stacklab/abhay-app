import 'package:flutter_test/flutter_test.dart';
import 'package:abhay/core/models/roadmap_topic.dart';
import 'package:abhay/features/progress/topic_status.dart';

const _base = [
  RoadmapTopic(id: 'a', title: 'A', status: TopicStatus.completed),
  RoadmapTopic(id: 'b', title: 'B', status: TopicStatus.locked, playable: true),
  RoadmapTopic(id: 'c', title: 'C', status: TopicStatus.locked, playable: true),
  RoadmapTopic(id: 'd', title: 'D', status: TopicStatus.unlocked),
];

void main() {
  test('khali progress: playable khule, baaki locked (mock status ignore)', () {
    final r = resolveTopics(_base, {});
    expect(r.map((t) => t.status).toList(), [
      TopicStatus.locked,
      TopicStatus.unlocked,
      TopicStatus.unlocked,
      TopicStatus.locked,
    ]);
  });

  test('completed topic complete dikhta hai', () {
    final r = resolveTopics(_base, {'b'});
    expect(r[1].status, TopicStatus.completed);
    expect(r[2].status, TopicStatus.unlocked);
  });

  test('title, id aur playable same rehte hain', () {
    final r = resolveTopics(_base, {'b'});
    expect(r[1].id, 'b');
    expect(r[1].title, 'B');
    expect(r[1].playable, isTrue);
  });

  test('currentTopic pehla khula topic hai', () {
    expect(currentTopic(resolveTopics(_base, {})).id, 'b');
    expect(currentTopic(resolveTopics(_base, {'b'})).id, 'c');
  });

  test('sab playable complete: aakhri playable topic', () {
    expect(currentTopic(resolveTopics(_base, {'b', 'c'})).id, 'c');
  });
}