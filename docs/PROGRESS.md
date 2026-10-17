# Progress (15-10-2026)

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
- Git tag: `phase-1-ui-ready` (commit 5088c6f)

### Part 3 - Visualization Engine Core (DONE)
- Models: VisualizationState, VisualizationStep, Checkpoint, Visualization (+ Complexity)
- VisualizationController: play, pause, next, previous, restart, setSpeed (0.25x-4x), currentStep, isFinished, isAtStart
- AlgorithmGenerator abstract interface (deterministic steps)
- Git tag: `phase-2a-engine-core` (commit 1afce12)

### Part 4 - Visualization Widgets (DONE)
- `lib/features/visualization/widgets/`: ArrayVisualizer, PointerMarker, CodePanel, ExplanationBox, ControlsBar, VisualizationPlayer
- Colour ke saath icon/label (active = aankh, highlighted = tick, code line = arrow)
- Git tag: `phase-2b-viz-widgets` (commit 6d7f3c4)

### Part 5 - Binary Search + Checkpoint (DONE, MVP-A)
- `lib/features/algorithms/binary_search/`: code, generator, page
- Git tag: `phase-3a-binary-search` (commit 34d57dd)

### Part 6 - Linear Search (DONE)
- `lib/features/algorithms/linear_search/`: code, generator, page
- Git tag: `phase-3b-linear-search` (commit 42ce9f3)

### Part 7 - Sorting (DONE)
- Bubble, Selection, Insertion Sort (generator + code + page + ek checkpoint har ek ka)
- `CheckpointCard` shared (`visualization/widgets/`), strings `cp...`
- Git tag: `phase-4-sorting` (commit e1d38fc)

### Part 8 - Progress, XP, Streak, Badges (DONE, MVP-B)
- S0: generic `AlgorithmPage` (`lib/features/algorithms/algorithm_page.dart`), paanchon pages 15-line wrappers; dead strings hataye - 3751a94
- S1: `ProgressState` (immutable) + `ProgressService` (pure Dart, date inject): pehli baar sahi +20 XP, dobara practice +5 (roz ek topic par ek baar), galat par 0; streak (kal tha to +1, warna 1) - 4612a7f
- S2: `ProgressRepository` (`shared_preferences`, date `YYYY-MM-DD` text, kharab data par khali state) - d88cf1f
- S3: `ProgressController` (ChangeNotifier) + `ProgressScope` (InheritedNotifier); `CheckpointCard(topicId)` sahi jawab par `recordCorrect` - 24aa7a3
- S4: `app.dart`/`main.dart` mein scope + async load, 5 wrappers mein `topicId` - 03651ac
- S5: Home, Roadmap, Profile par asli progress (`topic_status.dart`: `resolveTopics`, `currentTopic`) - ccce634
- S6: `BadgeService` (First Visualization, Binary Search Master, Sorting Explorer, 7 Day Streak; Contest Starter abhi locked), Profile par asli badges - b64e5b7
- Chrome par asli flow verify hua: galat par XP 0, sahi par +20, Roadmap status, refresh ke baad progress bacha
- `flutter analyze`: No issues found
- `flutter test`: +195 All tests passed
- Git tag: `phase-5-progress`

### Git / Repo setup (DONE)
- Repo: `satyamsharma-stacklab/abhay-app` (private)
- Commit author fix: sab commits `satyamsharma-stacklab` (noreply email) se hain
- Main working folder: `C:\dev\abhay_clone`; purana `C:\dev\abhay_app` sirf backup

## Pending (chhote items)
- [ ] Android emulator/phone par app chalana (Chrome par check ho chuka)
- [ ] `flutter build apk --debug` (debug APK banana)
- [ ] Git tag `phase-0-ready` (Android run ke baad)
- [ ] Home par "weak topics" abhi hamesha khali (tracking baad ke part mein)
- [ ] Home par naam aur daily goal target abhi mock (`MockData.user`), login ke baad asli
- [ ] Profile/Home par mock data (contests) Part 11 mein API se replace hoga

## Next
- Part 9: Node.js + Express + MongoDB backend, details `docs/NEXT_TASK.md` mein

## Known notes
- Project hamesha `C:\dev` mein rakho, OneDrive mein nahi.
- `git add -A` mat karna: linux/macos/windows ki generated_plugin files auto-modify hoti hain. Specific paths add karo.
- Checkpoint ke const constructor mein `options.length` use nahi ho sakta.
- Package naam `abhay` hi rehna chahiye (tests `package:abhay/...` import karte hain).
- Lambi lines paste mein kat sakti hain, code ki lines 80 char ke andar rakho.
- ListView ka page test karte waqt `tester.view.physicalSize = Size(800, 3000)` set karo.
- Nayi file banane se pehle check karo ki path pehle se maujood to nahi; paste sahi tab (path dekh ke) mein karo, aur `Ctrl+S` zaroor.
- Generator mein har step par `List.of(a)` copy zaroori hai.
- Test chalane se pehle check karo ki nayi test file mein code paste + save hua ho (khali file se count kam aata hai).
- Nayi algorithm = ~15-line wrapper (`AlgorithmPage`) + `visualize_page.dart` mein `_readyIds` aur `_pageFor` dono.
- Progress logic mein `DateTime.now()` seedha nahi, controller ko `now` inject hota hai.