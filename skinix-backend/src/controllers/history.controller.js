import UserMixHistory from '../models/UserMixHistory.model.js';

export const saveHistory = async (req, res) => {
  try {
    const history = await UserMixHistory.create(req.body);
    res.status(201).json({ message: 'History saved', data: history });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

export const getUserHistory = async (req, res) => {
  try {
    const histories = await UserMixHistory.find({ userId: req.params.userId }).sort({ createdAt: -1 });
    res.status(200).json(histories);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};
