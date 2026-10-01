const express = require('express');
const router = express.Router();
const {
  verifyArtisan,
  approveGiTag,
  featureProduct,
  getMarketplaceAnalytics,
} = require('../controllers/adminController');
const { protect, authorize } = require('../middleware/auth');

router.put('/verify-artisan/:id', protect, authorize('admin'), verifyArtisan);
router.put('/approve-gi/:id', protect, authorize('admin'), approveGiTag);
router.put('/feature-product/:id', protect, authorize('admin'), featureProduct);
router.get('/analytics', protect, authorize('admin'), getMarketplaceAnalytics);

module.exports = router;
