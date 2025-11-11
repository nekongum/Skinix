import ColorAnalysis from '../models/ColorAnalysis.model.js';

export const analyzeColor = async (req, res) => {
  try {
    const color = await ColorAnalysis.create(req.body);
    res.status(201).json({ message: 'Color analysis saved', data: color });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

export const getLatestColor = async (req, res) => {
  try {
    const latest = await ColorAnalysis.findOne().sort({ createdAt: -1 });
    res.status(200).json(latest);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};
