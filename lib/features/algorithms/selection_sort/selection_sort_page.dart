import 'package:flutter/material.dart';

import '../../visualization/widgets/checkpoint_card.dart';
import '../../visualization/widgets/visualization_player.dart';
import 'selection_sort_code.dart';
import 'selection_sort_generator.dart';

/// Selection Sort: player + neeche checkpoint sawaal.
/// Bubble Sort page jaisa saancha, bas generator aur code alag.
class SelectionSortPage extends StatelessWidget {
  const SelectionSortPage({super.key});

  // Classic example: new_min aur swap dono dikhte hain.
  static const _input = [64, 25, 12, 22, 11];

  @override
  Widget build(BuildContext context) {
    final viz = SelectionSortGenerator().generate(input: _input);

    return Scaffold(
      appBar: AppBar(title: Text(viz.title)),
      body: ListView(
        key: const Key('page-selection-sort'),
        padding: const EdgeInsets.all(16),
        children: [
          VisualizationPlayer(
            visualization: viz,
            codeLines: selectionSortCodeLines,
          ),
          const SizedBox(height: 16),
          CheckpointCard(checkpoint: viz.checkpoint),
        ],
      ),
    );
  }
}