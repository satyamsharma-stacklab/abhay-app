/// Binary Search ka code, CodePanel ke liye.
/// Index 0 se shuru, VisualizationStep.codeLine isi ko point karta hai.
const List<String> binarySearchCodeLines = [
  'int lo = 0, hi = n - 1;', // 0
  'while (lo <= hi) {', // 1
  '  int mid = (lo + hi) ~/ 2;', // 2
  '  if (a[mid] == target) return mid;', // 3
  '  if (a[mid] < target) lo = mid + 1;', // 4
  '  else hi = mid - 1;', // 5
  '}', // 6
  'return -1;', // 7
];