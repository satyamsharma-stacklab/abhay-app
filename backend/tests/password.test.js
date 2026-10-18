const {
  validatePassword,
  hashPassword,
  verifyPassword,
} = require('../src/auth/password');

// Tests mein kam rounds (4) taaki jaldi chalein.
const FAST = 4;

describe('validatePassword', () => {
  test('8 akshar ka password theek hai', () => {
    expect(validatePassword('abcd1234')).toBeNull();
  });

  test('chhote password par message milta hai', () => {
    expect(validatePassword('abc123')).toMatch(/kam se kam 8/);
  });

  test('text ke alawa kuch bhi galat hai', () => {
    expect(validatePassword(undefined)).not.toBeNull();
    expect(validatePassword(12345678)).not.toBeNull();
  });

  test('72 byte theek, 73 byte bahut lamba', () => {
    expect(validatePassword('a'.repeat(72))).toBeNull();
    expect(validatePassword('a'.repeat(73))).toMatch(/lamba/);
  });
});

describe('hashPassword aur verifyPassword', () => {
  test('hash asli password se alag hota hai', async () => {
    const hash = await hashPassword('abcd1234', FAST);
    expect(hash).not.toBe('abcd1234');
    expect(hash.startsWith('$2')).toBe(true);
  });

  test('same password ke do hash alag aate hain', async () => {
    const h1 = await hashPassword('abcd1234', FAST);
    const h2 = await hashPassword('abcd1234', FAST);
    expect(h1).not.toBe(h2);
  });

  test('sahi password par true', async () => {
    const hash = await hashPassword('abcd1234', FAST);
    expect(await verifyPassword('abcd1234', hash)).toBe(true);
  });

  test('galat password par false', async () => {
    const hash = await hashPassword('abcd1234', FAST);
    expect(await verifyPassword('abcd9999', hash)).toBe(false);
  });

  test('galat type par error nahi, bas false', async () => {
    expect(await verifyPassword(undefined, 'x')).toBe(false);
    expect(await verifyPassword('abcd1234', undefined)).toBe(false);
  });
});