import express from 'express';
import { saveHistory, getUserHistory } from '../controller/history.controller.js';

const router = express.Router();

router.post('/save', saveHistory);
router.get('/:userId', getUserHistory);

export default router;
