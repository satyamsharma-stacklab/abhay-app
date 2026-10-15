import 'package:flutter/material.dart';

import '../algorithm_page.dart';
import 'binary_search_code.dart';
import 'binary_search_generator.dart';

/// Binary Search: generic AlgorithmPage ka wrapper (sorted array + target).
class BinarySearchPage extends StatelessWidget {
  const BinarySearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AlgorithmPage(
      generator: BinarySearchGenerator(),
      codeLines: binarySearchCodeLines,
      input: const [2, 5, 8, 12, 16, 23, 38],
      target: 23,
      pageKey: 'page-binary-search',
    );
  }
}