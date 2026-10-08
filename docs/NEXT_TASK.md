# Agla Task: Part 3 — Visualization Engine Core

**Goal:** Pure Dart logic banana: steps ki list, aur play/pause/next/previous/restart/speed wala controller. **Abhi koi UI nahi.**
**Estimated time:** 1-2 hours  |  **Git tag at end:** `phase-2a-engine-core`

## Kyun ye pehle?
Visualization ABHAY ka sabse bada feature hai. Agar engine algorithm-agnostic (kisi algorithm se bandha hua nahi) banega, to Binary Search, Sorting, sab usi par chalenge. Logic pehle banake tests se pakka karte hain, phir UI (Part 4) uske upar lagti hai.

## Kya banega (`lib/features/visualization/` mein)
1. `Visualization` model: id, algorithmId, title, initialState, steps[], checkpoint, complexity
2. `VisualizationStep`: index, state, operation, explanationHinglish, codeLine, highlights, durationMs
3. `VisualizationState`: array, pointers (LOW/MID/HIGH), highlighted indices, labels
4. `VisualizationController`: play, pause, next, previous, restart, setSpeed, currentStep, isFinished
5. `AlgorithmGenerator` (abstract): deterministic steps banata hai
6. `Checkpoint` model + answer checking (pure Dart)

## Rules
- Controller koi bhi specific algorithm nahi jaanta
- Har step deterministic hona chahiye
- Unit tests: next/prev bounds, restart, finish, answer checking

## Kaise shuru karna hai
Claude chat mein bolo: **"Part 3 shuru karo"** (ya `03_Viz_Engine_Core.zip` ke `01_CORE_CONTEXT.md` + `02_PROMPT.md` do).

## Done kab maanenge
- [ ] Models + controller bane
- [ ] Controller kisi algorithm ko hard-code nahi karta
- [ ] Next/Previous bounds sahi
- [ ] `flutter analyze` + `flutter test` pass
- [ ] `git tag phase-2a-engine-core` + `git push --tags`

## Uske baad
Part 4 (widgets: ArrayVisualizer, pointers, code panel, controls) -> Part 5 (Binary Search + checkpoint).

## Optional pehle (agar time ho)
Android par app chalao + `flutter build apk --debug` (Part 1 band karne ke liye).
