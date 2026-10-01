const mongoose = require('mongoose');

const CraftSchema = new mongoose.Schema(
  {
    craftName: { type: String, required: true },
    state: { type: String, required: true },
    district: { type: String, default: '' },
    category: { type: String, required: true },
    giTagged: { type: Boolean, default: false },
    materials: [{ type: String }],
    techniques: [{ type: String }],
    history: { type: String, default: '' },
    priceRange: { type: String, default: '' },
    heroImage: { type: String, default: '' },
    galleryImages: [{ type: String }],
  },
  { timestamps: true }
);

module.exports = mongoose.model('Craft', CraftSchema);
