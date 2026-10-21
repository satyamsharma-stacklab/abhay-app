require('dotenv').config();
const { createApp } = require('./app');
const { connectDb } = require('./db');
const { checkSecret } = require('./auth/token');
const Topic = require('./models/topic');
const User = require('./models/user');
const { topics: seedTopics } = require('./topics.seed');

const PORT = process.env.PORT || 3000;

// Seed ke 18 topics DB mein daalta hai (upsert: dobara chalane par duplicate nahi).
async function seedTopicsInDb() {
  const ops = seedTopics.map((t) => ({
    updateOne: { filter: { id: t.id }, update: { $set: t }, upsert: true },
  }));
  await Topic.bulkWrite(ops);
}

async function main() {
  // JWT_SECRET sahi na ho to DB se judne se pehle hi ruk jao.
  try {
    checkSecret(process.env.JWT_SECRET);
  } catch (err) {
    console.error(err.message);
    process.exit(1);
  }
  try {
    await connectDb(process.env.MONGODB_URI);
    console.log('MongoDB se connect ho gaya');
    await seedTopicsInDb();
  } catch (err) {
    // Password kabhi print nahi karte, sirf error ka message.
    console.error('MongoDB connect nahi hua:', err.message);
    process.exit(1);
  }
  const getTopics = () => Topic.find().lean();
  // Auth ke DB kaam (asli User model). Tests mein inki jagah nakli aate hain.
  const auth = {
    jwtSecret: process.env.JWT_SECRET,
    findUserByEmail: (email) => User.findOne({ email }),
    createUser: (data) => User.create(data),
    // Token se mila id kharab ho (galat format) to null, crash nahi.
    findUserById: async (id) => {
      try {
        return await User.findById(id);
      } catch (err) {
        return null;
      }
    },
  };
  createApp({ getTopics, auth }).listen(PORT, () => {
    console.log(`ABHAY backend chal raha hai: http://localhost:${PORT}`);
  });
}

main();