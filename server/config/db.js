// server/config/db.js
require('dotenv').config();
const mongoose = require('mongoose');

console.log("Mongo url:", process.env.MONGO_URL);

const connection = mongoose.createConnection(process.env.MONGO_URL);

connection.on('open', () => {
  console.log('✅ MongoDB Connected');
});

connection.on('error', (error) => {
  console.error('❌ MongoDB Connection error:', error);
});

module.exports = connection;
