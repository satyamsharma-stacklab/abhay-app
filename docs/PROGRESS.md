# Progress (20-10-2026)

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

### Part 9 - Backend Basics (DONE)
- Backend isi repo ke `backend/` folder mein (Node, Express, Mongoose, Jest + supertest); database MongoDB Atlas
- S1: Express server, `GET /health` (`{ status: "ok", service: "abhay-backend" }`) + tests - e0c9d39
- S2: MongoDB connection (Mongoose, dotenv), `src/db.js`, db connection test - 71a60cd, 48417df
- S3: `Topic` model, seed (18 topics), `GET /api/topics`; server start par seed DB mein upsert hota hai - d73043f, f7a72d6
- S3 fix: Windows par Atlas SRV lookup (`querySrv ECONNREFUSED`) public DNS (8.8.8.8, 1.1.1.1) se theek kiya - 61f395b
- `GET /api/topics` response `{ topics: [...] }` deta hai (PowerShell mein `$r.topics.Count`)
- Git tag: `phase-6-backend-basics` (commit e4ed265)

### Part 10 - Login: Signup, Login, JWT, /api/me (DONE)
- Faisle: email + password, `bcryptjs` (pure JS), token 7 din (HS256)
- S1: `src/auth/password.js` (`validatePassword` kam se kam 8 akshar, max 72 byte; `hashPassword`; `verifyPassword`), `src/models/user.js` (name, email lowercase+unique, passwordHash, createdAt, `toPublic()`), tests - d7b7da0
- S2: `src/routes/auth.js` `POST /api/auth/signup` (400 galat data, 409 duplicate email, 201 user), auth `app.js` mein juda, kharab JSON par 400 - 98c30c1
- S3: `src/auth/token.js` (`signToken`, `verifyToken`, `checkSecret`), `POST /api/auth/login`; signup aur login dono `{ user, token }` dete hain; galat email aur galat password dono par same 401 "Email ya password galat hai" (email na milne par bhi nakli hash se password check hota hai, taaki samay se pata na chale); `server.js` JWT_SECRET check karta hai - 5ef6987
- S4: `src/auth/middleware.js` (`requireAuth`, `readBearerToken`), `GET /api/me` (Bearer token), `server.js` mein `findUserById` - b8ae9bb
- `passwordHash` ya password kisi response mein nahi aata (tests mein check hota hai)
- Asli database par live check hua: signup, duplicate 409, chhota password 400, login, galat login 401, `/api/me` bina token 401, sahi token par user, kharab token 401
- Test users (`test1@example.com`, `test2@example.com`) Atlas se hata diye; `users` collection khali
- Atlas IP list saaf ki: sirf abhi ka IP rakha
- `npm test` (backend): 8 suites, 59 tests pass
- Git tag: `phase-7-login`

### Git / Repo setup (DONE)
- Repo: `satyamsharma-stacklab/abhay-app` (private)
- Commit author fix: sab commits `satyamsharma-stacklab` (noreply email) se hain
- Main working folder: `C:\dev\abhay_clone`; purana `C:\dev\abhay_app` sirf backup

## Pending (chhote items)
- [ ] Android emulator/phone par app chalana (Chrome par check ho chuka)
- [ ] `flutter build apk --debug` (debug APK banana)
- [ ] Git tag `phase-0-ready` (Android run ke baad)
- [ ] Home par "weak topics" abhi hamesha khali (tracking baad ke part mein)
- [ ] Home par naam aur daily goal target abhi mock (`MockData.user`), Part 11 mein login ke baad asli
- [ ] Profile/Home par mock data (contests) Part 11 mein API se replace hoga
- [ ] App abhi API use nahi karti (Part 11)
- [ ] Backend abhi sirf local chalta hai (deploy baad mein, Part 15 ke aas-paas)
- [ ] `npm audit` mein 19 moderate warnings (`npm audit fix --force` mat chalana)
- [ ] `git add` par "LF will be replaced by CRLF" warning aati hai (Windows line-ending, harmless)

## Next
- Part 11: Flutter app ko API se jodna (signup/login screens, token store, progress sync), details `docs/NEXT_TASK.md` mein

## Known notes
- Project hamesha `C:\dev` mein rakho, OneDrive mein nahi.
- `git add -A` mat karna: linux/macos/windows ki generated_plugin files auto-modify hoti hain. Specific paths add karo.
- Checkpoint ke const constructor mein `options.length` use nahi ho sakta.
- Package naam `abhay` hi rehna chahiye (tests `package:abhay/...` import karte hain).
- Lambi lines paste mein kat sakti hain, code ki lines 80 char ke andar rakho. Lambi file (130+ lines) ek baar mein paste karne par kat sakti hai, do hisson mein paste  karo.
- ListView ka page test karte waqt `tester.view.physicalSize = Size(800, 3000)` set karo.
- Nayi file banane se pehle check karo ki path pehle se maujood to nahi; paste sahi tab (path dekh ke) mein karo, aur `Ctrl+S` zaroor. Save na hui file par `Get-Content` "does not exist" deta hai.
- Generator mein har step par `List.of(a)` copy zaroori hai.
- Test chalane se pehle check karo ki nayi test file mein code paste + save hua ho (khali file se count kam aata hai).
- Nayi algorithm = ~15-line wrapper (`AlgorithmPage`) + `visualize_page.dart` mein `_readyIds` aur `_pageFor` dono.
- Progress logic mein `DateTime.now()` seedha nahi, controller ko `now` inject hota hai.
- Backend: `npm start` par "MongoDB connect nahi hua ... IP whitelist" aaye to Atlas > Network Access > IP Access List mein "Add Current IP Address" karo. Ghar ke internet ka IP badalta rehta hai, to ye dobara hoga. "Allow access from anywhere" (0.0.0.0/0) mat chuno.
- Backend: `.env` mein `MONGODB_URI` aur `JWT_SECRET` hain. `.env` ka content kabhi chat ya git mein mat bhejo.
- Backend: "Route nahi mila" ya "Unable to connect" aaye to pehle dekho port 3000 par purana `node` server to nahi chal raha: `Get-NetTCPConnection -LocalPort 3000 -State Listen`, phir `Stop-Process -Id <PID>` (naam `node` ho tabhi).
- Backend: PowerShell mein lambi command ek hi line mein paste karo, warna beech mein toot jaati hai.
- Backend tests mein Mongoose ka `validate()` use hota hai (`validateSync()` deprecated hai).
- Atlas Data Explorer mein document hatane ka button "Remove document" (trash icon) hai.