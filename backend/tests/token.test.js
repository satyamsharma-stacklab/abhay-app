const jwt = require('jsonwebtoken');
const { signToken, verifyToken, checkSecret } = require('../src/auth/token');

// Sirf tests ke liye nakli secrets (asli .env wala nahi).
const SECRET = 'a'.repeat(40);
const OTHER = 'b'.repeat(40);

describe('checkSecret', () => {
  test('lamba secret theek hai', () => {
    expect(() => checkSecret(SECRET)).not.toThrow();
  });

  test('khali, chhota ya text ke alawa secret par error', () => {
    expect(() => checkSecret(undefined)).toThrow();
    expect(() => checkSecret('')).toThrow();
    expect(() => checkSecret('chhota')).toThrow();
    expect(() => checkSecret(12345)).toThrow();
  });
});

describe('signToken aur verifyToken', () => {
  test('banaya hua token wapas wahi user id deta hai', () => {
    const token = signToken('u123', SECRET);
    expect(verifyToken(token, SECRET)).toBe('u123');
  });

  test('token mein sirf id aur samay hota hai', () => {
    const payload = jwt.decode(signToken('u123', SECRET));
    expect(Object.keys(payload).sort()).toEqual(['exp', 'iat', 'sub']);
  });

  test('token 7 din ke liye chalta hai', () => {
    const payload = jwt.decode(signToken('u123', SECRET));
    expect(payload.exp - payload.iat).toBe(7 * 24 * 60 * 60);
  });

  test('doosre secret se check karne par null', () => {
    const token = signToken('u123', SECRET);
    expect(verifyToken(token, OTHER)).toBeNull();
  });

  test('kharab ya khali token par null, error nahi', () => {
    expect(verifyToken('kuch.galat.token', SECRET)).toBeNull();
    expect(verifyToken('', SECRET)).toBeNull();
    expect(verifyToken(undefined, SECRET)).toBeNull();
  });

  test('expire hua token par null', () => {
    const token = signToken('u123', SECRET, '-10s');
    expect(verifyToken(token, SECRET)).toBeNull();
  });

  test('bina signature wala (alg none) token par null', () => {
    const header = Buffer.from('{"alg":"none","typ":"JWT"}').toString('base64url');
    const body = Buffer.from('{"sub":"u123"}').toString('base64url');
    expect(verifyToken(`${header}.${body}.`, SECRET)).toBeNull();
  });

  test('kamzor secret se banane par error', () => {
    expect(() => signToken('u123', 'chhota')).toThrow();
  });
});