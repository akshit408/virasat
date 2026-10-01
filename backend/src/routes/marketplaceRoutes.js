const express = require('express');
const router = express.Router();
const { getMarketplaceHome } = require('../controllers/marketplaceController');

router.get('/home', getMarketplaceHome);

module.exports = router;
