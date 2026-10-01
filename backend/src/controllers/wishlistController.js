const Wishlist = require('../models/Wishlist');
const Product = require('../models/Product');

exports.getWishlist = async (req, res) => {
  try {
    let wishlist = await Wishlist.findOne({ buyerId: req.user.id }).populate('productIds');
    if (!wishlist) {
      wishlist = await Wishlist.create({ buyerId: req.user.id, productIds: [] });
    }
    res.status(200).json({ success: true, count: wishlist.productIds.length, wishlist: wishlist.productIds });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

exports.addToWishlist = async (req, res) => {
  try {
    const { productId } = req.params;
    let wishlist = await Wishlist.findOne({ buyerId: req.user.id });
    if (!wishlist) {
      wishlist = await Wishlist.create({ buyerId: req.user.id, productIds: [productId] });
    } else {
      if (!wishlist.productIds.includes(productId)) {
        wishlist.productIds.push(productId);
        await wishlist.save();
      }
    }
    res.status(200).json({ success: true, message: 'Added to wishlist', wishlist });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

exports.removeFromWishlist = async (req, res) => {
  try {
    const { productId } = req.params;
    let wishlist = await Wishlist.findOne({ buyerId: req.user.id });
    if (wishlist) {
      wishlist.productIds = wishlist.productIds.filter((id) => id.toString() !== productId);
      await wishlist.save();
    }
    res.status(200).json({ success: true, message: 'Removed from wishlist', wishlist });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};
