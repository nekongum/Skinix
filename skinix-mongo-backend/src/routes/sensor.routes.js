import express from 'express';
import { addSensorData, getLatestSensorData } from '../controller/sensor.controller.js';

const router = express.Router();

router.post('/', addSensorData);
router.get('/latest', getLatestSensorData);

export default router;
