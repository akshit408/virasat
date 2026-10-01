const Festival = require('../models/Festival');
const Craft = require('../models/Craft');

exports.getFestivals = async (req, res) => {
  try {
    const festivals = await Festival.find();
    res.status(200).json({ success: true, count: festivals.length, festivals });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

exports.getCurrentFestivals = async (req, res) => {
  try {
    const months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
    const currentMonth = months[new Date().getMonth()];
    
    let festivals = await Festival.find({ month: { $regex: currentMonth, $options: 'i' } });
    if (festivals.length === 0) {
      festivals = await Festival.find().limit(3);
    }
    res.status(200).json({ success: true, count: festivals.length, festivals });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

exports.getFestivalByName = async (req, res) => {
  try {
    const festival = await Festival.findOne({ name: { $regex: new RegExp(req.params.festival, 'i') } });
    if (!festival) {
      return res.status(404).json({ success: false, message: 'Festival not found' });
    }

    const relatedCrafts = await Craft.find({
      $or: [
        { craftName: { $in: festival.relatedCrafts || [] } },
        { state: { $in: festival.states || [] } },
      ],
    }).limit(10);

    res.status(200).json({
      success: true,
      festival,
      relatedCrafts,
    });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};
