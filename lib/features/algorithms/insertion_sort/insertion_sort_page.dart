import 'package:flutter/material.dart';

import '../algorithm_page.dart';
import 'insertion_sort_code.dart';
import 'insertion_sort_generator.dart';

/// Insertion Sort: generic AlgorithmPage ka wrapper (target nahi hota).
class InsertionSortPage extends StatelessWidget {
  const InsertionSortPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AlgorithmPage(
      generator: InsertionSortGenerator(),
      codeLines: insertionSortCodeLines,
      input: const [5, 2, 4, 6, 1],
      pageKey: 'page-insertion-sort',
      topicId: 'insertion-sort',
    );
  }
}