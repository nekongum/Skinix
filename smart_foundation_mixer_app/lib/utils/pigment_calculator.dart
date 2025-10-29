// import 'dart:math';

// /// 💄 ฟังก์ชันจำลองคำนวณสูตรผสมสีจากค่า L*, a*, b*
// /// (ทีมสามารถปรับสูตรจริงทีหลังได้)
// Map<String, double> calculatePigment(double L, double a, double b) {
//   // Normalize ค่าให้เป็น 0–1
//   double lightness = (L / 100).clamp(0, 1);
//   double redness = ((a + 128) / 255).clamp(0, 1);
//   double yellowness = ((b + 128) / 255).clamp(0, 1);

//   // สูตรจำลอง: ใช้ค่าจาก LAB สร้างอัตราส่วนสีพื้นฐาน
//   double white = lightness * 60 + (1 - redness) * 10;
//   double red = redness * 30;
//   double yellow = yellowness * 25;
//   double brown = (1 - lightness) * 20;
//   double black = max(0, 100 - (white + red + yellow + brown));

//   // ปรับให้รวมกันประมาณ 100%
//   double total = white + red + yellow + brown + black;
//   return {
//     'white': (white / total * 100),
//     'red': (red / total * 100),
//     'yellow': (yellow / total * 100),
//     'brown': (brown / total * 100),
//     'black': (black / total * 100),
//   };
// }
