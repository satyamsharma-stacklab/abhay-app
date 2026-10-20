const request = require('supertest');
const { createApp } = require('../src/app');

// Nakli DB: users ek list mein rehte hain, asli MongoDB nahi chahiye.
// Tests mein hashing ke kam rounds (4) taaki jaldi chalein.
function makeApp() {
  const users = [];
  const auth = {
    rounds: 4,
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

describe('POST /api/auth/signup', () => {
  test('sahi data par 201 aur user milta hai', async () => {
    const { app } = makeApp();
    const res = await request(app).post('/api/auth/signup').send(GOOD);
    expect(res.status).toBe(201);
    expect(res.body.user.name).toBe('Abhay');
    expect(res.body.user.email).toBe('abhay@example.com');
  });

  test('response mein password ya passwordHash nahi', async () => {
    const { app } = makeApp();
    const res = await request(app).post('/api/auth/signup').send(GOOD);
    const text = JSON.stringify(res.body);
    expect(text).not.toContain('abcd1234');
    expect(res.body.user.passwordHash).toBeUndefined();
    expect(res.body.user.password).toBeUndefined();
  });

  test('password hash hokar save hota hai', async () => {
    const { app, users } = makeApp();
    await request(app).post('/api/auth/signup').send(GOOD);
    expect(users[0].passwordHash).not.toBe('abcd1234');
    expect(users[0].passwordHash.startsWith('$2')).toBe(true);
  });

  test('email chhote akshar aur bina space ke save hota hai', async () => {
    const { app, users } = makeApp();
    const res = await request(app)
      .post('/api/auth/signup')
      .send({ ...GOOD, email: '  Abhay@Example.COM ' });
    expect(res.status).toBe(201);
    expect(users[0].email).toBe('abhay@example.com');
  });

  test('dobara same email par 409', async () => {
    const { app } = makeApp();
    await request(app).post('/api/auth/signup').send(GOOD);
    const res = await request(app)
      .post('/api/auth/signup')
      .send({ ...GOOD, email: 'ABHAY@example.com' });
    expect(res.status).toBe(409);
    expect(res.body.error).toMatch(/registered/);
  });

  test('galat email par 400', async () => {
    const { app } = makeApp();
    const res = await request(app)
      .post('/api/auth/signup')
      .send({ ...GOOD, email: 'galat-email' });
    expect(res.status).toBe(400);
  });

  test('chhote password par 400', async () => {
    const { app } = makeApp();
    const res = await request(app)
      .post('/api/auth/signup')
      .send({ ...GOOD, password: 'abc123' });
    expect(res.status).toBe(400);
    expect(res.body.error).toMatch(/kam se kam 8/);
  });

  test('naam na ho to 400', async () => {
    const { app } = makeApp();
    const res = await request(app)
      .post('/api/auth/signup')
      .send({ email: GOOD.email, password: GOOD.password });
    expect(res.status).toBe(400);
  });

  test('khali body par 400', async () => {
    const { app } = makeApp();
    const res = await request(app).post('/api/auth/signup').send({});
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