import 'package:flutter/material.dart';

import '../../visualization/widgets/checkpoint_card.dart';
import '../../visualization/widgets/visualization_player.dart';
import 'binary_search_code.dart';
import 'binary_search_generator.dart';

/// Binary Search: player + neeche checkpoint sawaal.
class BinarySearchPage extends StatelessWidget {
  const BinarySearchPage({super.key});

  static const _input = [2, 5, 8, 12, 16, 23, 38];
  static const _target = 23;

  @override
  Widget build(BuildContext context) {
    final viz = BinarySearchGenerator().generate(
      input: _input,
      target: _target,
    );

    return Scaffold(
      appBar: AppBar(title: Text('${viz.title} (target $_target)')),
      body: ListView(
        key: const Key('page-binary-search'),
        padding: const EdgeInsets.all(16),
        children: [
          VisualizationPlayer(
            visualization: viz,
            codeLines: binarySearchCodeLines,
          ),
          const SizedBox(height: 16),
          CheckpointCard(checkpoint: viz.checkpoint),
        ],
      ),
    );
  }
}