# Agla Task: Part 9 - Backend Basics (Node.js + Express + MongoDB)

**Goal:** App ke liye pehla backend: server chale, MongoDB se jude, health check aur topics API de. Abhi app se connect nahi hoga (wo Part 11).
**Git tag at end:** `phase-6-backend-basics`

## Pehle faisle (Session 0, baat-cheet)
1. Backend ka folder: alag repo ya isi repo mein `backend/`? (Suggestion: isi repo mein `backend/`, ek hi git)
2. MongoDB: local install ya Atlas (free cloud)? (Suggestion: Atlas free tier)
3. Node.js version check: `node -v`, `npm -v`

## Kya banega
1. `backend/` folder: `npm init`, Express server, `.env` (secrets git mein kabhi nahi)
2. `GET /health` endpoint
3. MongoDB connection (Mongoose)
4. `Topic` model + `GET /api/topics` (abhi mock_data wale 18 topics seed se)
5. Basic error handling + tests (Jest + supertest)

## Rules
- Secrets (`.env`, DB password) kabhi commit nahi; `.gitignore` mein pehle daalo
- Contest scoring server-authoritative; user code normal API mein kabhi run nahi hota
- Practice problems sirf official links
- Windows/PowerShell commands

## Done kab maanenge
- [ ] `npm start` se server chalta hai, `/health` OK deta hai
- [ ] MongoDB se connect hota hai
- [ ] `GET /api/topics` 18 topics deta hai
- [ ] Backend tests pass
- [ ] `.env` git mein nahi hai
- [ ] `git tag phase-6-backend-basics` + push

## Chhote sessions mein
0. Faisle + Node check
1. Express server + /health + test
2. MongoDB connect
3. Topic model + seed + /api/topics
4. Docs + tag

## Uske baad
Part 10: login (signup/login, JWT). Part 11: Flutter app ko API se jodna (progress server par sync).