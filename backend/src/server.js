require('dotenv').config();
const { createApp } = require('./app');
const { connectDb } = require('./db');
const Topic = require('./models/topic');
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
  createApp({ getTopics }).listen(PORT, () => {
    console.log(`ABHAY backend chal raha hai: http://localhost:${PORT}`);
  });
}

main();