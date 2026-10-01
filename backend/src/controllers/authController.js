const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const User = require('../models/User');
const Artisan = require('../models/Artisan');

const generateToken = (id) => {
  return jwt.sign({ id }, process.env.JWT_SECRET || 'virasat_super_secret_jwt_key_2026_production', {
    expiresIn: process.env.JWT_EXPIRE || '30d',
  });
};

exports.register = async (req, res) => {
  try {
    const { name, email, password, role, phone, craftSpecialization, state } = req.body;

    let user = await User.findOne({ email });
    if (user) {
      return res.status(400).json({ success: false, message: 'User already exists with this email' });
    }

    const salt = await bcrypt.genSalt(10);
    const passwordHash = await bcrypt.hash(password, salt);

    user = await User.create({
      name,
      email,
      phone: phone || '',
      passwordHash,
      role: role || 'buyer',
    });

    let artisanProfile = null;
    if (user.role === 'artisan') {
      artisanProfile = await Artisan.create({
        userId: user._id,
        artisanName: user.name,
        craftSpecialization: craftSpecialization || 'Handicrafts',
        state: state || 'Rajasthan',
      });
    }

    const token = generateToken(user._id);

    res.status(201).json({
      success: true,
      token,
      user: {
        id: user._id,
        name: user.name,
        email: user.email,
        role: user.role,
        avatar: user.avatar,
      },
      artisan: artisanProfile,
    });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

exports.login = async (req, res) => {
  try {
    const { email, password } = req.body;

    const user = await User.findOne({ email });
    if (!user) {
      return res.status(401).json({ success: false, message: 'Invalid credentials' });
    }

    const isMatch = await bcrypt.compare(password, user.passwordHash);
    if (!isMatch) {
      return res.status(401).json({ success: false, message: 'Invalid credentials' });
    }

    const token = generateToken(user._id);
    let artisanProfile = null;
    if (user.role === 'artisan') {
      artisanProfile = await Artisan.findOne({ userId: user._id });
    }

    res.status(200).json({
      success: true,
      token,
      user: {
        id: user._id,
        name: user.name,
        email: user.email,
        role: user.role,
        avatar: user.avatar,
      },
      artisan: artisanProfile,
    });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

exports.logout = async (req, res) => {
  res.status(200).json({ success: true, message: 'Logged out successfully' });
};

exports.getMe = async (req, res) => {
  try {
    const user = await User.findById(req.user.id).select('-passwordHash');
    let artisanProfile = null;
    if (user.role === 'artisan') {
      artisanProfile = await Artisan.findOne({ userId: user._id });
    }

    res.status(200).json({
      success: true,
      user,
      artisan: artisanProfile,
    });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};
