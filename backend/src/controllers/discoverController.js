const Craft = require('../models/Craft');

exports.getCrafts = async (req, res) => {
  try {
    const { category, state, giTagged, q } = req.query;
    const query = {};

    if (q) {
      query.$or = [
        { craftName: { $regex: q, $options: 'i' } },
        { state: { $regex: q, $options: 'i' } },
        { category: { $regex: q, $options: 'i' } },
        { history: { $regex: q, $options: 'i' } },
      ];
    }
    if (category) query.category = category;
    if (state) query.state = state;
    if (giTagged !== undefined) query.giTagged = giTagged === 'true';

    const crafts = await Craft.find(query);
    res.status(200).json({ success: true, count: crafts.length, crafts });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

exports.getCraftById = async (req, res) => {
  try {
    const craft = await Craft.findById(req.params.id);
    if (!craft) {
      return res.status(404).json({ success: false, message: 'Craft not found' });
    }
    res.status(200).json({ success: true, craft });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

exports.getCraftsByCategory = async (req, res) => {
  try {
    const crafts = await Craft.find({ category: req.params.category });
    res.status(200).json({ success: true, count: crafts.length, crafts });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

exports.getStates = async (req, res) => {
  try {
    const states = await Craft.distinct('state');
    const stateList = states.map((stateName, index) => ({
      id: `IN-${(index + 1).toString().padStart(2, '0')}`,
      name: stateName,
      craftCount: Math.floor(Math.random() * 8) + 2,
    }));
    res.status(200).json({ success: true, count: stateList.length, states: stateList });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

exports.getCraftsByState = async (req, res) => {
  try {
    const crafts = await Craft.find({ state: { $regex: new RegExp(req.params.state, 'i') } });
    res.status(200).json({ success: true, count: crafts.length, crafts });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

exports.searchCrafts = async (req, res) => {
  try {
    const { q } = req.query;
    if (!q) {
      return res.status(200).json({ success: true, crafts: [] });
    }
    const crafts = await Craft.find({
      $or: [
        { craftName: { $regex: q, $options: 'i' } },
        { state: { $regex: q, $options: 'i' } },
        { category: { $regex: q, $options: 'i' } },
      ],
    });
    res.status(200).json({ success: true, count: crafts.length, crafts });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};
