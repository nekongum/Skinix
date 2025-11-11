import mongoose from 'mongoose';

const UserMixHistorySchema = new mongoose.Schema({
  userId: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
  userName: { type: String, required: true },
  colorId: { type: mongoose.Schema.Types.ObjectId, ref: 'ColorAnalysis' },
  formulaId: { type: mongoose.Schema.Types.ObjectId, ref: 'MixFormula' },
  savedName: { type: String, required: true }, // เช่น “Pimmy Skin Sep 2025”
  undertone: String,
  hex: String,
  rgb: { r: Number, g: Number, b: Number },
  lab: { L: Number, a: Number, b: Number },
  satisfaction: { type: Number, default: 0 }, // user rating
  createdAt: { type: Date, default: Date.now }
});

export default mongoose.model('UserMixHistory', UserMixHistorySchema);
