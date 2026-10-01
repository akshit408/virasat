const mongoose = require('mongoose');

const FestivalSchema = new mongoose.Schema(
  {
    name: { type: String, required: true, unique: true },
    month: { type: String, required: true },
    states: [{ type: String }],
    heroImage: { type: String, default: '' },
    relatedCrafts: [{ type: String }],
    description: { type: String, default: '' },
  },
  { timestamps: true }
);

module.exports = mongoose.model('Festival', FestivalSchema);
