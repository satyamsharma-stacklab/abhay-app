import 'checkpoint.dart';
import 'visualization_state.dart';
import 'visualization_step.dart';

/// Time/space complexity ki chhoti info.
class Complexity {
  final String time;
  final String space;
  const Complexity({required this.time, required this.space});
}

/// Ek poori visualization: shuruaati state + saare steps + checkpoint.
class Visualization {
  final String id;
  final String algorithmId;
  final String title;
  final VisualizationState initialState;
  final List<VisualizationStep> steps;
  final Checkpoint checkpoint;
  final Complexity complexity;

  const Visualization({
    required this.id,
    required this.algorithmId,
    required this.title,
    required this.initialState,
    required this.steps,
    required this.checkpoint,
    required this.complexity,
  });
}