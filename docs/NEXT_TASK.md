# Agla Task: Part 10 - Login (Signup, Login, JWT)

**Goal:** Backend mein user signup aur login chale, password safe (hash) rahe, aur login ke baad ek token (JWT) mile jisse "main kaun hoon" pata chale. Abhi Flutter app se connect nahi hoga (wo Part 11).
**Git tag at end:** `phase-7-login`

## Pehle faisle (Session 0, baat-cheet)
1. Login kis se: email + password? (Suggestion: email + password, sabse simple)
2. Password hashing ke liye `bcryptjs` (pure JS, Windows par install mein dikkat nahi) ya `bcrypt`? (Suggestion: `bcryptjs`)
3. Token ki umar (expiry): kitne din? (Suggestion: 7 din)
4. Backend tests ka tareeka: Part 9 ke `tests/topics.test.js` jaisa hi rakhna hai? (Session 0 mein wo file dekhenge, andaza nahi)
5. Naya `.env` variable: `JWT_SECRET`. `.env.example` mein sirf placeholder jaayega, asli secret kabhi nahi.

## Kya banega
1. `User` model (Mongoose): naam, email (unique, chhote akshar mein), passwordHash, createdAt
2. `POST /api/auth/signup`: validation (email sahi, password kam se kam 8 akshar), password hash, user save, token
3. `POST /api/auth/login`: email + password check, sahi hone par token
4. Auth middleware: `Authorization: Bearer <token>` check karta hai
5. `GET /api/me`: token se user ka naam aur email (passwordHash kabhi nahi)
6. Error handling (galat password, duplicate email, token kharab) + tests

## Rules
- Password kabhi plain text mein save, log ya response mein nahi
- `passwordHash` kisi bhi response mein kabhi nahi jaata
- `JWT_SECRET` sirf `.env` mein; `.env` kabhi commit nahi
- Galat email aur galat password dono par same message ("email ya password galat") taaki koi pata na laga sake ki email register hai ya nahi
- Contest scoring server-authoritative; user code normal API mein kabhi run nahi hota
- Practice problems sirf official links
- Windows/PowerShell commands

## Done kab maanenge
- [ ] Signup se naya user banta hai, password hash hokar save hota hai
- [ ] Login sahi password par token deta hai, galat par 401
- [ ] Duplicate email par saaf error aata hai
- [ ] `GET /api/me` token ke saath user deta hai, bina token ke 401
- [ ] Kisi response mein `passwordHash` nahi
- [ ] Backend tests pass
- [ ] `.env` git mein nahi hai, `.env.example` mein `JWT_SECRET` placeholder hai
- [ ] `git tag phase-7-login` + push

## Chhote sessions mein
0. Faisle + `tests/topics.test.js` aur `src/app.js` dekhna
1. `User` model + password hashing + tests
2. Signup endpoint + tests
3. Login endpoint + JWT + tests
4. Auth middleware + `GET /api/me` + tests
5. Docs + tag

## Uske baad
Part 11: Flutter app ko API se jodna (signup/login screens, progress server par sync, mock data hatana).