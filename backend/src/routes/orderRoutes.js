const express = require('express');
const router = express.Router();
const {
  createOrder,
  getMyOrders,
  getArtisanOrders,
  updateOrderStatus,
  cancelOrder,
} = require('../controllers/orderController');
const { protect, authorize } = require('../middleware/auth');

router.post('/', protect, createOrder);
router.get('/my', protect, getMyOrders);
router.get('/artisan', protect, authorize('artisan', 'admin'), getArtisanOrders);
router.put('/:id/status', protect, authorize('artisan', 'admin'), updateOrderStatus);
router.post('/:id/cancel', protect, cancelOrder);

module.exports = router;
