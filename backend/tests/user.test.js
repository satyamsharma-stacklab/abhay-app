const User = require('../src/models/user');

// Sahi data ka helper. Har test apne hisaab se badal sakta hai.
function makeUser(overrides = {}) {
  return new User({
    name: 'Abhay',
    email: 'abhay@example.com',
    passwordHash: 'hash-yahan-aayega',
    ...overrides,
  });
}

// Validation chalata hai. Sab theek ho to null, warna errors ka object.
async function errorsOf(user) {
  try {
    await user.validate();
    return null;
  } catch (err) {
    return err.errors;
  }
}

// Ye tests DB ke bina chalte hain (sirf validate, save nahi).
describe('User model', () => {
  test('sahi data par validation pass hoti hai', async () => {
    expect(await errorsOf(makeUser())).toBeNull();
  });

  test('email chhote akshar aur bina space ke save hota hai', () => {
    const u = makeUser({ email: '  Abhay@Example.COM ' });
    expect(u.email).toBe('abhay@example.com');
  });

  test('galat email par error aata hai', async () => {
    const errs = await errorsOf(makeUser({ email: 'galat-email' }));
    expect(errs.email).toBeDefined();
  });

  test('name, email, passwordHash teeno zaroori hain', async () => {
    const errs = await errorsOf(new User({}));
    expect(errs.name).toBeDefined();
    expect(errs.email).toBeDefined();
    expect(errs.passwordHash).toBeDefined();
  });

  test('50 akshar ka naam theek, 51 par error', async () => {
    const ok = await errorsOf(makeUser({ name: 'a'.repeat(50) }));
    expect(ok).toBeNull();
    const bad = await errorsOf(makeUser({ name: 'a'.repeat(51) }));
    expect(bad.name).toBeDefined();
  });

  test('toPublic mein passwordHash nahi hota', () => {
    const pub = makeUser().toPublic();
    expect(Object.keys(pub).sort()).toEqual([
      'createdAt',
      'email',
      'id',
      'name',
    ]);
    expect(JSON.stringify(pub)).not.toContain('hash-yahan-aayega');
    expect(typeof pub.id).toBe('string');
  });

  test('createdAt apne aap date ban jata hai', () => {
    expect(makeUser().createdAt).toBeInstanceOf(Date);
  });
});