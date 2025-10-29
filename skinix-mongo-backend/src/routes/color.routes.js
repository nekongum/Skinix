import express from 'express';
import { analyzeColor, getLatestColor } from '../controller/color.controller.js';

const router = express.Router();

router.post('/analyze', analyzeColor);
router.get('/latest', getLatestColor);

export default router;
