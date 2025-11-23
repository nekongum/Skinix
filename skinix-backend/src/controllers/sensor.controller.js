import SensorData from '../models/SensorData.model.js';

// Monk Skin Tone LAB set (10 เฉด)
const monkSkinTones = [
  { l: 93.7, a: 1.8,  b: 6.4  },
  { l: 91.9, a: 2.2,  b: 8.7  },
  { l: 92.6, a: -0.2, b: 14.9 },
  { l: 87.3, a: 1.0,  b: 17.8 },
  { l: 78.0, a: 2.8,  b: 20.6 },
  { l: 58.3, a: 8.6,  b: 23.7 },
  { l: 49.1, a: 7.5,  b: 16.9 },
  { l: 38.2, a: 4.9,  b: 9.7  },
  { l: 24.8, a: 1.3,  b: 4.3  },
  { l: 17.1, a: 0.7,  b: 2.6  }
];

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

// Mock scan sensor 
export const mockScanSensor = async (req, res) => {
  await new Promise(resolve => setTimeout(resolve, 7000)); // Delay จำลอง 7 วินาที
  try {
    const lab = monkSkinTones[Math.floor(Math.random() * monkSkinTones.length)];
    res.status(200).json({
      lab,
      detected: true,
      message: "Mock monk skin tone (random)"
    });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};
