import mongoose from 'mongoose';

const ColorAnalysisSchema = new mongoose.Schema({
  sensorId: { type: mongoose.Schema.Types.ObjectId, ref: 'SensorData' },
  hex: { type: String },
  rgb: { r: Number, g: Number, b: Number },
  lab: { L: Number, a: Number, b: Number },
  undertone: { type: String }, // Warm, Cool, Neutral, Warm Neutral
  matchedShade: { type: String }, // เช่น "Light Beige" หรือ "Tan 3"
  deltaE: Number,
  aiModelVersion: { type: String }, // เผื่ออัปเดตโมเดล AI
  createdAt: { type: Date, default: Date.now }
});

export default mongoose.model('ColorAnalysis', ColorAnalysisSchema);
