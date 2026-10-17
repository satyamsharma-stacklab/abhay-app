# ABHAY - See. Think. Solve.

A visual **DSA (Data Structures & Algorithms) learning and contest app**, built Hinglish-first for Indian students.

Instead of reading theory, the student **watches an algorithm run step by step**, then answers **exactly one checkpoint question** to prove they understood it.

> **Core loop:** Concept -> Hinglish explanation -> Visualization -> Interaction -> One question -> Feedback -> Practice -> Reward

---

## Current status (15-10-2026)

| Part | What | Status |
|---|---|---|
| 1 | Environment setup (Flutter, Android SDK) | Done (Android device run + debug APK pending) |
| 2 | Flutter foundation (theme, routing, 5-tab navigation, mock data) | **Done** (tag `phase-1-ui-ready`) |
| 3 | Visualization engine core (models, controller, generator interface) | **Done** (tag `phase-2a-engine-core`) |
| 4 | Visualization widgets (6 widgets) | **Done** (tag `phase-2b-viz-widgets`) |
| 5 | Binary Search + checkpoint (MVP-A) | **Done** (tag `phase-3a-binary-search`) |
| 6 | Linear Search + checkpoint | **Done** (tag `phase-3b-linear-search`) |
| 7 | Bubble / Selection / Insertion Sort | **Done** (tag `phase-4-sorting`) |
| 8 | Progress, XP, streak, badges (local) = MVP-B | **Done** (tag `phase-5-progress`) |
| 9 | Backend basics (Node, Express, MongoDB) | **Next** |
| 10-15 | Login, API connect, practice, contests, release | Planned |

### What has been done
- Light and dark theme (Material 3), routing, 5-tab bottom navigation: **Home, Roadmap, Visualize, Contest, Profile**.
- All default text is Hinglish and lives in one file (`lib/core/constants/strings.dart`).
- **Visualization engine** (pure Dart) and **widgets** (array, pointers, code panel, explanation, controls, player, checkpoint card).
- **Five algorithms**: Linear Search, Binary Search, Bubble Sort, Selection Sort, Insertion Sort. Each has a generator, code lines, and exactly one checkpoint question. A generic `AlgorithmPage` runs them all.
- **Real progress (local):** a correct checkpoint answer completes the topic and gives XP (+20 first time, +5 practice, 0 for wrong answers), streak, and badges. Saved with `shared_preferences`, so it survives app restarts. Home, Roadmap and Profile show it.
- 195 automated tests, all passing.
- Git tags: `phase-1-ui-ready`, `phase-2a-engine-core`, `phase-2b-viz-widgets`, `phase-3a-binary-search`, `phase-3b-linear-search`, `phase-4-sorting`, `phase-5-progress`.

---

## What to do next

### Part 9 - Backend basics (next)
1. Express server with a `/health` endpoint
2. MongoDB connection (Mongoose)
3. Topic model and `GET /api/topics`
4. Backend tests

Tag when done: `phase-6-backend-basics`.

### After that
- **Parts 10-11:** login (JWT), and connecting the app to the API (progress synced to the server).
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
      features/   home, roadmap, visualization, algorithms, progress, contest, profile
        visualization/engine/    models, controller, generator interface
        visualization/widgets/   array, pointers, code panel, controls, player, checkpoint card
        algorithms/              algorithm_page + binary_search, linear_search, bubble_sort,
                                 selection_sort, insertion_sort (generator, code, page)
        progress/                state, service, repository, controller, scope, badges
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