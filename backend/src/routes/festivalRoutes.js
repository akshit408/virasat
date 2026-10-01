const express = require('express');
const router = express.Router();
const { getFestivals, getCurrentFestivals, getFestivalByName } = require('../controllers/festivalController');

router.get('/', getFestivals);
router.get('/current', getCurrentFestivals);
router.get('/:festival', getFestivalByName);

module.exports = router;
