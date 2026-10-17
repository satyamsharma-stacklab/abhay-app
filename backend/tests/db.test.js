const { connectDb } = require('../src/db');

describe('connectDb', () => {
  test('URI na ho to saaf error deta hai', async () => {
    await expect(connectDb(undefined)).rejects.toThrow('MONGODB_URI');
  });
});