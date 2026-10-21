const request = require('supertest');
const { createApp } = require('../src/app');

describe('CORS', () => {
  test('normal request: Access-Control-Allow-Origin header aata hai', async () => {
    const res = await request(createApp())
      .get('/health')
      .set('Origin', 'http://localhost:5555');

    expect(res.status).toBe(200);
    expect(res.headers['access-control-allow-origin']).toBe('*');
  });

  test('preflight (OPTIONS): 204 aata hai aur allowed methods/headers batata hai', async () => {
    const res = await request(createApp())
      .options('/api/auth/login')
      .set('Origin', 'http://localhost:5555')
      .set('Access-Control-Request-Method', 'POST')
      .set('Access-Control-Request-Headers', 'content-type,authorization');

    expect(res.status).toBe(204);
    expect(res.headers['access-control-allow-origin']).toBe('*');
    expect(res.headers['access-control-allow-methods']).toMatch(/POST/);
    expect(res.headers['access-control-allow-headers']).toMatch(/authorization/i);
  });

  test('404 jawab par bhi CORS header aata hai', async () => {
    const res = await request(createApp())
      .get('/koi-route-nahi')
      .set('Origin', 'http://localhost:5555');

    expect(res.status).toBe(404);
    expect(res.headers['access-control-allow-origin']).toBe('*');
  });
});