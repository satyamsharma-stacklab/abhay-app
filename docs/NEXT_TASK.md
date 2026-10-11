# Agla Task: Part 5 — Binary Search + Checkpoint (MVP-A)

**Goal:** Pehla asli algorithm: Binary Search ki visualization, Part 4 ke player par chalti hui, aur end mein exactly ek checkpoint question.
**Git tag at end:** `phase-3a-binary-search`

## Kya banega
1. `BinarySearchGenerator` (implements `AlgorithmGenerator`), `lib/features/algorithms/binary_search/`
   - Steps: LOW/MID/HIGH pointers, compare, left/right half discard, found / not found
   - Har step ka Hinglish explanation, codeLine mapping
2. Binary Search ka code text (CodePanel ke liye lines)
3. Checkpoint question (Hinglish, sirf 1)
4. Ek page jo input array + target leke `VisualizationPlayer` dikhaye, end par checkpoint
5. `visualize_page.dart` mein Binary Search ko playable banana
6. Unit tests: generator deterministic, found / not found / single element / empty

## Rules
- Generator sirf steps banata hai, UI nahi jaanta
- Same input -> same steps
- Text Hinglish, `lib/core/constants/strings.dart` mein

## Done kab maanenge
- [ ] Binary Search app mein chalta hai (Visualize tab se)
- [ ] Checkpoint answer check + feedback dikhta hai
- [ ] `flutter analyze` + `flutter test` pass
- [ ] `git tag phase-3a-binary-search` + push

## Chhote sessions mein
1. `BinarySearchGenerator` + tests
2. Binary Search page + checkpoint UI
3. Visualize tab se jodna

## Uske baad
Part 6: Linear Search.