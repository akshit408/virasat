const express = require('express');
const router = express.Router();
const {
  getProducts,
  getFeaturedProducts,
  getNewProducts,
  getProductsByCategory,
  getProductsByState,
  getGiProducts,
  getProductById,
  createProduct,
  updateProduct,
  deleteProduct,
} = require('../controllers/productController');
const { protect, authorize } = require('../middleware/auth');

router.get('/', getProducts);
router.get('/featured', getFeaturedProducts);
router.get('/new', getNewProducts);
router.get('/category/:category', getProductsByCategory);
router.get('/state/:state', getProductsByState);
router.get('/gi', getGiProducts);
router.get('/:id', getProductById);

router.post('/', protect, authorize('artisan', 'admin'), createProduct);
router.put('/:id', protect, authorize('artisan', 'admin'), updateProduct);
router.delete('/:id', protect, authorize('artisan', 'admin'), deleteProduct);

module.exports = router;
