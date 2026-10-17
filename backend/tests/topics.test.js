const request = require('supertest');
const { createApp } = require('../src/app');
const { topics: seedTopics } = require('../src/topics.seed');

describe('GET /api/topics', () => {
  test('topics order ke hisaab se sorted aate hain', async () => {
    const jumbled = [
      { id: 'c', title: 'C', order: 3, playable: false },
      { id: 'a', title: 'A', order: 1, playable: true },
      { id: 'b', title: 'B', order: 2, playable: false },
    ];
    const app = createApp({ getTopics: async () => jumbled });
    const res = await request(app).get('/api/topics');
    expect(res.status).toBe(200);
    expect(res.body.topics.map((t) => t.id)).toEqual(['a', 'b', 'c']);
  });

  test('sirf id, title, order, playable bheje jaate hain', async () => {
    const withExtra = [
      { id: 'a', title: 'A', order: 1, playable: true, _id: 'x1', secret: 'no' },
    ];
    const app = createApp({ getTopics: async () => withExtra });
    const res = await request(app).get('/api/topics');
    expect(res.body.topics[0]).toEqual({
      id: 'a',
      title: 'A',
      order: 1,
      playable: true,
    });
  });

  test('playable na ho to false milta hai', async () => {
    const noPlayable = [{ id: 'a', title: 'A', order: 1 }];
    const app = createApp({ getTopics: async () => noPlayable });
    const res = await request(app).get('/api/topics');
    expect(res.body.topics[0].playable).toBe(false);
  });

  test('seed ke 18 topics sahi order mein aate hain', async () => {
    const app = createApp({ getTopics: async () => seedTopics });
    const res = await request(app).get('/api/topics');
    expect(res.body.topics).toHaveLength(18);
    expect(res.body.topics[0].id).toBe('complexity');
    expect(res.body.topics[17].id).toBe('dp');
    expect(res.body.topics.filter((t) => t.playable)).toHaveLength(5);
  });
});