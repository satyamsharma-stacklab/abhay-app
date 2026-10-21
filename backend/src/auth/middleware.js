const { verifyToken } = require('./token');

const NEED_LOGIN_MSG = 'Pehle login karo';

// Header "Authorization: Bearer <token>" se token nikalta hai.
// Sahi format na ho to null.
function readBearerToken(req) {
  const header = req.get('authorization');
  if (typeof header !== 'string') {
    return null;
  }
  const match = header.match(/^Bearer\s+(\S+)$/i);
  return match ? match[1] : null;
}

// Middleware: sirf login kiye hue user ko aage jaane deta hai.
// Token sahi ho aur user DB mein ho to req.user mein rakhta hai.
// Warna 401. findUserById bahar se aata hai (tests mein nakli).
function requireAuth({ jwtSecret, findUserById }) {
  return async function requireAuthMiddleware(req, res, next) {
    const token = readBearerToken(req);
    const userId = token ? verifyToken(token, jwtSecret) : null;
    const user = userId ? await findUserById(userId) : null;
    if (!user) {
      return res.status(401).json({ error: NEED_LOGIN_MSG });
    }
    req.user = user;
    return next();
  };
}

module.exports = { requireAuth, readBearerToken };