const express = require('express');
const router = express.Router();
const {
  getCrafts,
  getCraftById,
  getCraftsByCategory,
  getStates,
  getCraftsByState,
  searchCrafts,
} = require('../controllers/discoverController');

router.get('/states', getStates);
router.get('/states/:state/crafts', getCraftsByState);
router.get('/crafts', getCrafts);
router.get('/crafts/search', searchCrafts);
router.get('/crafts/category/:category', getCraftsByCategory);
router.get('/crafts/:id', getCraftById);

module.exports = router;
