const express = require('express');
const { validatePassword, hashPassword } = require('../auth/password');

// Simple email check (models/user.js jaisa hi).
const EMAIL_PATTERN = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
const MAX_NAME = 50;
const DUPLICATE_MSG = 'Ye email pehle se registered hai';

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
function authRouter({ findUserByEmail, createUser, rounds }) {
  const router = express.Router();

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
      return res.status(201).json({ user: user.toPublic() });
    } catch (err) {
      // Do log ek saath signup karein to DB duplicate error deta hai.
      if (err && err.code === 11000) {
        return res.status(409).json({ error: DUPLICATE_MSG });
      }
      throw err;
    }
  });

  return router;
}

module.exports = { authRouter };