import express from 'express';
import { addSensorData, getLatestSensorData } from '../controllers/sensor.controller.js'; // <-- Fix path here!

const router = express.Router();

// Mock AS7341 data for mobile/backend integration testing
router.get('/mock-as7341', (req, res) => {
  res.json({
    f1: Math.floor(Math.random() * 2500),
    f2: Math.floor(Math.random() * 2500),
    f3: Math.floor(Math.random() * 2500),
    f4: Math.floor(Math.random() * 2500),
    f5: Math.floor(Math.random() * 2500),
    f6: Math.floor(Math.random() * 2500),
    f7: Math.floor(Math.random() * 2500),
    f8: Math.floor(Math.random() * 2500),
    clear: Math.floor(Math.random() * 6000),
    nir: Math.floor(Math.random() * 1200)
  });
});

router.post('/', addSensorData);
router.get('/latest', getLatestSensorData);

export default router;
