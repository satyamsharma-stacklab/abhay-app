# ABHAY - See. Think. Solve.

A visual **DSA (Data Structures & Algorithms) learning and contest app**, built Hinglish-first for Indian students.

Instead of reading theory, the student **watches an algorithm run step by step**, then answers **exactly one checkpoint question** to prove they understood it.

> **Core loop:** Concept -> Hinglish explanation -> Visualization -> Interaction -> One question -> Feedback -> Practice -> Reward

---

## Current status (14-10-2026)

| Part | What | Status |
|---|---|---|
| 1 | Environment setup (Flutter, Android SDK) | Done (Android device run + debug APK pending) |
| 2 | Flutter foundation (theme, routing, 5-tab navigation, mock data) | **Done** (tag `phase-1-ui-ready`) |
| 3 | Visualization engine core (models, controller, generator interface) | **Done** (tag `phase-2a-engine-core`) |
| 4 | Visualization widgets (6 widgets) | **Done** (tag `phase-2b-viz-widgets`) |
| 5 | Binary Search + checkpoint (MVP-A) | **Done** (tag `phase-3a-binary-search`) |
| 6 | Linear Search + checkpoint | **Done** (tag `phase-3b-linear-search`) |
| 7 | Bubble / Selection / Insertion Sort | **Done** (tag `phase-4-sorting`) |
| 8 | Progress, XP, streak, badges (local) = MVP-B | **Next** |
| 9-15 | Backend, login, practice, contests, release | Planned |

### What has been done
- Light and dark theme (Material 3), routing, 5-tab bottom navigation: **Home, Roadmap, Visualize, Contest, Profile**.
- Screens with mock data: Home, Roadmap (18 topics), Visualize (list), Contest, Profile.
- All default text is Hinglish and lives in one file (`lib/core/constants/strings.dart`).
- **Visualization engine (Part 3)**, pure Dart, in `lib/features/visualization/engine/`:
  `VisualizationState`, `VisualizationStep`, `Checkpoint`, `Visualization`, `VisualizationController`, `AlgorithmGenerator`.
- **Visualization widgets (Part 4)** in `lib/features/visualization/widgets/`:
  `ArrayVisualizer`, `PointerMarker`, `CodePanel`, `ExplanationBox`, `ControlsBar`, `VisualizationPlayer`, and the shared `CheckpointCard`.
  Colour is always paired with an icon or label.
- **Five algorithms** in `lib/features/algorithms/`: Binary Search, Linear Search, Bubble Sort, Selection Sort, Insertion Sort.
  Each has a generator, code lines, a page, and exactly one checkpoint question. All open from the Visualize tab ("Dekho" button).
- 157 automated tests, all passing.
- Git tags: `phase-1-ui-ready`, `phase-2a-engine-core`, `phase-2b-viz-widgets`, `phase-3a-binary-search`, `phase-3b-linear-search`, `phase-4-sorting`.

---

## What to do next

### Part 8 - Progress, XP, streak, badges (next, completes MVP-B)
Session 0 is a small cleanup (generic `AlgorithmPage`). Then:
1. `ProgressService` (pure Dart): correct checkpoint completes a topic and gives XP
2. Local storage with `shared_preferences`
3. Streak and badges
4. Home, Roadmap and Profile show real progress instead of mock data

Tag when done: `phase-5-progress`.

### After that
- **Parts 9-11:** Node.js + Express + MongoDB backend, login, and connecting the app to the API.
- **Parts 12-14:** practice problems (CodeChef -> GeeksforGeeks -> LeetCode -> HackerRank), ABHAY contests, "Visualize Mistake".
- **Part 15:** Android release build.

Full details: [`docs/ROADMAP.md`](docs/ROADMAP.md) | [`docs/NEXT_TASK.md`](docs/NEXT_TASK.md) | [`docs/PROGRESS.md`](docs/PROGRESS.md)

---

## Tech stack
- **App:** Flutter (Android-first), Dart
- **Backend (planned):** Node.js, Express, MongoDB
- **Later:** Redis leaderboard, sandboxed code judge

## Project structure

    lib/
      app/        theme, routes, bottom-nav shell
      core/       constants, models, mock data, utils
      features/   home, roadmap, visualization, algorithms, contest, profile
        visualization/engine/    models, controller, generator interface
        visualization/widgets/   array, pointers, code panel, controls, player, checkpoint card
        algorithms/              binary_search, linear_search, bubble_sort,
                                 selection_sort, insertion_sort (generator, code, page)
      shared/     reusable widgets
    test/         widget and unit tests
    docs/         progress, roadmap, next task, setup notes

## Run locally

    flutter pub get
    flutter analyze
    flutter test
    flutter run -d chrome     # quick UI check
    flutter run               # Android device or emulator

The package name must stay `abhay` (tests import `package:abhay/...`). The folder name can be anything.

## Workflow
One part at a time. After each part: analyze, test, commit, tag, push.
Do not use `git add -A` (Flutter auto-modifies generated plugin files in `linux/`, `macos/`, `windows/`). Add specific paths instead.

    git add <specific paths>
    git commit -m "Part N: what was done"
    git tag phase-xxx
    git push && git push --tags

## Design rules
1. Visualization is the main feature. Every lesson ends with exactly one checkpoint question.
2. Algorithms only *generate* states; the renderer only *renders* states.
3. Practice problems link to the official source; problem statements are never copied.
4. Contest scoring is server-authoritative. User code is never run in the normal API.
5. Rewards are for understanding, not for watch time.