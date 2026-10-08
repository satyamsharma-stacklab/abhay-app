enum ContestStatus { upcoming, live, completed }

class ContestInfo {
  const ContestInfo({
    required this.id,
    required this.title,
    required this.type,
    required this.startsAt,
    required this.durationMinutes,
    required this.questionCount,
    required this.status,
    this.scoreText,
  });

  final String id;
  final String title;
  final String type;
  final DateTime startsAt;
  final int durationMinutes;
  final int questionCount;
  final ContestStatus status;

  /// Sirf completed contest ke liye, e.g. "70/100".
  final String? scoreText;
}
