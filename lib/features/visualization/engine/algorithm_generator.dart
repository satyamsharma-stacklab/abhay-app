import 'visualization.dart';

/// Har algorithm ke liye ek generator banega (Binary Search, Bubble Sort, etc.).
/// Ye sirf steps "generate" karta hai, screen par kuch nahi dikhata.
///
/// Rule: same input -> hamesha same steps (deterministic).
/// Is ke andar random ya DateTime ka use mat karna.
abstract class AlgorithmGenerator {
  /// Unique id, jaise 'binary_search'.
  String get algorithmId;

  /// Student ko dikhne wala naam.
  String get title;

  /// Input array aur (zaroorat ho to) target se poori Visualization banata hai.
  Visualization generate({
    required List<int> input,
    int? target,
  });
}