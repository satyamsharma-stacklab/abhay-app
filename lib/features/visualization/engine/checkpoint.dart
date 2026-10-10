/// Lesson ke end ka exactly ek sawaal.
class Checkpoint {
  final String question;
  final List<String> options;
  final int correctIndex;

  /// Jawab ke baad Hinglish mein "kyun" samjhana.
  final String explanationHinglish;

  // Note: const constructor mein options.length use nahi ho sakta,
  // isliye range check sirf correctIndex >= 0 tak rakha hai.
  // Upper bound ka check test mein hota hai.
  const Checkpoint({
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.explanationHinglish,
  }) : assert(correctIndex >= 0);

  /// Student ka chuna hua option sahi hai ya nahi.
  /// Galat ya range se bahar index par false deta hai.
  bool isCorrect(int selectedIndex) => selectedIndex == correctIndex;
}