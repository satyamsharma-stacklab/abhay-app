import 'package:flutter/material.dart';

import '../algorithm_page.dart';
import 'selection_sort_code.dart';
import 'selection_sort_generator.dart';

/// Selection Sort: generic AlgorithmPage ka wrapper (target nahi hota).
class SelectionSortPage extends StatelessWidget {
  const SelectionSortPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AlgorithmPage(
      generator: SelectionSortGenerator(),
      codeLines: selectionSortCodeLines,
      input: const [64, 25, 12, 22, 11],
      pageKey: 'page-selection-sort',
    );
  }
}