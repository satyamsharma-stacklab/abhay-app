const jwt = require('jsonwebtoken');

// Token kitne din chalega.
const DEFAULT_EXPIRES = '7d';

// Secret kam se kam itne akshar ka ho (.env wala 64 akshar ka hai).
const MIN_SECRET_LENGTH = 32;
const SECRET_MSG = 'JWT_SECRET set nahi hai ya 32 akshar se chhota hai';

// Secret sahi hai ya nahi. Kamzor secret par server chalne hi nahi denge.
function checkSecret(secret) {
  if (typeof secret !== 'string' || secret.length < MIN_SECRET_LENGTH) {
    throw new Error(SECRET_MSG);
  }
}

// Token banata hai. Isme sirf user ka id jata hai, aur kuch nahi.
function signToken(userId, secret, expiresIn = DEFAULT_EXPIRES) {
  checkSecret(secret);
  return jwt.sign({ sub: String(userId) }, secret, {
    algorithm: 'HS256',
    expiresIn,
  });
}

// Token check karta hai. Sahi ho to user ka id deta hai, warna null.
// (Kharab, expire hua, ya doosre secret se bana token: sab par null.)
function verifyToken(token, secret) {
  checkSecret(secret);
  if (typeof token !== 'string' || token.length === 0) {
    return null;
  }
  try {
    const payload = jwt.verify(token, secret, { algorithms: ['HS256'] });
    return typeof payload.sub === 'string' ? payload.sub : null;
  } catch (err) {
    return null;
  }
}

module.exports = { signToken, verifyToken, checkSecret };