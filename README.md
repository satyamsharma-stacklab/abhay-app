# ABHAY — See. Think. Solve.

A visual **DSA (Data Structures & Algorithms) learning and contest app**, built Hinglish-first for Indian students.

Instead of reading theory, the student **watches an algorithm run step by step**, then answers **exactly one checkpoint question** to prove they understood it.

> **Core loop:** Concept → Hinglish explanation → Visualization → Interaction → One question → Feedback → Practice → Reward

---

## Current status (11-10-2026)

| Part | What | Status |
|---|---|---|
| 1 | Environment setup (Flutter, Android SDK) | Done (Android device run + debug APK pending) |
| 2 | Flutter foundation (theme, routing, 5-tab navigation, mock data) | **Done** (tag `phase-1-ui-ready`) |
| 3 | Visualization engine core (models, controller, generator interface) | **Done** (tag `phase-2a-engine-core`) |
| 4 | Visualization widgets (6 widgets, 49 tests) | **Done** (tag `phase-2b-viz-widgets`) |
| 5 | Binary Search + checkpoint (MVP-A) | **Next** |
| 6-15 | More algorithms, progress, backend, practice, contests, release | Planned |

### What has been done
- Flutter 3.47.6 and Android Studio / Android SDK set up on Windows.
- Flutter app (`com.abhay.abhay`) with folders: `app`, `core`, `features`, `shared`.
- Light and dark theme (Material 3), routing, 5-tab bottom navigation: **Home, Roadmap, Visualize, Contest, Profile**.
- Screens with mock data: Home, Roadmap (18 topics), Visualize (list), Contest, Profile.
- All default text is Hinglish and lives in one file (`lib/core/constants/strings.dart`).
- **Visualization engine (Part 3)**, pure Dart, in `lib/features/visualization/engine/`:
  `VisualizationState`, `VisualizationStep`, `Checkpoint`, `Visualization`, `VisualizationController`, `AlgorithmGenerator`.
- **Visualization widgets (Part 4)** in `lib/features/visualization/widgets/`:
  `ArrayVisualizer`, `PointerMarker`, `CodePanel`, `ExplanationBox`, `ControlsBar`, `VisualizationPlayer`.
  Colour is always paired with an icon or label.
- 49 automated tests, all passing.
- Git tags: `phase-1-ui-ready`, `phase-2a-engine-core`, `phase-2b-viz-widgets`.

---

## What to do next

### Part 5 — Binary Search + Checkpoint (next, completes MVP-A)
1. `BinarySearchGenerator` (LOW / MID / HIGH steps, Hinglish explanation, code line mapping)
2. Binary Search code text for the `CodePanel`
3. Exactly one checkpoint question with feedback
4. A page that runs the `VisualizationPlayer`, then shows the checkpoint
5. Make Binary Search playable from the Visualize tab
6. Unit tests (found, not found, single element, empty, deterministic)

Tag when done: `phase-3a-binary-search`.

### After that
- **Parts 6-8:** Linear Search, Bubble / Selection / Insertion Sort, then roadmap progress with XP, streak and badges.
- **Parts 9-11:** Node.js + Express + MongoDB backend, login, and connecting the app to the API.
- **Parts 12-14:** practice problems (CodeChef → GeeksforGeeks → LeetCode → HackerRank), ABHAY contests, "Visualize Mistake".
- **Part 15:** Android release build.

Full details: [`docs/ROADMAP.md`](docs/ROADMAP.md) · [`docs/NEXT_TASK.md`](docs/NEXT_TASK.md) · [`docs/PROGRESS.md`](docs/PROGRESS.md)

---

## Tech stack
- **App:** Flutter (Android-first), Dart
- **Backend (planned):** Node.js, Express, MongoDB
- **Later:** Redis leaderboard, sandboxed code judge

## Project structure
```
lib/
  app/        theme, routes, bottom-nav shell
  core/       constants, models, mock data, utils
  features/   home, roadmap, visualization, contest, profile
    visualization/engine/    models, controller, generator interface
    visualization/widgets/   array, pointers, code panel, controls, player
  shared/     reusable widgets
test/         widget and unit tests
docs/         progress, roadmap, next task, setup notes
```

## Run locally
```bash
flutter pub get
flutter analyze
flutter test
flutter run -d chrome     # quick UI check
flutter run               # Android device or emulator
```
The package name must stay `abhay` (tests import `package:abhay/...`). The folder name can be anything.

## Workflow
One part at a time. After each part: analyze, test, commit, tag, push.
Do not use `git add -A` (Flutter auto-modifies generated plugin files in `linux/`, `macos/`, `windows/`). Add specific paths instead.
```bash
git add <specific paths>
git commit -m "Part N: what was done"
git tag phase-xxx
git push && git push --tags
```

## Design rules
1. Visualization is the main feature. Every lesson ends with exactly one checkpoint question.
2. Algorithms only *generate* states; the renderer only *renders* states.
3. Practice problems link to the official source; problem statements are never copied.
4. Contest scoring is server-authoritative. User code is never run in the normal API.
5. Rewards are for understanding, not for watch time.