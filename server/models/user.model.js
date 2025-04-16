// server/models/user.model.js
const mongoose = require('mongoose');
const bcrypt = require('bcrypt');
const db = require('../config/db');

const { Schema } = mongoose;

const userSchema = new Schema({
  email: {
    type: String,
    lowercase: true,
    required: [true, "userName can't be empty"],
    match: [/([\w-\.]+@([\w-]+\.)+[\w-]{2,4})?$/, "userName format is not correct"],
    unique: true,
  },
  password: {
    type: String,
    required: [true, "password is required"],
  },
});

userSchema.pre('save', async function () {
  try {
    const salt = await bcrypt.genSalt(10);
    const hashPass = await bcrypt.hash(this.password, salt);
    this.password = hashPass;
  } catch (err) {
    throw err;
  }
});

userSchema.methods.comparePassword = async function (candidatePassword) {
  try {
    const isMatch = await bcrypt.compare(candidatePassword, this.password);
    return isMatch;
  } catch (error) {
    throw error;
  }
};

const UserModel = db.model('user', userSchema);
module.exports = UserModel;