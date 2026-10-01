const mongoose = require('mongoose');

const UserSchema = new mongoose.Schema(
  {
    name: { type: String, required: true, trim: true },
    email: { type: String, required: true, unique: true, lowercase: true, trim: true },
    phone: { type: String, default: '' },
    passwordHash: { type: String, required: true },
    role: { type: String, enum: ['buyer', 'artisan', 'admin'], default: 'buyer' },
    avatar: { type: String, default: '' },
    language: { type: String, default: 'en' },
    wishlist: [{ type: mongoose.Schema.Types.ObjectId, ref: 'Product' }],
    addresses: [
      {
        street: String,
        city: String,
        state: String,
        pincode: String,
        isDefault: Boolean,
      },
    ],
  },
  { timestamps: true }
);

module.exports = mongoose.model('User', UserSchema);
