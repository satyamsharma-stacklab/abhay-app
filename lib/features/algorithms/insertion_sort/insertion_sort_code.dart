/// Insertion Sort ka code, CodePanel ke liye.
/// Index 0 se shuru, VisualizationStep.codeLine isi ko point karta hai.
const List<String> insertionSortCodeLines = [
  'for (int i = 1; i < n; i++) {', // 0
  '  int key = a[i];', // 1
  '  int j = i - 1;', // 2
  '  while (j >= 0 && a[j] > key) {', // 3
  '    a[j + 1] = a[j];', // 4
  '    j--;', // 5
  '  }', // 6
  '  a[j + 1] = key;', // 7
  '}', // 8
];