import 'package:flutter/material.dart';

import '../../visualization/widgets/checkpoint_card.dart';
import '../../visualization/widgets/visualization_player.dart';
import 'bubble_sort_code.dart';
import 'bubble_sort_generator.dart';

/// Bubble Sort: player + neeche checkpoint sawaal.
/// Binary/Linear Search page jaisa saancha, bas target nahi hota.
class BubbleSortPage extends StatelessWidget {
  const BubbleSortPage({super.key});

  // Chhota unsorted array, taaki swaps aur pass_done dono dikhein.
  static const _input = [5, 1, 4, 2, 8];

  @override
  Widget build(BuildContext context) {
    final viz = BubbleSortGenerator().generate(input: _input);

    return Scaffold(
      appBar: AppBar(title: Text(viz.title)),
      body: ListView(
        key: const Key('page-bubble-sort'),
        padding: const EdgeInsets.all(16),
        children: [
          VisualizationPlayer(
            visualization: viz,
            codeLines: bubbleSortCodeLines,
          ),
          const SizedBox(height: 16),
          CheckpointCard(checkpoint: viz.checkpoint),
        ],
      ),
    );
  }
}