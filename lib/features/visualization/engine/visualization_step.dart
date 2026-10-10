import 'visualization_state.dart';

/// Algorithm ka ek kadam: kya hua, kyun hua, aur uske baad state kya hai.
class VisualizationStep {
  /// Step number (0 se shuru).
  final int index;

  /// Is step ke baad ka state.
  final VisualizationState state;

  /// Kaunsa operation hua, jaise 'compare', 'swap', 'found'.
  final String operation;

  /// Hinglish mein explanation jo student ko dikhegi.
  final String explanationHinglish;

  /// Code panel mein kaunsi line highlight karni hai (null = koi nahi).
  final int? codeLine;

  /// Sirf is step mein active indices (jaise abhi compare ho rahe do elements).
  final List<int> highlights;

  /// Auto-play mein ye step kitni der dikhega (milliseconds).
  final int durationMs;

  const VisualizationStep({
    required this.index,
    required this.state,
    required this.operation,
    required this.explanationHinglish,
    this.codeLine,
    this.highlights = const [],
    this.durationMs = 1200,
  });
}