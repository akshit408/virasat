const mongoose = require('mongoose');

const ArtisanSchema = new mongoose.Schema(
  {
    userId: { type: mongoose.Schema.Types.ObjectId, ref: 'User' },
    artisanName: { type: String, required: true },
    craftSpecialization: { type: String, required: true },
    bio: { type: String, default: '' },
    state: { type: String, required: true },
    district: { type: String, default: '' },
    village: { type: String, default: '' },
    yearsExperience: { type: Number, default: 5 },
    giCertified: { type: Boolean, default: false },
    verificationStatus: { type: String, enum: ['pending', 'verified', 'rejected'], default: 'verified' },
    profileCompletion: { type: Number, default: 100 },
    followers: { type: Number, default: 0 },
    earnings: { type: Number, default: 0 },
    rating: { type: Number, default: 4.8 },
    story: { type: String, default: '' },
    bannerImage: { type: String, default: '' },
    avatarImage: { type: String, default: '' },
  },
  { timestamps: true }
);

module.exports = mongoose.model('Artisan', ArtisanSchema);
