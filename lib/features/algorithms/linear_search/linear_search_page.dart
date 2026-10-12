import 'package:flutter/material.dart';

import '../../visualization/widgets/visualization_player.dart';
import '../binary_search/checkpoint_card.dart';
import 'linear_search_code.dart';
import 'linear_search_generator.dart';

/// Linear Search: player + neeche checkpoint sawaal.
/// Binary Search page jaisa hi saancha, bas generator aur code alag.
class LinearSearchPage extends StatelessWidget {
  const LinearSearchPage({super.key});

  // Unsorted array: Linear Search ko sorted hona zaroori nahi.
  static const _input = [7, 3, 9, 1, 5];
  static const _target = 9;

  @override
  Widget build(BuildContext context) {
    final viz = LinearSearchGenerator().generate(
      input: _input,
      target: _target,
    );

    return Scaffold(
      appBar: AppBar(title: Text('${viz.title} (target $_target)')),
      body: ListView(
        key: const Key('page-linear-search'),
        padding: const EdgeInsets.all(16),
        children: [
          VisualizationPlayer(
            visualization: viz,
            codeLines: linearSearchCodeLines,
          ),
          const SizedBox(height: 16),
          CheckpointCard(checkpoint: viz.checkpoint),
        ],
      ),
    );
  }
}