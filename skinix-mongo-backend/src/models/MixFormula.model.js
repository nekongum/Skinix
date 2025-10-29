import mongoose from 'mongoose';

const MixFormulaSchema = new mongoose.Schema({
  colorId: { type: mongoose.Schema.Types.ObjectId, ref: 'ColorAnalysis' },
  baseRatios: {
    base1: Number,
    base2: Number,
    base3: Number
  },
  totalVolume: { type: Number, default: 5.0 }, // ml หรือ g
  pumpCommands: [String], // เช่น ["P1:1.5ml", "P2:2ml", "P3:1.5ml"]
  createdAt: { type: Date, default: Date.now }
});

export default mongoose.model('MixFormula', MixFormulaSchema);
