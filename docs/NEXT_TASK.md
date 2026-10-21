# Agla Task: Part 11 - App ko API se jodna (Login, Token, Progress Sync)

**Goal:** Flutter app backend se baat kare: user signup/login kare, token phone mein save rahe, aur progress server par sync ho. Mock data (naam, daily goal) asli data se badle.
**Git tag at end:** `phase-8-api-connect`

## Pehle faisle (Session 0, baat-cheet)
1. HTTP package: `http` (simple) ya `dio`? (Suggestion: `http`, kam setup)
2. Token kahan save ho: `flutter_secure_storage` ya `shared_preferences`? (Suggestion: `flutter_secure_storage`, token secret hota hai. Chrome par wo kaam nahi karta, to Chrome ke liye `shared_preferences` fallback soch lena)
3. Backend ka address: Android emulator par `http://10.0.2.2:3000`, Chrome par `http://localhost:3000`. App ke andar ek jagah (`lib/core/constants/api_config.dart`) rakho.
4. Progress sync ka tareeka: login ke baad local progress aur server progress ka milan kaise ho? (Pehle server par progress ka model aur endpoint banana padega, wo Session 3-4 mein)
5. Purane `test1/test2` users Atlas se hata diye gaye hain, naya signup app se hi hoga.

## Kya banega
1. Flutter mein `ApiClient` (pure Dart, HTTP bahar se inject, taaki tests mein nakli aa sake)
2. `AuthRepository` + `AuthController` (signup, login, logout, token save/load) + tests
3. Signup aur Login screens (Hinglish text `strings.dart` mein, colour ke saath icon/label)
4. Backend par progress ka model aur endpoints (`GET/PUT /api/progress`, login zaroori) + tests
5. App ka progress server se sync (login ke baad)
6. Home/Profile par mock naam aur daily goal ki jagah asli data

## Rules
- Token kabhi log ya print nahi hota
- Wrong login par saaf Hinglish message, app crash nahi
- Internet na ho to app chalta rahe (local progress), sync baad mein
- Rewards understanding ke liye; XP ka hisaab server par bhi wahi niyam maane (galat jawab par XP nahi)
- Contest scoring server-authoritative; user code normal API mein kabhi run nahi hota
- Practice problems sirf official links
- Windows/PowerShell commands, lambi command ek hi line mein
- `git add -A` kabhi nahi, specific paths

## Done kab maanenge
- [ ] App se signup aur login hota hai
- [ ] Token phone mein save hai, app band karke kholne par login bana rehta hai
- [ ] Logout kaam karta hai
- [ ] Progress server par save hota hai aur login ke baad wapas aata hai
- [ ] Home/Profile par asli naam dikhta hai
- [ ] `flutter analyze` clean, `flutter test` pass, `npm test` pass
- [ ] `git tag phase-8-api-connect` + push

## Chhote sessions mein
0. Faisle + `lib/main.dart`, `lib/app/` ki files dekhna
1. `ApiClient` + `AuthRepository` + tests
2. `AuthController` + token storage + tests
3. Signup/Login screens
4. Backend par progress model + endpoints + tests
5. App par progress sync
6. Docs + tag

## Uske baad
Parts 12-14: practice problems (official links), ABHAY contests (server-authoritative scoring), "Visualize Mistake". Part 15: Android release build.