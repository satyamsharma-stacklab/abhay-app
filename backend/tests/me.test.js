const request = require('supertest');
const { createApp } = require('../src/app');
const { signToken } = require('../src/auth/token');

// Tests ke liye nakli secrets (asli .env wala nahi).
const SECRET = 'a'.repeat(40);
const OTHER = 'b'.repeat(40);

// Nakli DB: ek user pehle se maujood hai (id "u1").
// Hash mein dikhne wali cheez "SECRET-HASH" hai, jo kabhi bahar nahi aani chahiye.
function makeApp() {
  const users = [
    {
      _id: 'u1',
      name: 'Abhay',
      email: 'abhay@example.com',
      passwordHash: 'SECRET-HASH',
      createdAt: new Date(),
      toPublic() {
        return {
          id: this._id,
          name: this.name,
          email: this.email,
          createdAt: this.createdAt,
        };
      },
    },
  ];
  const auth = {
    jwtSecret: SECRET,
    findUserByEmail: async () => null,
    createUser: async () => null,
    findUserById: async (id) => users.find((u) => u._id === id) || null,
  };
  return { app: createApp({ auth }), users };
}

// Sahi token (user "u1" ka).
const goodToken = () => signToken('u1', SECRET);
const getMe = (app) => request(app).get('/api/me');

describe('GET /api/me', () => {
  test('bina token ke 401', async () => {
    const { app } = makeApp();
    const res = await getMe(app);
    expect(res.status).toBe(401);
    expect(res.body.error).toMatch(/login/);
  });

  test('kharab token par 401', async () => {
    const { app } = makeApp();
    const res = await getMe(app).set('Authorization', 'Bearer kuch.galat.token');
    expect(res.status).toBe(401);
  });

  test('Bearer ke bina (galat scheme) par 401', async () => {
    const { app } = makeApp();
    const res = await getMe(app).set('Authorization', goodToken());
    expect(res.status).toBe(401);
  });

  test('expire hua token par 401', async () => {
    const { app } = makeApp();
    const expired = signToken('u1', SECRET, '-10s');
    const res = await getMe(app).set('Authorization', `Bearer ${expired}`);
    expect(res.status).toBe(401);
  });

  test('sahi token par user milta hai', async () => {
    const { app } = makeApp();
    const res = await getMe(app).set('Authorization', `Bearer ${goodToken()}`);
    expect(res.status).toBe(200);
    expect(res.body.user.email).toBe('abhay@example.com');
    expect(res.body.user.id).toBe('u1');
  });

  test('response mein passwordHash nahi', async () => {
    const { app } = makeApp();
    const res = await getMe(app).set('Authorization', `Bearer ${goodToken()}`);
    expect(JSON.stringify(res.body)).not.toContain('SECRET-HASH');
    expect(res.body.user.passwordHash).toBeUndefined();
  });

  test('user delete ho gaya ho to token ke bawajood 401', async () => {
    const { app, users } = makeApp();
    users.length = 0;
    const res = await getMe(app).set('Authorization', `Bearer ${goodToken()}`);
    expect(res.status).toBe(401);
  });

  test('doosre secret se bana token par 401', async () => {
    const { app } = makeApp();
    const fake = signToken('u1', OTHER);
    const res = await getMe(app).set('Authorization', `Bearer ${fake}`);
    expect(res.status).toBe(401);
  });
});