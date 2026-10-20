const request = require('supertest');
const { createApp } = require('../src/app');
const { verifyToken } = require('../src/auth/token');

// Tests ke liye nakli secret (asli .env wala nahi).
const SECRET = 'a'.repeat(40);

// Nakli DB: users ek list mein rehte hain, asli MongoDB nahi chahiye.
// Tests mein hashing ke kam rounds (4) taaki jaldi chalein.
function makeApp() {
  const users = [];
  const auth = {
    rounds: 4,
    jwtSecret: SECRET,
    findUserByEmail: async (email) =>
      users.find((u) => u.email === email) || null,
    createUser: async (data) => {
      const user = {
        ...data,
        _id: `id${users.length + 1}`,
        createdAt: new Date(),
        toPublic() {
          return {
            id: this._id,
            name: this.name,
            email: this.email,
            createdAt: this.createdAt,
          };
        },
      };
      users.push(user);
      return user;
    },
  };
  return { app: createApp({ auth }), users };
}

const GOOD = {
  name: 'Abhay',
  email: 'abhay@example.com',
  password: 'abcd1234',
};

const CREDS = { email: GOOD.email, password: GOOD.password };

// Chhote helpers: ek line mein signup / login bhejna.
const signup = (app, body) =>
  request(app).post('/api/auth/signup').send(body);
const login = (app, body) =>
  request(app).post('/api/auth/login').send(body);

describe('POST /api/auth/signup', () => {
  test('sahi data par 201 aur user milta hai', async () => {
    const { app } = makeApp();
    const res = await signup(app, GOOD);
    expect(res.status).toBe(201);
    expect(res.body.user.name).toBe('Abhay');
    expect(res.body.user.email).toBe('abhay@example.com');
  });

  test('response mein password ya passwordHash nahi', async () => {
    const { app } = makeApp();
    const res = await signup(app, GOOD);
    expect(JSON.stringify(res.body)).not.toContain('abcd1234');
    expect(res.body.user.passwordHash).toBeUndefined();
    expect(res.body.user.password).toBeUndefined();
  });

  test('password hash hokar save hota hai', async () => {
    const { app, users } = makeApp();
    await signup(app, GOOD);
    expect(users[0].passwordHash).not.toBe('abcd1234');
    expect(users[0].passwordHash.startsWith('$2')).toBe(true);
  });

  test('email chhote akshar aur bina space ke save hota hai', async () => {
    const { app, users } = makeApp();
    const res = await signup(app, {
      ...GOOD,
      email: '  Abhay@Example.COM ',
    });
    expect(res.status).toBe(201);
    expect(users[0].email).toBe('abhay@example.com');
  });

  test('dobara same email par 409', async () => {
    const { app } = makeApp();
    await signup(app, GOOD);
    const res = await signup(app, { ...GOOD, email: 'ABHAY@example.com' });
    expect(res.status).toBe(409);
    expect(res.body.error).toMatch(/registered/);
  });

  test('galat email par 400', async () => {
    const { app } = makeApp();
    const res = await signup(app, { ...GOOD, email: 'galat-email' });
    expect(res.status).toBe(400);
  });

  test('chhote password par 400', async () => {
    const { app } = makeApp();
    const res = await signup(app, { ...GOOD, password: 'abc123' });
    expect(res.status).toBe(400);
    expect(res.body.error).toMatch(/kam se kam 8/);
  });

  test('naam na ho to 400', async () => {
    const { app } = makeApp();
    const res = await signup(app, {
      email: GOOD.email,
      password: GOOD.password,
    });
    expect(res.status).toBe(400);
  });

  test('khali body par 400', async () => {
    const { app } = makeApp();
    const res = await signup(app, {});
    expect(res.status).toBe(400);
  });

  test('kharab JSON par 400, 500 nahi', async () => {
    const { app } = makeApp();
    const res = await request(app)
      .post('/api/auth/signup')
      .set('Content-Type', 'application/json')
      .send('{ galat json');
    expect(res.status).toBe(400);
    expect(res.body.error).toMatch(/JSON/);
  });
});
describe('POST /api/auth/login', () => {
  // Pehle signup, phir login ke liye wahi app.
  async function signedUp() {
    const made = makeApp();
    await signup(made.app, GOOD);
    return made;
  }

  test('sahi email + password par 200, user aur token', async () => {
    const { app } = await signedUp();
    const res = await login(app, CREDS);
    expect(res.status).toBe(200);
    expect(res.body.user.email).toBe('abhay@example.com');
    expect(typeof res.body.token).toBe('string');
    expect(res.body.token.split('.')).toHaveLength(3);
  });

  test('login ke response mein password ya passwordHash nahi', async () => {
    const { app } = await signedUp();
    const res = await login(app, CREDS);
    expect(JSON.stringify(res.body)).not.toContain('abcd1234');
    expect(res.body.user.passwordHash).toBeUndefined();
  });

  test('email chhote-bade akshar ya space ka farq nahi padta', async () => {
    const { app } = await signedUp();
    const res = await login(app, {
      email: '  ABHAY@Example.com ',
      password: GOOD.password,
    });
    expect(res.status).toBe(200);
  });

  test('token mein user ka id hota hai', async () => {
    const { app } = await signedUp();
    const res = await login(app, CREDS);
    expect(verifyToken(res.body.token, SECRET)).toBe('id1');
  });

  test('galat password par 401', async () => {
    const { app } = await signedUp();
    const res = await login(app, { ...CREDS, password: 'galat-password' });
    expect(res.status).toBe(401);
    expect(res.body.token).toBeUndefined();
  });

  test('email registered na ho to bhi 401, wahi message', async () => {
    const { app } = await signedUp();
    const wrongPass = await login(app, {
      ...CREDS,
      password: 'galat-password',
    });
    const noUser = await login(app, {
      email: 'koi@example.com',
      password: 'abcd1234',
    });
    expect(noUser.status).toBe(401);
    expect(noUser.body.error).toBe(wrongPass.body.error);
  });

  test('email ya password na ho to 400', async () => {
    const { app } = await signedUp();
    const noPass = await login(app, { email: GOOD.email });
    const noEmail = await login(app, { password: 'abcd1234' });
    const empty = await login(app, {});
    expect(noPass.status).toBe(400);
    expect(noEmail.status).toBe(400);
    expect(empty.status).toBe(400);
  });

  test('signup se bhi token milta hai', async () => {
    const { app } = makeApp();
    const res = await signup(app, GOOD);
    expect(res.status).toBe(201);
    expect(verifyToken(res.body.token, SECRET)).toBe('id1');
  });
});