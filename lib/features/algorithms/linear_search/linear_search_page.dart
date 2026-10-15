import 'package:flutter/material.dart';

import '../algorithm_page.dart';
import 'linear_search_code.dart';
import 'linear_search_generator.dart';

/// Linear Search: generic AlgorithmPage ka wrapper (unsorted array + target).
class LinearSearchPage extends StatelessWidget {
  const LinearSearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AlgorithmPage(
      generator: LinearSearchGenerator(),
      codeLines: linearSearchCodeLines,
      input: const [7, 3, 9, 1, 5],
      target: 9,
      pageKey: 'page-linear-search',
      topicId: 'linear-search',
    );
  }
}