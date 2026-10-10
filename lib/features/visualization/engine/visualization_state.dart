/// Ek step ke waqt screen ki poori "tasveer" (snapshot).
/// Ye kisi bhi algorithm ko nahi jaanta, sirf data rakhta hai.
class VisualizationState {
  /// Array ki values (Binary Search, sorting sab ke liye).
  final List<int> array;

  /// Pointers ke naam aur unki index, jaise {'LOW': 0, 'MID': 4, 'HIGH': 9}.
  final Map<String, int> pointers;

  /// Wo indices jo is state mein permanent highlight rehte hain
  /// (jaise sorted hissa, ya mila hua element).
  final List<int> highlighted;

  /// Index ke upar/neeche likhne wale chhote labels, jaise {4: 'MID'}.
  final Map<int, String> labels;

  const VisualizationState({
    required this.array,
    this.pointers = const {},
    this.highlighted = const [],
    this.labels = const {},
  });

  /// Kuch fields badal ke naya state banata hai (purana change nahi hota).
  VisualizationState copyWith({
    List<int>? array,
    Map<String, int>? pointers,
    List<int>? highlighted,
    Map<int, String>? labels,
  }) {
    return VisualizationState(
      array: array ?? this.array,
      pointers: pointers ?? this.pointers,
      highlighted: highlighted ?? this.highlighted,
      labels: labels ?? this.labels,
    );
  }
}
