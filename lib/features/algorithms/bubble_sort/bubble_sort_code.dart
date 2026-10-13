/// Bubble Sort ka code, CodePanel ke liye.
/// Index 0 se shuru, VisualizationStep.codeLine isi ko point karta hai.
const List<String> bubbleSortCodeLines = [
  'for (int i = 0; i < n - 1; i++) {', // 0
  '  bool swapped = false;', // 1
  '  for (int j = 0; j < n - 1 - i; j++) {', // 2
  '    if (a[j] > a[j + 1]) {', // 3
  '      swap(a[j], a[j + 1]);', // 4
  '      swapped = true;', // 5
  '    }', // 6
  '  }', // 7
  '  if (!swapped) break;', // 8
  '}', // 9
];