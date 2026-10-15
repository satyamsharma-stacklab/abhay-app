import 'package:flutter/material.dart';

import '../algorithm_page.dart';
import 'bubble_sort_code.dart';
import 'bubble_sort_generator.dart';

/// Bubble Sort: generic AlgorithmPage ka wrapper (target nahi hota).
class BubbleSortPage extends StatelessWidget {
  const BubbleSortPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AlgorithmPage(
      generator: BubbleSortGenerator(),
      codeLines: bubbleSortCodeLines,
      input: const [5, 1, 4, 2, 8],
      pageKey: 'page-bubble-sort',
    );
  }
}