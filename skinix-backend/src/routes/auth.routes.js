import express from "express";
import { registerUser, loginUser, verifyToken } from "../controllers/auth.controller.js";

const router = express.Router();

router.post("/register", registerUser);
router.post("/login", loginUser);

// ✅ ทดสอบ route ที่ต้องใช้ token
router.get("/me", verifyToken, (req, res) => {
  res.json({ message: "Protected route accessed!", userId: req.userId });
});

export default router;
