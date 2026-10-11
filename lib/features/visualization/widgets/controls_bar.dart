import 'package:flutter/material.dart';

import '../../../core/constants/strings.dart';

/// Play / Pause / Next / Peeche / Restart aur speed ke buttons.
/// Ye controller ko nahi jaanta, sirf callbacks bulata hai.
/// Har button par icon aur tooltip hai.
class ControlsBar extends StatelessWidget {
  final bool isPlaying;
  final bool canGoPrevious;
  final bool canGoNext;
  final double speed;
  final VoidCallback onPlay;
  final VoidCallback onPause;
  final VoidCallback onNext;
  final VoidCallback onPrevious;
  final VoidCallback onRestart;
  final ValueChanged<double> onSpeedChanged;

  const ControlsBar({
    super.key,
    required this.isPlaying,
    required this.canGoPrevious,
    required this.canGoNext,
    required this.speed,
    required this.onPlay,
    required this.onPause,
    required this.onNext,
    required this.onPrevious,
    required this.onRestart,
    required this.onSpeedChanged,
  });

  static const speeds = [0.5, 1.0, 2.0];

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const Key('controls-bar'),
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              key: const Key('btn-restart'),
              tooltip: AppStrings.ctrlRestart,
              icon: const Icon(Icons.replay),
              onPressed: onRestart,
            ),
            IconButton(
              key: const Key('btn-previous'),
              tooltip: AppStrings.ctrlPrevious,
              icon: const Icon(Icons.skip_previous),
              onPressed: canGoPrevious ? onPrevious : null,
            ),
            IconButton.filled(
              key: const Key('btn-play-pause'),
              tooltip: isPlaying ? AppStrings.ctrlPause : AppStrings.ctrlPlay,
              iconSize: 32,
              icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
              onPressed: isPlaying ? onPause : onPlay,
            ),
            IconButton(
              key: const Key('btn-next'),
              tooltip: AppStrings.ctrlNext,
              icon: const Icon(Icons.skip_next),
              onPressed: canGoNext ? onNext : null,
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.speed, size: 18),
            const SizedBox(width: 6),
            const Text(AppStrings.ctrlSpeed),
            const SizedBox(width: 8),
            for (final s in speeds)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3),
                child: ChoiceChip(
                  key: Key('speed-$s'),
                  label: Text('${s}x'),
                  selected: speed == s,
                  onSelected: (_) => onSpeedChanged(s),
                ),
              ),
          ],
        ),
      ],
    );
  }
}