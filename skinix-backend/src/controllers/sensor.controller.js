import SensorData from '../models/SensorData.model.js';

// Add new sensor data
export const addSensorData = async (req, res) => {
  try {
    const data = await SensorData.create(req.body);
    res.status(201).json({ message: 'Sensor data saved', data });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Get latest sensor data
export const getLatestSensorData = async (req, res) => {
  try {
    const latest = await SensorData.findOne().sort({ createdAt: -1 });
    res.status(200).json(latest);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};
