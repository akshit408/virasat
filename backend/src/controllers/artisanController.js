const Artisan = require('../models/Artisan');
const Product = require('../models/Product');

exports.getArtisans = async (req, res) => {
  try {
    const artisans = await Artisan.find().populate('userId', 'name email avatar');
    res.status(200).json({ success: true, count: artisans.length, artisans });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

exports.getArtisanById = async (req, res) => {
  try {
    const artisan = await Artisan.findById(req.params.id).populate('userId', 'name email avatar');
    if (!artisan) {
      return res.status(404).json({ success: false, message: 'Artisan profile not found' });
    }
    res.status(200).json({ success: true, artisan });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

exports.getMyArtisanProfile = async (req, res) => {
  try {
    const artisan = await Artisan.findOne({ userId: req.user.id });
    if (!artisan) {
      return res.status(404).json({ success: false, message: 'Artisan profile not found' });
    }
    res.status(200).json({ success: true, artisan });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

exports.updateMyArtisanProfile = async (req, res) => {
  try {
    let artisan = await Artisan.findOne({ userId: req.user.id });
    if (!artisan) {
      artisan = await Artisan.create({ userId: req.user.id, ...req.body });
    } else {
      artisan = await Artisan.findByIdAndUpdate(artisan._id, req.body, { new: true, runValidators: true });
    }
    res.status(200).json({ success: true, artisan });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

exports.getArtisanProducts = async (req, res) => {
  try {
    const products = await Product.find({ artisanId: req.params.id });
    res.status(200).json({ success: true, count: products.length, products });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

exports.getArtisanStats = async (req, res) => {
  try {
    const artisan = await Artisan.findById(req.params.id);
    if (!artisan) {
      return res.status(404).json({ success: false, message: 'Artisan profile not found' });
    }
    const productsCount = await Product.countDocuments({ artisanId: req.params.id });

    res.status(200).json({
      success: true,
      stats: {
        totalProducts: productsCount,
        followers: artisan.followers || 0,
        totalEarnings: artisan.earnings || 0,
        rating: artisan.rating || 4.8,
        profileCompletion: artisan.profileCompletion || 100,
        giCertified: artisan.giCertified,
      },
    });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};
