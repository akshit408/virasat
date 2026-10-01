const express = require('express');
const router = express.Router();
const {
  getArtisans,
  getArtisanById,
  getMyArtisanProfile,
  updateMyArtisanProfile,
  getArtisanProducts,
  getArtisanStats,
} = require('../controllers/artisanController');
const { protect, authorize } = require('../middleware/auth');

router.get('/', getArtisans);
router.get('/profile/me', protect, authorize('artisan', 'admin'), getMyArtisanProfile);
router.put('/profile', protect, authorize('artisan', 'admin'), updateMyArtisanProfile);

router.get('/:id', getArtisanById);
router.get('/:id/products', getArtisanProducts);
router.get('/:id/stats', getArtisanStats);

module.exports = router;
