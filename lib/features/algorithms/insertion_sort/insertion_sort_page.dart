import 'package:flutter/material.dart';

import '../../visualization/widgets/checkpoint_card.dart';
import '../../visualization/widgets/visualization_player.dart';
import 'insertion_sort_code.dart';
import 'insertion_sort_generator.dart';

/// Insertion Sort: player + neeche checkpoint sawaal.
/// Selection Sort page jaisa saancha, bas generator aur code alag.
class InsertionSortPage extends StatelessWidget {
  const InsertionSortPage({super.key});

  // Shifts aur bina-shift wala insert dono dikhte hain.
  static const _input = [5, 2, 4, 6, 1];

  @override
  Widget build(BuildContext context) {
    final viz = InsertionSortGenerator().generate(input: _input);

    return Scaffold(
      appBar: AppBar(title: Text(viz.title)),
      body: ListView(
        key: const Key('page-insertion-sort'),
        padding: const EdgeInsets.all(16),
        children: [
          VisualizationPlayer(
            visualization: viz,
            codeLines: insertionSortCodeLines,
          ),
          const SizedBox(height: 16),
          CheckpointCard(checkpoint: viz.checkpoint),
        ],
      ),
    );
  }
}