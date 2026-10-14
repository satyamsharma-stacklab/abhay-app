# Agla Task: Part 8 - Progress, XP, Streak, Badges (MVP-B)

**Goal:** App ko "seekhne ka safar" banana: student ka progress yaad rahe, XP aur streak mile, badges khulein. Sab local (bina backend).
**Git tag at end:** `phase-5-progress`

## Pehle chhota cleanup (Session 0)
1. Generic `AlgorithmPage(generator, codeLines, input, target)` refactor: 5 pages ek jaise hain, ab ek page se chalao (`visualize_page.dart` ka `_pageFor` chhota ho jayega)
2. `bsTarget`, `bsFinishHint` strings check: use nahi ho rahi to hata do

## Kya banega
1. Local storage (`shared_preferences`): completed topics, XP, streak, last active date, badges
2. `ProgressService` (pure Dart logic, test karna aasan): checkpoint sahi hone par topic complete + XP
3. XP rules: sahi checkpoint = XP, pehli baar sahi = zyada XP, dobara practice = kam. Reward understanding ke liye, watch time ke liye nahi
4. Streak: roz kam se kam ek checkpoint sahi karo, din badalne par streak update
5. Badges (mock_data ke 5 badges): First Visualization, Binary Search Master, Sorting Explorer, 7 Day Streak, (Contest Starter baad mein)
6. Home, Roadmap, Profile ab mock nahi, asli progress dikhayein (topic status: completed / unlocked / locked)
7. Checkpoint sahi hone par `CheckpointCard` se `ProgressService` ko khabar

## Rules
- Logic UI se alag, same input -> same result (date inject karo, `DateTime.now()` seedha mat use karo)
- Colour ke saath icon/label
- Text Hinglish, `lib/core/constants/strings.dart` mein
- Rewards understanding ke liye: galat jawab par XP nahi

## Done kab maanenge
- [ ] Checkpoint sahi karne par XP aur topic complete save hota hai
- [ ] App band karke kholo to progress bacha rehta hai
- [ ] Streak aur badges sahi dikhte hain
- [ ] Roadmap topics ka status progress se aata hai
- [ ] `flutter analyze` + `flutter test` pass
- [ ] `git tag phase-5-progress` + push

## Chhote sessions mein
0. Cleanup (generic AlgorithmPage)
1. ProgressService + tests (pure Dart)
2. Local storage jodna (shared_preferences)
3. Checkpoint se progress save karna
4. Home / Roadmap / Profile par asli progress
5. Streak + badges
6. Docs update + tag

## Uske baad
Parts 9-11: Node.js + Express + MongoDB backend, login, API connect.