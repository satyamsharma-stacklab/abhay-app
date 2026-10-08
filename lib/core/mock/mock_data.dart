import '../models/abhay_badge.dart';
import '../models/contest_info.dart';
import '../models/roadmap_topic.dart';
import '../models/user_progress.dart';

/// Backend aane tak sara data yahin se aata hai (Part 11 mein API se replace hoga).
class MockData {
  MockData._();

  static const user = UserProgress(
    name: 'Abhay',
    xp: 120,
    streak: 3,
    dailyGoalDone: 1,
    dailyGoalTarget: 3,
    currentTopicId: 'binary-search',
    weakTopics: ['Binary Search'],
  );

  static const topics = <RoadmapTopic>[
    RoadmapTopic(id: 'complexity', title: 'Complexity', status: TopicStatus.completed),
    RoadmapTopic(id: 'arrays', title: 'Arrays', status: TopicStatus.completed),
    RoadmapTopic(
        id: 'linear-search',
        title: 'Linear Search',
        status: TopicStatus.completed,
        playable: true),
    RoadmapTopic(
        id: 'binary-search',
        title: 'Binary Search',
        status: TopicStatus.unlocked,
        playable: true),
    RoadmapTopic(
        id: 'bubble-sort', title: 'Bubble Sort', status: TopicStatus.locked, playable: true),
    RoadmapTopic(
        id: 'selection-sort',
        title: 'Selection Sort',
        status: TopicStatus.locked,
        playable: true),
    RoadmapTopic(
        id: 'insertion-sort',
        title: 'Insertion Sort',
        status: TopicStatus.locked,
        playable: true),
    RoadmapTopic(id: 'linked-list', title: 'Linked List', status: TopicStatus.locked),
    RoadmapTopic(id: 'stack', title: 'Stack', status: TopicStatus.locked),
    RoadmapTopic(id: 'queue', title: 'Queue', status: TopicStatus.locked),
    RoadmapTopic(id: 'trees', title: 'Trees', status: TopicStatus.locked),
    RoadmapTopic(id: 'bst', title: 'BST', status: TopicStatus.locked),
    RoadmapTopic(id: 'heap', title: 'Heap', status: TopicStatus.locked),
    RoadmapTopic(id: 'hashing', title: 'Hashing', status: TopicStatus.locked),
    RoadmapTopic(id: 'graph', title: 'Graph', status: TopicStatus.locked),
    RoadmapTopic(id: 'recursion', title: 'Recursion', status: TopicStatus.locked),
    RoadmapTopic(id: 'greedy', title: 'Greedy', status: TopicStatus.locked),
    RoadmapTopic(id: 'dp', title: 'Dynamic Programming', status: TopicStatus.locked),
  ];

  static const badges = <AbhayBadge>[
    AbhayBadge(
        id: 'first-viz',
        title: 'First Visualization',
        description: 'Pehli visualization complete ki',
        earned: true),
    AbhayBadge(
        id: 'binary-master',
        title: 'Binary Search Master',
        description: 'Binary Search ka checkpoint pass karo',
        earned: false),
    AbhayBadge(
        id: 'sorting-explorer',
        title: 'Sorting Explorer',
        description: 'Saari sorting visualizations complete karo',
        earned: false),
    AbhayBadge(
        id: 'contest-starter',
        title: 'Contest Starter',
        description: 'Pehla ABHAY contest join karo',
        earned: false),
    AbhayBadge(
        id: 'streak-7',
        title: '7 Day Streak',
        description: 'Lagatar 7 din seekho',
        earned: false),
  ];

  static final contests = <ContestInfo>[
    ContestInfo(
      id: 'c1',
      title: 'Beginner Weekly Challenge',
      type: 'Visualization Challenge',
      startsAt: DateTime(2026, 10, 10, 18, 0),
      durationMinutes: 45,
      questionCount: 10,
      status: ContestStatus.upcoming,
    ),
    ContestInfo(
      id: 'c0',
      title: 'Searching Basics Quiz',
      type: 'Topic-specific',
      startsAt: DateTime(2026, 10, 3, 18, 0),
      durationMinutes: 30,
      questionCount: 10,
      status: ContestStatus.completed,
      scoreText: '70/100',
    ),
  ];
}
