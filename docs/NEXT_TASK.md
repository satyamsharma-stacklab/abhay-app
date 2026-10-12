# Agla Task: Part 7 - Bubble / Selection / Insertion Sort

**Goal:** Teen sorting algorithms ki visualization (swap steps, sorted part highlighted), har ek ke end mein exactly ek checkpoint question.
**Git tag at end:** `phase-4-sorting`

## Pehle chhota cleanup (Session 0)
1. `CheckpointCard` ko `binary_search/` se `lib/features/visualization/widgets/` mein le jana (imports update)
2. `AppStrings` ke `bs...` checkpoint strings ko `cp...` naam dena (`bsCheckpointTitle`, `bsSubmit`, `bsCorrect`, `bsWrong`)
3. Soch: generic `AlgorithmPage(generator, codeLines, input, target)` taaki har sort ke liye alag page copy na ho

## Kya banega (har sort ke liye)
1. `XxxSortGenerator` (implements `AlgorithmGenerator`), `lib/features/algorithms/<sort_name>/`
   - Steps: compare, swap, sorted part highlighted, done
   - Hinglish explanation + codeLine mapping
2. `xxx_sort_code.dart` (CodePanel ke liye lines)
3. Exactly ek checkpoint sawaal (Hinglish)
4. Page (ya generic AlgorithmPage) + `visualize_page.dart` mein `_readyIds` aur `_pageFor` dono update
5. Tests: generator (already sorted, reverse, duplicates, single, empty, deterministic), page

## Rules
- Generator sirf steps banata hai, UI nahi jaanta
- Same input -> same steps
- Colour ke saath icon/label (sorted = tick wala highlight)
- Text Hinglish, `lib/core/constants/strings.dart` mein

## Done kab maanenge
- [ ] Teeno sorts Visualize tab se khulte hain
- [ ] Har sort ka checkpoint answer + feedback chalta hai
- [ ] `flutter analyze` + `flutter test` pass
- [ ] `visualize_open_test.dart` update (Bubble Sort ab "Jald aa raha hai" nahi)
- [ ] `git tag phase-4-sorting` + push

## Chhote sessions mein
0. Cleanup (CheckpointCard shared, strings rename)
1. BubbleSortGenerator + code lines + tests
2. Bubble Sort page + Visualize tab se jodna
3. SelectionSortGenerator + page
4. InsertionSortGenerator + page
5. Docs update + tag

## Uske baad
Part 8: roadmap progress, XP, streak, badges (local, bina backend) = MVP-B.