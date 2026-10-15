import 'package:flutter/material.dart';

import '../visualization/engine/algorithm_generator.dart';
import '../visualization/widgets/checkpoint_card.dart';
import '../visualization/widgets/visualization_player.dart';

/// Har algorithm ka common page: player + neeche checkpoint sawaal.
/// Algorithm-specific cheezein (generator, code, input) bahar se aati hain.
class AlgorithmPage extends StatelessWidget {
  final AlgorithmGenerator generator;
  final List<String> codeLines;
  final List<int> input;

  /// Sirf searches ke liye. Sorts mein null rehta hai.
  final int? target;

  /// ListView ka key, jaise 'page-binary-search' (tests isi se dhoondhte hain).
  final String pageKey;

  /// Topic id (jaise 'binary-search'). Sahi checkpoint par isi ka progress save hota hai.
  final String? topicId;

  const AlgorithmPage({
    super.key,
    required this.generator,
    required this.codeLines,
    required this.input,
    required this.pageKey,
    this.target,
    this.topicId,
  });

  @override
  Widget build(BuildContext context) {
    final viz = generator.generate(input: input, target: target);
    final title = target == null ? viz.title : '${viz.title} (target $target)';

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: ListView(
        key: Key(pageKey),
        padding: const EdgeInsets.all(16),
        children: [
          VisualizationPlayer(visualization: viz, codeLines: codeLines),
          const SizedBox(height: 16),
          CheckpointCard(checkpoint: viz.checkpoint, topicId: topicId),
        ],
      ),
    );
  }
}