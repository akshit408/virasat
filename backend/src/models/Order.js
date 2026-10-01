const mongoose = require('mongoose');

const OrderSchema = new mongoose.Schema(
  {
    buyerId: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
    artisanId: { type: mongoose.Schema.Types.ObjectId, ref: 'Artisan' },
    products: [
      {
        productId: { type: mongoose.Schema.Types.ObjectId, ref: 'Product' },
        title: String,
        price: Number,
        quantity: { type: Number, default: 1 },
        coverImage: String,
      },
    ],
    quantity: { type: Number, default: 1 },
    shippingAddress: {
      street: String,
      city: String,
      state: String,
      pincode: String,
    },
    paymentStatus: { type: String, enum: ['pending', 'paid', 'failed'], default: 'paid' },
    orderStatus: { type: String, enum: ['placed', 'processing', 'shipped', 'delivered', 'cancelled'], default: 'placed' },
    totalAmount: { type: Number, required: true },
    trackingId: { type: String, default: '' },
  },
  { timestamps: true }
);

module.exports = mongoose.model('Order', OrderSchema);
