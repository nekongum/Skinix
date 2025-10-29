import express from 'express';
import { createMixFormula, getLatestMixFormula } from '../controller/mix.controller.js';

const router = express.Router();

router.post('/calculate', createMixFormula);
router.get('/latest', getLatestMixFormula);

export default router;
