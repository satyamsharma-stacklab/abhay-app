# ABHAY — See. Think. Solve.

A visual **DSA (Data Structures & Algorithms) learning and contest app**, built Hinglish-first for Indian students.

Instead of reading theory, the student **watches an algorithm run step by step**, then answers **exactly one checkpoint question** to prove they understood it.

> **Core loop:** Concept → Hinglish explanation → Visualization → Interaction → One question → Feedback → Practice → Reward

---

## Current status (10-10-2026)

| Part | What | Status |
|---|---|---|
| 1 | Environment setup (Flutter, Android SDK) | Done (Android device run + debug APK pending) |
| 2 | Flutter foundation (theme, routing, 5-tab navigation, mock data) | **Done** (tag `phase-1-ui-ready`) |
| 3 | Visualization engine core (models, controller, generator interface, 23 tests) | **Done** (tag `phase-2a-engine-core`) |
| 4 | Visualization widgets | **Next** |
| 5-15 | Binary Search, algorithms, progress, backend, practice, contests, release | Planned |

### What has been done
- Flutter 3.47.6 and Android Studio / Android SDK set up on Windows.
- Flutter app created (`com.abhay.abhay`) with a clean folder structure: `app`, `core`, `features`, `shared`.
- Light and dark theme (Material 3), routing, and a 5-tab bottom navigation: **Home, Roadmap, Visualize, Contest, Profile**.
- Reusable widgets: `AbhayCard`, `AbhayButton`, `SectionHeader`, `StatChip`.
- Screens built with mock data:
  - **Home:** streak, XP, daily goal, continue-learning card, upcoming contest, weak topics.
  - **Roadmap:** 18 DSA topics with locked / unlocked / completed states (icon + label, not colour alone).
  - **Visualize:** list of algorithms (visualizations coming in Parts 4-5).
  - **Contest:** Upcoming / Live / Completed tabs.
  - **Profile:** XP, streak, badges, completed topics, dark-mode switch.
- All default text is Hinglish and lives in one file (`lib/core/constants/strings.dart`).
- **Visualization engine core (Part 3)**, pure Dart, no UI, in `lib/features/visualization/engine/`:
  - Models: `VisualizationState`, `VisualizationStep`, `Checkpoint` (with answer checking), `Visualization` (+ `Complexity`).
  - `VisualizationController`: play, pause, next, previous, restart, speed (0.25x to 4x).
  - `AlgorithmGenerator`: abstract interface for deterministic step generation.
- 23 automated tests, all passing (navigation, dark mode, roadmap labels, daily goal, checkpoint, controller).
- Git tags: `phase-1-ui-ready`, `phase-2a-engine-core`.

---

## What to do next

### Part 4 — Visualization Widgets (next)
Reusable widgets in `lib/features/visualization/widgets/` that render the engine:
1. `ArrayVisualizer` (array boxes, highlights, labels)
2. `PointerMarker` (LOW / MID / HIGH above the index)
3. `CodePanel` (current code line highlighted)
4. `ExplanationBox` (Hinglish explanation)
5. `ControlsBar` (play, pause, next, previous, restart, speed)
6. `VisualizationPlayer` (joins everything using `VisualizationController`)

Widgets only render state; they never know a specific algorithm. Colour is always paired with an icon or label. Tag when done: `phase-2b-viz-widgets`.

### After that
- **Part 5:** Binary Search + the mandatory checkpoint question. *This completes MVP-A.*
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
    visualization/engine/   models, controller, generator interface