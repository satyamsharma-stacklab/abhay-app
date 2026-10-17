require('dotenv').config();
const { createApp } = require('./app');
const { connectDb } = require('./db');

const PORT = process.env.PORT || 3000;

async function main() {
  try {
    await connectDb(process.env.MONGODB_URI);
    console.log('MongoDB se connect ho gaya');
  } catch (err) {
    // Password kabhi print nahi karte, sirf error ka message.
    console.error('MongoDB connect nahi hua:', err.message);
    process.exit(1);
  }
  createApp().listen(PORT, () => {
    console.log(`ABHAY backend chal raha hai: http://localhost:${PORT}`);
  });
}

main();