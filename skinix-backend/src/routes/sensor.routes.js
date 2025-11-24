import express from 'express';
import {
  addSensorData,
  getLatestSensorData,
  mockScanSensor
} from '../controllers/sensor.controller.js';

const router = express.Router();

// Mock LAB data for integration testing (แก้ให้ return LAB color space)
router.get('/mock-lab', (req, res) => {
  res.json({
    lab: {
      l: Number((Math.random() * 100).toFixed(2)),
      a: Number((Math.random() * 50 - 25).toFixed(2)), // typical L*a*b* space range
      b: Number((Math.random() * 50 - 25).toFixed(2))
    },
    detected: true,
    message: 'Mock LAB color generated'
  });
});

// POST /api/sensor/scan -- สำหรับ mobile app เรียกเพื่อขอ LAB color (mock)
router.post('/scan', mockScanSensor);

// POST /api/sensor -- สำหรับ save lab data เข้าฐานข้อมูล (option)
router.post('/', addSensorData);

// GET /api/sensor/latest -- สำหรับดึงล่าสุด
router.get('/latest', getLatestSensorData);

export default router;
