const mongoose = require('mongoose');

// MongoDB se jodta hai. URI .env se aati hai, kabhi code mein nahi.
async function connectDb(uri) {
  if (!uri) {
    throw new Error('MONGODB_URI .env mein set nahi hai');
  }
  await mongoose.connect(uri, { serverSelectionTimeoutMS: 8000 });
  return mongoose.connection;
}

async function disconnectDb() {
  await mongoose.disconnect();
}

module.exports = { connectDb, disconnectDb };