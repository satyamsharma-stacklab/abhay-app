/// Selection Sort ka code, CodePanel ke liye.
/// Index 0 se shuru, VisualizationStep.codeLine isi ko point karta hai.
const List<String> selectionSortCodeLines = [
  'for (int i = 0; i < n - 1; i++) {', // 0
  '  int min = i;', // 1
  '  for (int j = i + 1; j < n; j++) {', // 2
  '    if (a[j] < a[min]) min = j;', // 3
  '  }', // 4
  '  if (min != i) swap(a[i], a[min]);', // 5
  '}', // 6
];