const mongoose = require('mongoose');

const ProductSchema = new mongoose.Schema(
  {
    artisanId: { type: mongoose.Schema.Types.ObjectId, ref: 'Artisan' },
    title: { type: String, required: true, trim: true },
    craftType: { type: String, required: true },
    state: { type: String, required: true },
    district: { type: String, default: '' },
    giTag: { type: Boolean, default: false },
    description: { type: String, default: '' },
    materials: [{ type: String }],
    colors: [{ type: String }],
    dimensions: { type: String, default: '' },
    images: [{ type: String }],
    coverImage: { type: String, required: true },
    heritageStory: { type: String, default: '' },
    aiConfidence: { type: Number, default: 0.95 },
    authenticityScore: { type: Number, default: 98 },
    suggestedPrice: { type: Number, default: 0 },
    sellingPrice: { type: Number, required: true },
    stock: { type: Number, default: 10 },
    category: { type: String, required: true },
    tags: [{ type: String }],
    festivalTags: [{ type: String }],
    featured: { type: Boolean, default: false },
  },
  { timestamps: true }
);

module.exports = mongoose.model('Product', ProductSchema);
