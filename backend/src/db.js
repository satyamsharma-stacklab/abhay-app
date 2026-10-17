const dns = require('dns');
const mongoose = require('mongoose');

// Kuch Windows networks par Node ka SRV lookup refuse ho jata hai
// (querySrv ECONNREFUSED). Public DNS se poochne par ye theek ho jata hai.
dns.setServers(['8.8.8.8', '1.1.1.1']);

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