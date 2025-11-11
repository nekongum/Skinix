import dotenv from "dotenv";
dotenv.config();

import express from "express";
import mongoose from "mongoose";
import cors from "cors";
import authRoutes from "./src/routes/auth.routes.js";
import sensorRoutes from "./src/routes/sensor.routes.js"; // ✅ Added for sensor endpoints

const app = express();
app.use(express.json());

// ✅ CORS for Dev (Flutter Web origin changes every run)
app.use(cors({
  origin: function (origin, callback) {
    if (!origin) return callback(null, true);
    if (origin.startsWith("http://localhost")) return callback(null, true);
    callback(new Error("CORS not allowed"));
  },
  credentials: true,
  methods: ["GET", "POST", "PUT", "DELETE", "OPTIONS"],
  allowedHeaders: ["Content-Type", "Authorization"],
}));

// ✅ Handle preflight
app.options("*", cors());

const PORT = process.env.PORT || 5000;
const MONGO_URI = process.env.MONGODB_URI;

mongoose.connect(MONGO_URI)
  .then(() => console.log("✅ MongoDB connected"))
  .catch((err) => console.error("MongoDB connection error:", err));

// ✅ Mount all routes
app.use("/api/auth", authRoutes);
app.use("/api/sensor", sensorRoutes); // ✅ Sensor endpoints active

app.listen(PORT, () => console.log(`🚀 Server running on port ${PORT}`));
