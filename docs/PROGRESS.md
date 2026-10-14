# Progress (14-10-2026)

## Complete
### Part 1 - Environment (mostly done)
- Flutter 3.47.6 (stable) `C:\dev\flutter` mein install
- PATH set; purana `dartsdk` conflict hataya (`where.exe dart` ab `C:\dev\flutter\bin\dart` dikhata hai)
- Android Studio (Rabbit 1 | 2026.2.1) + Android SDK, platform-tools, emulator, cmdline-tools install
- `flutter doctor -v`: Flutter OK, Android toolchain OK, Android licenses accepted
  (Visual Studio par red cross = Windows desktop ke liye, ignore)
- Project bana: `flutter create --org com.abhay --project-name abhay abhay_app`

### Part 2 - Flutter Foundation (DONE)
- Theme (light + dark, dark default), routing, 5-tab bottom navigation
- Reusable widgets: AbhayCard, AbhayButton, SectionHeader, StatChip
- Pages: Home, Roadmap (18 topics), Visualize (list), Contest (3 sub-tabs), Profile
- Mock data + Hinglish strings
- `flutter test`: +7 All tests passed
- Git tag: `phase-1-ui-ready` (commit 5088c6f)

### Part 3 - Visualization Engine Core (DONE)
- Models: VisualizationState, VisualizationStep, Checkpoint, Visualization (+ Complexity)
- VisualizationController: play, pause, next, previous, restart, setSpeed (0.25x-4x), currentStep, isFinished, isAtStart
- AlgorithmGenerator abstract interface (deterministic steps)
- Files: `lib/features/visualization/engine/` (6 files)
- Tests: checkpoint 3, controller 13 (FakeGenerator ke saath)
- `flutter test`: +23 All tests passed
- Git tag: `phase-2a-engine-core` (commit 1afce12)

### Part 4 - Visualization Widgets (DONE)
- `lib/features/visualization/widgets/`: ArrayVisualizer, PointerMarker, CodePanel, ExplanationBox, ControlsBar, VisualizationPlayer
- Colour ke saath icon/label (active = aankh, highlighted = tick, code line = arrow)
- Strings `AppStrings` mein
- `flutter analyze`: No issues found
- `flutter test`: +49 All tests passed
- Git tag: `phase-2b-viz-widgets` (commit 6d7f3c4)

### Part 5 - Binary Search + Checkpoint (DONE, MVP-A)
- `lib/features/algorithms/binary_search/`: code, generator, page
- Pointers LOW / MID / HIGH, Hinglish explanation, ek checkpoint sawaal
- Visualize tab se "Dekho" button se khulta hai
- `flutter test`: +64 All tests passed
- Git tag: `phase-3a-binary-search` (commit 34d57dd)

### Part 6 - Linear Search (DONE)
- `lib/features/algorithms/linear_search/`: code, generator, page
- Pointer `I`; har index par `check` step, mismatch par `next` step
- Unsorted array [7, 3, 9, 1, 5], target 9; duplicate mein pehla match
- `visualize_page.dart`: `_readyIds` + `_pageFor` switch (dono saath update karne hain)
- `flutter test`: +87 All tests passed
- Git tag: `phase-3b-linear-search` (commit 42ce9f3)

### Part 7 - Sorting (DONE)
- Session 0 cleanup: `CheckpointCard` ab `lib/features/visualization/widgets/` mein (shared); strings `bs...` se `cp...` (cpTitle, cpSubmit, cpCorrect, cpWrong) - commit cb87648
- Bubble Sort (`lib/features/algorithms/bubble_sort/`): pointers J, J+1; steps init/compare/swap/no_swap/pass_done/done; early exit; sorted = tick; generator 16 tests, page 5 tests - commits 579abd5, 85304d1
- Selection Sort (`selection_sort/`): pointers I, J, MIN; steps init/compare/new_min/swap/no_swap/done; generator 17 tests, page 5 tests - commit d0d3823
- Insertion Sort (`insertion_sort/`): pointers I, J; label KEY=x; steps init/pick_key/compare/shift/insert/done; shift ke dauraan array mein duplicate value dikhti hai (asli algorithm jaisa); generator 19 tests, page 5 tests - commit b91886e
- `visualize_open_test.dart`: ab ek map (topic id -> page key) se saare 5 topics test hote hain
- Har sort ka checkpoint: ek sawaal, sahi jawab option 0
- `flutter analyze`: No issues found
- `flutter test`: +157 All tests passed
- Git tag: `phase-4-sorting`

### Git / Repo setup (DONE)
- Repo: `satyamsharma-stacklab/abhay-app` (private)
- Commit author fix: sab commits `satyamsharma-stacklab` (noreply email) se hain
- Main working folder: `C:\dev\abhay_clone`; purana `C:\dev\abhay_app` sirf backup

## Pending (chhote items)
- [ ] Android emulator/phone par app chalana (Chrome par bhi 6 checks baaki: Linear/Binary/Bubble/Selection/Insertion, checkpoint, dark mode)
- [ ] `flutter build apk --debug` (debug APK banana)
- [ ] Git tag `phase-0-ready` (Android run ke baad)
- [ ] Part 2 ke 3 manual checks: Roadmap labels, Dark mode switch, Home button -> Visualize tab
- [x] Cleanup: `CheckpointCard` shared folder mein
- [x] Cleanup: `bs...` checkpoint strings ko `cp...` naam
- [ ] Soch: generic `AlgorithmPage` refactor (5 pages ab ek jaise hain, Part 8 se pehle sahi waqt)
- [ ] Cleanup: `bsTarget`, `bsFinishHint` strings abhi use ho rahi hain ya nahi check karna

## Next
- Part 8: roadmap progress, XP, streak, badges (local), details `docs/NEXT_TASK.md` mein

## Known notes
- Project hamesha `C:\dev` mein rakho, OneDrive mein nahi.
- `git add -A` mat karna: linux/macos/windows ki generated_plugin files auto-modify hoti hain. Specific paths add karo.
- Checkpoint ke const constructor mein `options.length` use nahi ho sakta, isliye upper-bound range check test mein hota hai.
- Package naam `abhay` hi rehna chahiye (tests `package:abhay/...` import karte hain). Folder ka naam kuch bhi ho sakta hai.
- Lambi lines paste mein kat sakti hain, code ki lines 80 char ke andar rakho.
- ListView ka page test karte waqt `tester.view.physicalSize = Size(800, 3000)` set karo.
- Nayi file banane se pehle check karo ki path pehle se maujood to nahi; paste hamesha sahi tab (path dekh ke) mein karo.
- Generator mein har step par `List.of(a)` copy zaroori hai, warna baad ke swaps purane steps badal dete hain.
- Test chalane se pehle check karo ki nayi test file mein code paste + save hua ho (khali file se count kam aata hai).