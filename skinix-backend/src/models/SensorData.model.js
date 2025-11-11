import mongoose from 'mongoose';

const SensorDataSchema = new mongoose.Schema({
  f1: Number, f2: Number, f3: Number, f4: Number,
  f5: Number, f6: Number, f7: Number, f8: Number,
  clear: Number,
  nir: Number,
}, { timestamps: true }); // <-- Use this

export default mongoose.model('SensorData', SensorDataSchema);
