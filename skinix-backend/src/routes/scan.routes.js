import { Router } from 'express';
import { Scan } from '../models/Scan.js';
//import axios from 'axios'; // ✅ เพิ่ม axios เพื่อยิง HTTP ออกไปหา ESP32
const router = Router();

/**
 * ✅ 1) Flutter → Backend
 * Route สำหรับสั่งให้ ESP32 เริ่มสแกน
 * POST /api/scan/command/scan
 */
router.post('/command/scan', async (req, res) => {
  try {
    console.log('📡 Flutter: Requesting scan...');
    // ตอนนี้เรายังไม่มี ESP32 จริง จึง mock response ไปก่อน
    // ภายหลังจะส่ง HTTP ไปยัง ESP32 ได้ เช่น:
    // await axios.post('http://192.168.x.x/start-scan');

    // ส่งกลับให้ Flutter ว่า “สั่งสแกนแล้ว”
    res.status(200).json({
      success: true,
      message: 'Scan command received by backend ✅ (waiting for ESP32)',
    });
  } catch (err) {
    console.error('❌ Error in /command/scan:', err);
    res.status(500).json({ error: 'Failed to send scan command' });
  }
});

/**
 * ✅ 2) ESP32 → Backend
 * Route สำหรับรับผลสแกนจาก ESP32 (ค่า f1–f8 + clear + nir)
 * POST /api/scan/esp
 */
router.post('/esp', async (req, res) => {
  try {
    const rawData = req.body; // ESP32 ส่ง JSON เข้ามา
    console.log('📥 Data from ESP32:', rawData);

    // บันทึกลง MongoDB (mock user_id ไปก่อน)
    const doc = await Scan.create({
      user_id: 'esp_device_01',
      L: 0,
      a: 0,
      b: 0,
      deltaE: 0,
      raw: rawData,
    });

    res.json({ success: true, id: doc._id });
  } catch (err) {
    console.error('❌ ESP32 data error:', err);
    res.status(500).json({ success: false, error: err.message });
  }
});

/**
 * ✅ 3) Flutter/Backend → Save Scan (LAB + optional raw)
 * POST /api/scan
 */
router.post('/', async (req, res) => {
  try {
    const { user_id, L, a, b, deltaE, raw } = req.body;

    // ตรวจฟิลด์บังคับ
    if (!user_id || L == null || a == null || b == null || deltaE == null) {
      return res.status(400).json({ error: 'Missing required fields' });
    }

    // บันทึกลง MongoDB
    const doc = await Scan.create({ user_id, L, a, b, deltaE, raw });
    res.status(201).json({ success: true, id: doc._id });
  } catch (e) {
    console.error(e);
    res.status(500).json({ error: 'Failed to save scan' });
  }
});

router.post('/command/scan', async (req, res) => {
  console.log('📡 Flutter: Requesting scan...');

  try {
    // 👉 IP ของ ESP32 (แก้เป็นของเครื่องเธอจาก Serial Monitor)
    const ESP32_IP = 'http://192.168.1.120'; 

    // 🔸 ยิงคำสั่งไปหา ESP32 เพื่อเริ่มสแกน
    const response = await axios.post(`${ESP32_IP}/start-scan`);

    console.log('✅ Command sent to ESP32:', response.status);
    res.json({ success: true, message: 'Scan command sent to ESP32 ✅' });
  } catch (err) {
    console.error('❌ Failed to contact ESP32:', err.message);
    res.status(500).json({ error: 'Failed to send scan command to ESP32' });
  }
});
// ✅ MOCK ROUTE: จำลองว่า ESP32 ส่งผลสแกนกลับ
function computeLabFromRaw(raw) {
  // 🧮 ตัวอย่างสูตรจำลอง (ยังไม่ต้องแม่นจริง แค่ให้ได้ผลต่อเนื่อง)
  const L = (raw.clear / 10) % 100;      // แปลงให้ค่าอยู่ในช่วง 0–100
  const a = ((raw.f1 + raw.f3) / 200) - 50;
  const b = ((raw.f5 + raw.f7) / 200) - 50;
  return { L, a, b };
}

// ฟังก์ชันจำลองหา undertone
function getUndertone(a, b) {
  if (a > 10 && b > 10) return 'Warm';
  if (a < -5 && b < 0) return 'Cool';
  return 'Neutral';
}

// ฟังก์ชันจับคู่เฉดใกล้เคียง
function matchShade(L, a, b) {
  const shades = [
    { code: 'SFM-01', name: 'Ivory', L: 90, a: 0, b: 5 },
    { code: 'SFM-03', name: 'Light Beige', L: 80, a: 5, b: 10 },
    { code: 'SFM-05', name: 'Warm Beige', L: 70, a: 10, b: 20 },
    { code: 'SFM-07', name: 'Honey', L: 60, a: 15, b: 25 },
    { code: 'SFM-09', name: 'Tan', L: 50, a: 20, b: 30 }
  ];
  let closest = shades[0];
  let minDist = Infinity;
  for (const s of shades) {
    const dist = Math.sqrt(
      Math.pow(L - s.L, 2) + Math.pow(a - s.a, 2) + Math.pow(b - s.b, 2)
    );
    if (dist < minDist) {
      minDist = dist;
      closest = s;
    }
  }
  return closest;
}

// ✅ MOCK ESP32 ROUTE — คำนวณจริง
router.get('/mock-esp', async (req, res) => {
  console.log('🧪 Mock ESP32: generating fake sensor data...');
  try {
    const fakeData = {
      f1: 120, f2: 210, f3: 340, f4: 456,
      f5: 567, f6: 678, f7: 789, f8: 812,
      clear: 920, nir: 860
    };

    // คำนวณ LAB
    const { L, a, b } = computeLabFromRaw(fakeData);
    const undertone = getUndertone(a, b);
    const shade = matchShade(L, a, b);

    const deltaE = Math.random() * 3; // จำลอง ΔE
    const doc = await Scan.create({
      user_id: 'esp_device_01',
      L, a, b, deltaE, undertone,
      shade: shade.name,
      shade_code: shade.code,
      raw: fakeData
    });

    console.log('✅ Saved analyzed scan:', doc._id);
    res.json({
      success: true,
      id: doc._id,
      L, a, b, undertone,
      shade: shade.name,
      shade_code: shade.code,
      deltaE
    });
  } catch (err) {
    console.error('❌ Error in mock-esp:', err);
    res.status(500).json({ error: 'Failed to mock ESP32 scan' });
  }
});
// ✅ Mock route: จำลองว่า ESP32 ส่งค่ากลับมา
router.post('/mock-esp', async (req, res) => {
  console.log('🧪 Mock ESP32: Sending fake sensor data...');
  try {
    // สร้างข้อมูลจำลองเหมือนที่ ESP32 จะส่ง
    const fakeData = {
      f1: 120, f2: 210, f3: 340, f4: 456,
      f5: 567, f6: 678, f7: 789, f8: 812,
      clear: 920, nir: 860
    };

    // จำลองค่าที่แปลงแล้ว
    const L = 72.4, a = 4.8, b = 16.9, deltaE = 2.1;

    // บันทึกลง MongoDB
    const doc = await Scan.create({
      user_id: 'esp_device_01',
      L, a, b, deltaE, raw: fakeData
    });

    console.log('✅ Saved mock scan:', doc._id);
    res.json({ success: true, id: doc._id });
  } catch (err) {
    console.error('❌ Mock ESP32 error:', err);
    res.status(500).json({ error: 'Failed to mock ESP32 scan' });
  }
});

export default router;
