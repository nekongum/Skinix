import MixFormula from '../models/MixFormula.model.js';

export const createMixFormula = async (req, res) => {
  try {
    const formula = await MixFormula.create(req.body);
    res.status(201).json({ message: 'Mix formula saved', data: formula });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

export const getLatestMixFormula = async (req, res) => {
  try {
    const latest = await MixFormula.findOne().sort({ createdAt: -1 });
    res.status(200).json(latest);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};
