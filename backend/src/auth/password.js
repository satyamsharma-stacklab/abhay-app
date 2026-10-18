const bcrypt = require('bcryptjs');

// Password ke niyam. bcrypt sirf pehle 72 byte padhta hai,
// isliye usse lamba password hum accept hi nahi karte.
const MIN_LENGTH = 8;
const MAX_BYTES = 72;

// Hashing kitni baar ghumaye (cost). 10 normal hai.
const DEFAULT_ROUNDS = 10;

// Password sahi hai to null deta hai, galat hai to Hinglish message.
function validatePassword(password) {
  if (typeof password !== 'string') {
    return 'Password text hona chahiye';
  }
  if (password.length < MIN_LENGTH) {
    return `Password kam se kam ${MIN_LENGTH} akshar ka hona chahiye`;
  }
  if (Buffer.byteLength(password, 'utf8') > MAX_BYTES) {
    return 'Password bahut lamba hai (maximum 72 byte)';
  }
  return null;
}

// Password ko hash mein badalta hai. Asli password kabhi save nahi hota.
async function hashPassword(password, rounds = DEFAULT_ROUNDS) {
  return bcrypt.hash(password, rounds);
}

// Login ke time: diya gaya password us hash se match karta hai ya nahi.
// Galat type (jaise undefined) par error nahi, bas false.
async function verifyPassword(password, hash) {
  if (typeof password !== 'string' || typeof hash !== 'string') {
    return false;
  }
  return bcrypt.compare(password, hash);
}

module.exports = { validatePassword, hashPassword, verifyPassword };