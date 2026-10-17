const request = require('supertest');
const { createApp } = require('../src/app');

describe('GET /health', () => {
  test('status ok deta hai', async () => {
    const res = await request(createApp()).get('/health');
    expect(res.status).toBe(200);
    expect(res.body).toEqual({ status: 'ok', service: 'abhay-backend' });
  });
});

describe('unknown route', () => {
  test('404 aur saaf error deta hai', async () => {
    const res = await request(createApp()).get('/koi-route-nahi');
    expect(res.status).toBe(404);
    expect(res.body.error).toBeDefined();
  });
});