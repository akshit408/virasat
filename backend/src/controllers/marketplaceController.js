const Product = require('../models/Product');
const Craft = require('../models/Craft');
const Artisan = require('../models/Artisan');

exports.getMarketplaceHome = async (req, res) => {
  try {
    const banners = [
      {
        id: 'b1',
        title: 'Artisan India Heritage',
        subtitle: 'Authentic GI Tagged Crafts Direct from Master Artisans',
        imageUrl: 'assets/images/sample_crafts/bandhani.jpg',
        ctaText: 'Explore GI Crafts',
      },
      {
        id: 'b2',
        title: 'AI Product Scanner',
        subtitle: 'Upload photos & generate professional craft listings in 60s',
        imageUrl: 'assets/images/sample_crafts/patola.jpg',
        ctaText: 'Scan My Craft',
      },
      {
        id: 'b3',
        title: 'Master Craftsmen Direct',
        subtitle: 'Empowering 100,000+ Indian handloom & handicraft artisans',
        imageUrl: 'assets/images/sample_crafts/blue_pottery.jpg',
        ctaText: 'Meet Artisans',
      },
    ];

    const categories = [
      { id: 'cat_textiles', name: 'Textiles & Silk', icon: 'checkroom' },
      { id: 'cat_pottery', name: 'Pottery & Ceramics', icon: 'coffee' },
      { id: 'cat_metal', name: 'Brass & Metalware', icon: 'hardware' },
      { id: 'cat_wood', name: 'Woodcraft & Toys', icon: 'chair' },
      { id: 'cat_painting', name: 'Folk Paintings', icon: 'palette' },
    ];

    const crafts = await Craft.find().limit(12);
    const giCollection = await Craft.find({ giTagged: true }).limit(8);
    const trendingCrafts = await Craft.find().sort({ createdAt: -1 }).limit(10);
    const newlyListed = await Product.find().sort({ createdAt: -1 }).limit(6);
    const featuredArtisans = await Artisan.find().limit(5);

    res.status(200).json({
      success: true,
      banners,
      categories,
      crafts,
      giCollection,
      trendingCrafts,
      newlyListed,
      featuredArtisans,
    });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};
