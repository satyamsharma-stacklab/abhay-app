import 'package:flutter/material.dart';

import '../engine/visualization.dart';
import '../engine/visualization_controller.dart';
import 'array_visualizer.dart';
import 'code_panel.dart';
import 'controls_bar.dart';
import 'explanation_box.dart';

/// Saare widgets ko jodta hai aur VisualizationController se chalata hai.
/// Algorithm ko nahi jaanta, sirf Visualization render karta hai.
class VisualizationPlayer extends StatefulWidget {
  final Visualization visualization;

  /// Code panel ki lines (optional).
  final List<String> codeLines;

  const VisualizationPlayer({
    super.key,
    required this.visualization,
    this.codeLines = const [],
  });

  @override
  State<VisualizationPlayer> createState() => _VisualizationPlayerState();
}

class _VisualizationPlayerState extends State<VisualizationPlayer> {
  late final VisualizationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VisualizationController(widget.visualization);
    _controller.onChanged = () {
      if (mounted) setState(() {});
    };
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = _controller;
    final step = c.currentStep;
    final state = step?.state ?? widget.visualization.initialState;

    return Column(
      key: const Key('visualization-player'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ArrayVisualizer(
          state: state,
          activeIndices: step?.highlights ?? const [],
        ),
        const SizedBox(height: 12),
        ExplanationBox(text: step?.explanationHinglish),
        if (widget.codeLines.isNotEmpty) ...[
          const SizedBox(height: 12),
          CodePanel(lines: widget.codeLines, activeLine: step?.codeLine),
        ],
        const SizedBox(height: 12),
        ControlsBar(
          isPlaying: c.isPlaying,
          canGoPrevious: !c.isAtStart,
          canGoNext: !c.isFinished,
          speed: c.speed,
          onPlay: c.play,
          onPause: c.pause,
          onNext: c.next,
          onPrevious: c.previous,
          onRestart: c.restart,
          onSpeedChanged: c.setSpeed,
        ),
      ],
    );
  }
}