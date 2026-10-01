const fs = require('fs');
const path = require('path');
const mongoose = require('mongoose');
const dotenv = require('dotenv');

dotenv.config({ path: path.join(__dirname, '../../.env') });

const User = require('../models/User');
const Artisan = require('../models/Artisan');
const Product = require('../models/Product');
const Craft = require('../models/Craft');
const Festival = require('../models/Festival');

// 110 Unique Craft Images (No duplicates)
const craftImagesPack = [
  // Gujarat (15)
  'assets/images/crafts/bandhani_01.jpg',
  'assets/images/crafts/bandhani_02.jpg',
  'assets/images/crafts/bandhani_03.jpg',
  'assets/images/crafts/bandhani_04.jpg',
  'assets/images/crafts/bandhani_05.jpg',
  'assets/images/crafts/patola_01.jpg',
  'assets/images/crafts/patola_02.jpg',
  'assets/images/crafts/patola_03.jpg',
  'assets/images/crafts/patola_04.jpg',
  'assets/images/crafts/ajrakh_01.jpg',
  'assets/images/crafts/ajrakh_02.jpg',
  'assets/images/crafts/ajrakh_03.jpg',
  'assets/images/crafts/rogan_art_01.jpg',
  'assets/images/crafts/rogan_art_02.jpg',
  'assets/images/crafts/rogan_art_03.jpg',
  // Rajasthan (15)
  'assets/images/crafts/blue_pottery_01.jpg',
  'assets/images/crafts/blue_pottery_02.jpg',
  'assets/images/crafts/blue_pottery_03.jpg',
  'assets/images/crafts/blue_pottery_04.jpg',
  'assets/images/crafts/blue_pottery_05.jpg',
  'assets/images/crafts/meenakari_01.jpg',
  'assets/images/crafts/meenakari_02.jpg',
  'assets/images/crafts/meenakari_03.jpg',
  'assets/images/crafts/bagru_print_01.jpg',
  'assets/images/crafts/bagru_print_02.jpg',
  'assets/images/crafts/bagru_print_03.jpg',
  'assets/images/crafts/sanganeri_print_01.jpg',
  'assets/images/crafts/sanganeri_print_02.jpg',
  'assets/images/crafts/sanganeri_print_03.jpg',
  'assets/images/crafts/sanganeri_print_04.jpg',
  // Madhya Pradesh (10)
  'assets/images/crafts/chanderi_01.jpg',
  'assets/images/crafts/chanderi_02.jpg',
  'assets/images/crafts/chanderi_03.jpg',
  'assets/images/crafts/chanderi_04.jpg',
  'assets/images/crafts/chanderi_05.jpg',
  'assets/images/crafts/gond_painting_01.jpg',
  'assets/images/crafts/gond_painting_02.jpg',
  'assets/images/crafts/gond_painting_03.jpg',
  'assets/images/crafts/gond_painting_04.jpg',
  'assets/images/crafts/gond_painting_05.jpg',
  // Uttar Pradesh (10)
  'assets/images/crafts/chikankari_01.jpg',
  'assets/images/crafts/chikankari_02.jpg',
  'assets/images/crafts/chikankari_03.jpg',
  'assets/images/crafts/chikankari_04.jpg',
  'assets/images/crafts/chikankari_05.jpg',
  'assets/images/crafts/banarasi_silk_01.jpg',
  'assets/images/crafts/banarasi_silk_02.jpg',
  'assets/images/crafts/banarasi_silk_03.jpg',
  'assets/images/crafts/banarasi_silk_04.jpg',
  'assets/images/crafts/banarasi_silk_05.jpg',
  // West Bengal (10)
  'assets/images/crafts/kantha_01.jpg',
  'assets/images/crafts/kantha_02.jpg',
  'assets/images/crafts/kantha_03.jpg',
  'assets/images/crafts/kantha_04.jpg',
  'assets/images/crafts/kantha_05.jpg',
  'assets/images/crafts/bankura_terracotta_01.jpg',
  'assets/images/crafts/bankura_terracotta_02.jpg',
  'assets/images/crafts/bankura_terracotta_03.jpg',
  'assets/images/crafts/bankura_terracotta_04.jpg',
  'assets/images/crafts/bankura_terracotta_05.jpg',
  // Kashmir (10)
  'assets/images/crafts/pashmina_01.jpg',
  'assets/images/crafts/pashmina_02.jpg',
  'assets/images/crafts/pashmina_03.jpg',
  'assets/images/crafts/pashmina_04.jpg',
  'assets/images/crafts/pashmina_05.jpg',
  'assets/images/crafts/papier_mache_01.jpg',
  'assets/images/crafts/papier_mache_02.jpg',
  'assets/images/crafts/papier_mache_03.jpg',
  'assets/images/crafts/papier_mache_04.jpg',
  'assets/images/crafts/papier_mache_05.jpg',
  // Odisha (10)
  'assets/images/crafts/pattachitra_01.jpg',
  'assets/images/crafts/pattachitra_02.jpg',
  'assets/images/crafts/pattachitra_03.jpg',
  'assets/images/crafts/pattachitra_04.jpg',
  'assets/images/crafts/pattachitra_05.jpg',
  'assets/images/crafts/silver_filigree_01.jpg',
  'assets/images/crafts/silver_filigree_02.jpg',
  'assets/images/crafts/silver_filigree_03.jpg',
  'assets/images/crafts/silver_filigree_04.jpg',
  'assets/images/crafts/silver_filigree_05.jpg',
  // Karnataka (10)
  'assets/images/crafts/channapatna_toys_01.jpg',
  'assets/images/crafts/channapatna_toys_02.jpg',
  'assets/images/crafts/channapatna_toys_03.jpg',
  'assets/images/crafts/channapatna_toys_04.jpg',
  'assets/images/crafts/channapatna_toys_05.jpg',
  'assets/images/crafts/mysore_silk_01.jpg',
  'assets/images/crafts/mysore_silk_02.jpg',
  'assets/images/crafts/mysore_silk_03.jpg',
  'assets/images/crafts/mysore_silk_04.jpg',
  'assets/images/crafts/mysore_silk_05.jpg',
  // Tamil Nadu (10)
  'assets/images/crafts/kanchipuram_silk_01.jpg',
  'assets/images/crafts/kanchipuram_silk_02.jpg',
  'assets/images/crafts/kanchipuram_silk_03.jpg',
  'assets/images/crafts/kanchipuram_silk_04.jpg',
  'assets/images/crafts/kanchipuram_silk_05.jpg',
  'assets/images/crafts/tanjore_painting_01.jpg',
  'assets/images/crafts/tanjore_painting_02.jpg',
  'assets/images/crafts/tanjore_painting_03.jpg',
  'assets/images/crafts/tanjore_painting_04.jpg',
  'assets/images/crafts/tanjore_painting_05.jpg',
  // North-East (10)
  'assets/images/crafts/bamboo_basket_01.jpg',
  'assets/images/crafts/bamboo_basket_02.jpg',
  'assets/images/crafts/bamboo_basket_03.jpg',
  'assets/images/crafts/bamboo_basket_04.jpg',
  'assets/images/crafts/cane_craft_01.jpg',
  'assets/images/crafts/cane_craft_02.jpg',
  'assets/images/crafts/cane_craft_03.jpg',
  'assets/images/crafts/assam_silk_01.jpg',
  'assets/images/crafts/assam_silk_02.jpg',
  'assets/images/crafts/assam_silk_03.jpg',
];

