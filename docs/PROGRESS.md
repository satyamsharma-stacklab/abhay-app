# Progress (12-10-2026)

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
- `lib/features/algorithms/binary_search/`: binary_search_code.dart, binary_search_generator.dart, checkpoint_card.dart (reusable CheckpointCard), binary_search_page.dart
- Pointers LOW / MID / HIGH, Hinglish explanation, ek checkpoint sawaal
- Visualize tab se "Dekho" button se khulta hai
- `flutter test`: +64 All tests passed
- Git tag: `phase-3a-binary-search` (commit 34d57dd)

### Part 6 - Linear Search (DONE)
- `lib/features/algorithms/linear_search/`: linear_search_code.dart, linear_search_generator.dart, linear_search_page.dart
- Pointer `I`; har index par `check` step, mismatch par `next` step; aakhri element ke baad `next` nahi
- Unsorted array [7, 3, 9, 1, 5], target 9; duplicate mein pehla match
- Checkpoint: worst case mein kitne elements check hote hain (sahi: option 0, O(n))
- CheckpointCard `binary_search` folder se reuse hota hai
- `visualize_page.dart`: `_readyIds` + `_pageFor` switch (dono saath update karne hain)
- Tests: generator 16, page 5, visualize_open 3
- `flutter analyze`: No issues found
- `flutter test`: +87 All tests passed
- Git tag: `phase-3b-linear-search`

### Git / Repo setup (DONE)
- Repo: `satyamsharma-stacklab/abhay-app` (private)
- Commit author fix: sab commits `satyamsharma-stacklab` (noreply email) se hain
- Main working folder: `C:\dev\abhay_clone`; purana `C:\dev\abhay_app` sirf backup

## Pending (chhote items)
- [ ] Android emulator/phone par app chalana
- [ ] `flutter build apk --debug` (debug APK banana)
- [ ] Git tag `phase-0-ready` (Android run ke baad)
- [ ] Part 2 ke 3 manual checks: Roadmap labels, Dark mode switch, Home button -> Visualize tab
- [ ] Cleanup: `CheckpointCard` ko shared folder mein le jana
- [ ] Cleanup: `AppStrings` ke `bs...` checkpoint strings ko `cp...` naam dena
- [ ] Soch: generic `AlgorithmPage` refactor (Part 7 se pehle)

## Next
- Part 7: Bubble / Selection / Insertion Sort, details `docs/NEXT_TASK.md` mein

## Known notes
- Project hamesha `C:\dev` mein rakho, OneDrive mein nahi.
- `git add -A` mat karna: linux/macos/windows ki generated_plugin files auto-modify hoti hain. Specific paths add karo.
- Checkpoint ke const constructor mein `options.length` use nahi ho sakta, isliye upper-bound range check test mein hota hai.
- Package naam `abhay` hi rehna chahiye (tests `package:abhay/...` import karte hain). Folder ka naam kuch bhi ho sakta hai.
- Lambi lines paste mein kat sakti hain, code ki lines 80 char ke andar rakho.
- ListView ka page test karte waqt `tester.view.physicalSize = Size(800, 3000)` set karo.
- Nayi file banane se pehle check karo ki path pehle se maujood to nahi; paste hamesha sahi tab (path dekh ke) mein karo.