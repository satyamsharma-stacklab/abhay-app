# Agla Task: Part 4 — Visualization Widgets

**Goal:** Reusable UI widgets banana jo Part 3 ke engine ko screen par dikhaye. Abhi koi specific algorithm nahi.
**Git tag at end:** `phase-2b-viz-widgets`

## Kya banega (`lib/features/visualization/widgets/` mein)
1. `ArrayVisualizer`: array ke boxes, highlight aur labels
2. `PointerMarker`: LOW / MID / HIGH jaise pointers index ke upar
3. `CodePanel`: code lines, current codeLine highlight
4. `ExplanationBox`: Hinglish explanation text
5. `ControlsBar`: play, pause, next, previous, restart, speed
6. `VisualizationPlayer`: sab ko jodke ek screen (VisualizationController use karta hai)

## Rules
- Widgets sirf VisualizationState/Step render karte hain, algorithm nahi jaante
- Colour ke saath icon/label bhi (sirf colour par depend nahi)
- Text Hinglish, lib/core/constants/strings.dart mein
- Widget tests likhna

## Done kab maanenge
- [ ] Widgets bane, FakeGenerator jaise sample data se dikhte hain
- [ ] `flutter analyze` + `flutter test` pass
- [ ] `git tag phase-2b-viz-widgets` + push

## Uske baad
Part 5: Binary Search + checkpoint question (MVP-A complete).