const seedData = async () => {
  try {
    const mongoUri = process.env.MONGO_URI || 'mongodb://127.0.0.1:27017/virasat_db';
    console.log(`Connecting to MongoDB at ${mongoUri}...`);
    await mongoose.connect(mongoUri);

    console.log('Clearing existing collections...');
    await User.deleteMany({});
    await Artisan.deleteMany({});
    await Product.deleteMany({});
    await Craft.deleteMany({});
    await Festival.deleteMany({});

    // 1. Load Crafts from JSON or fallback
    const craftsPath = path.join(__dirname, '../../../assets/data/crafts.json');
    let craftsList = [];
    if (fs.existsSync(craftsPath)) {
      const rawCrafts = JSON.parse(fs.readFileSync(craftsPath, 'utf8'));
      craftsList = rawCrafts.map((c, i) => ({
        craftName: c.name || c.craftName || `Craft ${i + 1}`,
        state: c.stateId || c.state || 'Gujarat',
        district: c.city || c.district || 'Kutch',
        category: c.category || 'Handloom',
        giTagged: c.giTagged !== undefined ? c.giTagged : i % 2 === 0,
        materials: c.materials || ['Silk', 'Organic Dye'],
        techniques: c.techniques || ['Hand Tie-Dye', 'Handloom'],
        history: c.history || 'Centuries old tradition preserved by master artisans.',
        priceRange: c.priceRange || '₹2,500 - ₹12,000',
        heroImage: craftImagesPack[i % craftImagesPack.length],
        galleryImages: [craftImagesPack[i % craftImagesPack.length], craftImagesPack[(i + 1) % craftImagesPack.length]],
      }));
    }

    // Ensure we have at least 50 crafts
    while (craftsList.length < 50) {
      const idx = craftsList.length;
      craftsList.push({
        craftName: `Traditional Heritage Craft #${idx + 1}`,
        state: idx % 2 === 0 ? 'Rajasthan' : 'Gujarat',
        district: 'Heritage Craft Hub',
        category: idx % 3 === 0 ? 'Pottery' : 'Textiles',
        giTagged: idx % 2 === 0,
        materials: ['Handspun Cotton', 'Natural Dyes'],
        techniques: ['Block Printing', 'Hand Weaving'],
        history: 'Preserved across multiple generations of master craftspeople.',
        priceRange: '₹1,800 - ₹8,500',
        heroImage: craftImagesPack[idx % craftImagesPack.length],
        galleryImages: [craftImagesPack[idx % craftImagesPack.length], craftImagesPack[(idx + 1) % craftImagesPack.length]],
      });
    }

    console.log(`Seeding ${craftsList.length} Crafts...`);
    const insertedCrafts = await Craft.insertMany(craftsList);

    // 2. Seed Festivals (15 Festivals)
    const festivalNames = [
      { name: 'Diwali', month: 'October/November', states: ['Pan-India'], relatedCrafts: ['Brass Lamp', 'Terracotta Diyas'] },
      { name: 'Pushkar Fair', month: 'November', states: ['Rajasthan'], relatedCrafts: ['Blue Pottery', 'Leather Craft'] },
      { name: 'Rann Utsav', month: 'December - February', states: ['Gujarat'], relatedCrafts: ['Bandhani', 'Ajrakh Block Print'] },
      { name: 'Durga Puja', month: 'September/October', states: ['West Bengal'], relatedCrafts: ['Dokra Art', 'Kantha Embroidery'] },
      { name: 'Pongal', month: 'January', states: ['Tamil Nadu'], relatedCrafts: ['Kanchipuram Silk', 'Tanjore Painting'] },
      { name: 'Hornbill Festival', month: 'December', states: ['Nagaland'], relatedCrafts: ['Naga Tribal Weaving', 'Bamboo Basketry'] },
      { name: 'Onam', month: 'August/September', states: ['Kerala'], relatedCrafts: ['Aranmula Mirror', 'Kasavu Sarees'] },
      { name: 'Bihu', month: 'April', states: ['Assam'], relatedCrafts: ['Muga Silk', 'Bamboo Crafts'] },
      { name: 'Holi', month: 'March', states: ['Pan-India'], relatedCrafts: ['Chikankari', 'Gulal Terracotta'] },
      { name: 'Makar Sankranti', month: 'January', states: ['Gujarat', 'Maharashtra'], relatedCrafts: ['Patola Silk', 'Warli Painting'] },
      { name: 'Ganesh Chaturthi', month: 'August/September', states: ['Maharashtra'], relatedCrafts: ['Clay Idols', 'Paithani Sarees'] },
      { name: 'Kumbh Mela', month: 'February', states: ['Uttar Pradesh'], relatedCrafts: ['Brass Utensils', 'Wood Carving'] },
      { name: 'Mysore Dasara', month: 'October', states: ['Karnataka'], relatedCrafts: ['Mysore Silk', 'Channapatna Toys'] },
      { name: 'Hemis Festival', month: 'June/July', states: ['Ladakh'], relatedCrafts: ['Pashmina Shawls', 'Thangka Paintings'] },
      { name: 'Surajkund Crafts Mela', month: 'February', states: ['Haryana'], relatedCrafts: ['Phulkari Embroidery', 'Terracotta'] },
    ];

    console.log(`Seeding ${festivalNames.length} Festivals...`);
    await Festival.insertMany(
      festivalNames.map((f, idx) => ({
        ...f,
        heroImage: craftImagesPack[idx % craftImagesPack.length],
        description: `Annual celebration highlighting authentic regional craft tradition in ${f.states.join(', ')}.`,
      }))
    );

    // 3. Seed 10 Artisan Profiles
    const bcrypt = require('bcryptjs');
    const salt = await bcrypt.genSalt(10);
    const defaultPassword = await bcrypt.hash('Artisan123!', salt);

    console.log('Seeding 10 Artisan User Profiles...');
    const artisanProfiles = [];
    for (let i = 1; i <= 10; i++) {
      const user = await User.create({
        name: `Master Artisan ${i}`,
        email: `artisan${i}@virasat.in`,
        phone: `+91 98765 4321${i}`,
        passwordHash: defaultPassword,
        role: 'artisan',
        avatar: craftImagesPack[(i - 1) % craftImagesPack.length],
      });

      const artisan = await Artisan.create({
        userId: user._id,
        artisanName: `Master ${['Ramji Khatri', 'Devi Prasad', 'Lakshmi Bai', 'Sunderlal Saini', 'Amina Begum', 'Bhagwan Das', 'Radha Raman', 'Kanhaiya Lal', 'Savitri Devi', 'Gopal Sharma'][i - 1]}`,
        craftSpecialization: insertedCrafts[(i - 1) % insertedCrafts.length].category,
        bio: `National Award-winning master artisan practicing traditional ${insertedCrafts[(i - 1) % insertedCrafts.length].craftName} for over ${15 + i * 2} years.`,
        state: insertedCrafts[(i - 1) % insertedCrafts.length].state,
        district: insertedCrafts[(i - 1) % insertedCrafts.length].district,
        village: `Artisan Cluster #${i}`,
        yearsExperience: 15 + i * 2,
        giCertified: i % 2 === 0,
        verificationStatus: 'verified',
        profileCompletion: 100,
        followers: 120 + i * 45,
        earnings: 145000 + i * 28000,
        rating: 4.8 + (i % 3) * 0.1,
        story: `Heritage story of artisan cluster #${i} dedicated to zero-carbon hand-crafted traditions.`,
        bannerImage: craftImagesPack[(i - 1) % craftImagesPack.length],
        avatarImage: craftImagesPack[(i - 1) % craftImagesPack.length],
      });

      artisanProfiles.push(artisan);
    }

    // Helper to get craft-specific image list
    const getMatchingImagesForCraft = (craftName) => {
      const name = (craftName || '').toLowerCase();
      if (name.includes('bandhani')) return craftImagesPack.filter(img => img.includes('bandhani_'));
      if (name.includes('patola')) return craftImagesPack.filter(img => img.includes('patola_'));
      if (name.includes('ajrakh')) return craftImagesPack.filter(img => img.includes('ajrakh_'));
      if (name.includes('rogan')) return craftImagesPack.filter(img => img.includes('rogan_art_'));
      if (name.includes('blue pottery') || name.includes('pottery')) return craftImagesPack.filter(img => img.includes('blue_pottery_'));
      if (name.includes('meenakari')) return craftImagesPack.filter(img => img.includes('meenakari_'));
      if (name.includes('bagru')) return craftImagesPack.filter(img => img.includes('bagru_print_'));
      if (name.includes('sanganeri')) return craftImagesPack.filter(img => img.includes('sanganeri_print_'));
      if (name.includes('chanderi')) return craftImagesPack.filter(img => img.includes('chanderi_'));
      if (name.includes('gond')) return craftImagesPack.filter(img => img.includes('gond_painting_'));
      if (name.includes('chikankari')) return craftImagesPack.filter(img => img.includes('chikankari_'));
      if (name.includes('banarasi')) return craftImagesPack.filter(img => img.includes('banarasi_silk_'));
      if (name.includes('kantha')) return craftImagesPack.filter(img => img.includes('kantha_'));
      if (name.includes('terracotta') || name.includes('bankura')) return craftImagesPack.filter(img => img.includes('bankura_terracotta_'));
      if (name.includes('pashmina')) return craftImagesPack.filter(img => img.includes('pashmina_'));
      if (name.includes('papier') || name.includes('mache')) return craftImagesPack.filter(img => img.includes('papier_mache_'));
      if (name.includes('pattachitra')) return craftImagesPack.filter(img => img.includes('pattachitra_'));
      if (name.includes('filigree') || name.includes('silver')) return craftImagesPack.filter(img => img.includes('silver_filigree_'));
      if (name.includes('channapatna') || name.includes('toy')) return craftImagesPack.filter(img => img.includes('channapatna_toys_'));
      if (name.includes('mysore')) return craftImagesPack.filter(img => img.includes('mysore_silk_'));
      if (name.includes('kanchipuram')) return craftImagesPack.filter(img => img.includes('kanchipuram_silk_'));
      if (name.includes('tanjore')) return craftImagesPack.filter(img => img.includes('tanjore_painting_'));
      if (name.includes('bamboo')) return craftImagesPack.filter(img => img.includes('bamboo_basket_'));
      if (name.includes('cane')) return craftImagesPack.filter(img => img.includes('cane_craft_'));
      if (name.includes('assam')) return craftImagesPack.filter(img => img.includes('assam_silk_'));
      return craftImagesPack;
    };

    // 4. Seed 100 Marketplace Products (Each receiving a craft-matched image)
    console.log('Generating 100 Marketplace Products with craft-matched asset paths...');
    const productsList = [];
    for (let i = 1; i <= 100; i++) {
      const craft = insertedCrafts[(i - 1) % insertedCrafts.length];
      const artisan = artisanProfiles[(i - 1) % artisanProfiles.length];
      const price = 1200 + (i % 20) * 350;

      const matchingImages = getMatchingImagesForCraft(craft.craftName);
      const primaryImage = matchingImages[(i - 1) % matchingImages.length];
      const secondaryImage = matchingImages[i % matchingImages.length];

      productsList.push({
        artisanId: artisan._id,
        title: `${craft.craftName} Masterpiece #${i}`,
        craftType: craft.craftName,
        state: craft.state,
        district: craft.district,
        giTag: craft.giTagged,
        description: `Authentic hand-crafted ${craft.craftName} made with premium organic materials by ${artisan.artisanName}.`,
        materials: craft.materials,
        colors: ['Crimson Red', 'Royal Indigo', 'Marigold Yellow'],
        dimensions: 'Standard Handmade Dimensions',
        images: [primaryImage, secondaryImage],
        coverImage: primaryImage,
        heroImage: primaryImage,
        galleryImages: [primaryImage, secondaryImage],
        heritageStory: `This heirloom piece features certified GI origin protection and handcraft excellence from ${craft.state}.`,
        aiConfidence: 0.95 + (i % 5) * 0.01,
        authenticityScore: 95 + (i % 5),
        suggestedPrice: price + 400,
        sellingPrice: price,
        stock: 5 + (i % 15),
        category: craft.category,
        tags: [craft.category, craft.state, 'Handmade', 'GI Tagged'],
        festivalTags: ['Diwali', 'Rann Utsav', 'Surajkund'],
        featured: i <= 15,
      });
    }

    await Product.insertMany(productsList);

    console.log('====================================================');
    console.log('  VIRASAT Database Seed Successfully Completed!    ');
    console.log(`  - Crafts: ${insertedCrafts.length}`);
    console.log(`  - Festivals: ${festivalNames.length}`);
    console.log(`  - Artisans: ${artisanProfiles.length}`);
    console.log(`  - Products: ${productsList.length}`);
    console.log(`  - Unique Asset Images: ${craftImagesPack.length}`);
    console.log('====================================================');

    process.exit(0);
  } catch (error) {
    console.error('Database Seeding Error:', error);
    process.exit(1);
  }
};

seedData();
