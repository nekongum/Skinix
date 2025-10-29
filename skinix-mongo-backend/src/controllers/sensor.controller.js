import SensorData from '../models/SensorData.model.js';

// เพิ่มข้อมูล sensor ใหม่
export const addSensorData = async (req, res) => {
  try {
    const data = await SensorData.create(req.body);
    res.status(201).json({ message: 'Sensor data saved', data });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// ดึงข้อมูลล่าสุด
export const getLatestSensorData = async (req, res) => {
  try {
    const latest = await SensorData.findOne().sort({ createdAt: -1 });
    res.status(200).json(latest);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};
