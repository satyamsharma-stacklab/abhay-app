const express = require('express');
const {
  validatePassword,
  hashPassword,
  verifyPassword,
} = require('../auth/password');
const { signToken, checkSecret } = require('../auth/token');

// Simple email check (models/user.js jaisa hi).
const EMAIL_PATTERN = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
const MAX_NAME = 50;
const DUPLICATE_MSG = 'Ye email pehle se registered hai';
// Email galat ho ya password, dono par yahi message (andaza na lage).
const LOGIN_FAIL_MSG = 'Email ya password galat hai';

// Signup ka data check. Sahi ho to null, galat ho to Hinglish message.
function validateSignup({ name, email, password }) {
  if (typeof name !== 'string' || name.trim().length === 0) {
    return 'Naam zaroori hai';
  }
  if (name.trim().length > MAX_NAME) {
    return `Naam ${MAX_NAME} akshar se chhota hona chahiye`;
  }
  if (typeof email !== 'string' || !EMAIL_PATTERN.test(email.trim())) {
    return 'Email sahi nahi hai';
  }
  return validatePassword(password);
}

// Auth routes. DB ke kaam bahar se aate hain (testing aasan rehti hai):
// findUserByEmail(email) aur createUser({ name, email, passwordHash }).
// jwtSecret: token ka secret, expiresIn: token ki umar (default 7 din).
function authRouter({
  findUserByEmail,
  createUser,
  rounds,
  jwtSecret,
  expiresIn,
}) {
  // Secret kamzor ho to router banta hi nahi.
  checkSecret(jwtSecret);
  const router = express.Router();

  // Ek nakli hash: email na mile tab bhi password check hota hai,
  // taaki jawab ke samay se pata na chale ki email registered hai.
  let dummyHash = null;
  async function getDummyHash() {
    if (!dummyHash) {
      dummyHash = await hashPassword('dummy-password-123', rounds);
    }
    return dummyHash;
  }

  // User aur token ek saath bhejta hai.
  function sendAuth(res, status, user) {
    const token = signToken(user._id, jwtSecret, expiresIn);
    return res.status(status).json({ user: user.toPublic(), token });
  }

  // Naya user banata hai. Password hash hokar hi save hota hai.
  router.post('/signup', async (req, res) => {
    const body = req.body || {};
    const problem = validateSignup(body);
    if (problem) {
      return res.status(400).json({ error: problem });
    }

    const name = body.name.trim();
    const email = body.email.trim().toLowerCase();

    if (await findUserByEmail(email)) {
      return res.status(409).json({ error: DUPLICATE_MSG });
    }

    const passwordHash = await hashPassword(body.password, rounds);
    try {
      const user = await createUser({ name, email, passwordHash });
      return sendAuth(res, 201, user);
    } catch (err) {
      // Do log ek saath signup karein to DB duplicate error deta hai.
      if (err && err.code === 11000) {
        return res.status(409).json({ error: DUPLICATE_MSG });
      }
      throw err;
    }
  });

  // Login: sahi email + password par user aur token deta hai.
  router.post('/login', async (req, res) => {
    const { email: rawEmail, password } = req.body || {};
    if (typeof rawEmail !== 'string' || typeof password !== 'string') {
      return res.status(400).json({ error: 'Email aur password dono chahiye' });
    }
    const email = rawEmail.trim().toLowerCase();
    const user = await findUserByEmail(email);
    const hash = user ? user.passwordHash : await getDummyHash();
    const ok = await verifyPassword(password, hash);
    if (!user || !ok) {
      return res.status(401).json({ error: LOGIN_FAIL_MSG });
    }
    return sendAuth(res, 200, user);
  });

  return router;
}

module.exports = { authRouter };