// server/routes/user.routes.js
const express = require('express');
const jwt = require('jsonwebtoken');
const UserModel = require('../models/user.model');

const router = express.Router();

// POST /register - Register a new user
router.post('/register', async (req, res) => {
  console.log('📥 POST /register - Registration request received');
  try {
    const { email, password } = req.body;
    console.log(`🔹 Registering user with email: ${email}`);

    const user = new UserModel({ email, password });
    await user.save();

    console.log('✅ User registered successfully:', user._id);
    res.status(201).json({ message: 'User registered' });
  } catch (error) {
    console.error('❌ Error in POST /register:', error.message);
    res.status(400).json({ error: error.message });
  }
});

// POST /login - Authenticate user
router.post('/login', async (req, res) => {
  console.log('📥 POST /login - Login request received');
  try {
    const { email, password } = req.body;
    console.log(`🔍 Attempting login for email: ${email}`);

    const user = await UserModel.findOne({ email });
    if (!user) {
      console.warn('⚠️ User not found');
      return res.status(401).json({ error: 'Invalid credentials' });
    }

    const isMatch = await user.comparePassword(password);
    if (!isMatch) {
      console.warn('⚠️ Password mismatch');
      return res.status(401).json({ error: 'Invalid credentials' });
    }

    const token = jwt.sign({ userId: user._id }, 'secret_key', { expiresIn: '1h' });
    console.log('✅ Login successful. Token generated for user:', user._id);

    res.json({ token, userId: user._id });
  } catch (error) {
    console.error('❌ Error in POST /login:', error.message);
    res.status(400).json({ error: error.message });
  }
});

module.exports = router;
