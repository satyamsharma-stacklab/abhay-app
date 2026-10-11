import 'package:flutter/material.dart';

import '../../../core/constants/strings.dart';
import '../engine/visualization_state.dart';
import 'pointer_marker.dart';

/// Array ko boxes mein dikhata hai.
/// Sirf state render karta hai, koi algorithm nahi jaanta.
class ArrayVisualizer extends StatelessWidget {
  final VisualizationState state;

  /// Sirf current step ke active indices.
  final List<int> activeIndices;

  const ArrayVisualizer({
    super.key,
    required this.state,
    this.activeIndices = const [],
  });

  /// Index -> us par kaunse pointers hain.
  Map<int, List<String>> _pointersByIndex() {
    final result = <int, List<String>>{};
    state.pointers.forEach((name, index) {
      result.putIfAbsent(index, () => []).add(name);
    });
    return result;
  }

  @override
  Widget build(BuildContext context) {
    if (state.array.isEmpty) {
      return const Center(child: Text(AppStrings.arrayEmpty));
    }
    final byIndex = _pointersByIndex();

    return SingleChildScrollView(
      key: const Key('array-visualizer'),
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (var i = 0; i < state.array.length; i++)
            _Cell(
              index: i,
              value: state.array[i],
              pointerNames: byIndex[i] ?? const [],
              label: state.labels[i],
              isHighlighted: state.highlighted.contains(i),
              isActive: activeIndices.contains(i),
            ),
        ],
      ),
    );
  }
}

class _Cell extends StatelessWidget {
  final int index;
  final int value;
  final List<String> pointerNames;
  final String? label;
  final bool isHighlighted;
  final bool isActive;

  const _Cell({
    required this.index,
    required this.value,
    required this.pointerNames,
    required this.label,
    required this.isHighlighted,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    // Active sabse upar, phir highlighted, phir normal.
    Color bg = scheme.surfaceContainerHighest;
    Color fg = scheme.onSurface;
    Color border = scheme.outlineVariant;
    IconData? icon;
    if (isHighlighted) {
      bg = scheme.tertiaryContainer;
      fg = scheme.onTertiaryContainer;
      border = scheme.tertiary;
      icon = Icons.check_circle;
    }
    if (isActive) {
      bg = scheme.primaryContainer;
      fg = scheme.onPrimaryContainer;
      border = scheme.primary;
      icon = Icons.visibility;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 48,
            child: pointerNames.isEmpty
                ? null
                : PointerMarker(names: pointerNames),
          ),
          Container(
            key: Key('cell-$index'),
            width: 56,
            height: 56,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: bg,
              border: Border.all(color: border, width: isActive ? 3 : 1.5),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) Icon(icon, size: 14, color: fg),
                Text(
                  '$value',
                  style: text.titleMedium
                      ?.copyWith(color: fg, fontWeight: FontWeight.w800),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Text('$index', style: text.labelSmall),
          SizedBox(
            height: 16,
            child: label == null
                ? null
                : Text(label!, style: text.labelSmall),
          ),
        ],
      ),
    );
  }
}