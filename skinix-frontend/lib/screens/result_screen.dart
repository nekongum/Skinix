import 'package:flutter/material.dart';
import '../widgets/bottom_nav.dart';
import '../theme/app_colors.dart';
import 'dart:math';

class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  Map<String, dynamic>? result;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadMockResult(); // ✅ ใช้ข้อมูลจำลองแทน API
  }

  /// 🎨 จำลองข้อมูลผลการสแกน (แทนการโหลดจาก backend)
  Future<void> _loadMockResult() async {
    await Future.delayed(const Duration(seconds: 1)); // หน่วงเวลาให้ดูเหมือนโหลด
    setState(() {
      result = {
        'L': 72.5,
        'a': 15.3,
        'b': 22.8,
        'shade_code': 'SF-02',
        'shade': 'Warm Beige',
        'undertone': 'Warm (Yellow)',
      };
      loading = false;
    });
  }

  /// 🎨 คำนวณสูตร pigment จากค่า L*a*b*
  Map<String, double> _calculatePigment(double L, double a, double b) {
    double lightness = (L / 100).clamp(0, 1);
    double redness = ((a + 128) / 255).clamp(0, 1);
    double yellowness = ((b + 128) / 255).clamp(0, 1);

    double white = lightness * 60 + (1 - redness) * 10;
    double red = redness * 30;
    double yellow = yellowness * 25;
    double brown = (1 - lightness) * 20;
    double black = max(0, 100 - (white + red + yellow + brown));

    double total = white + red + yellow + brown + black;
    return {
      'white': (white / total * 100),
      'red': (red / total * 100),
      'yellow': (yellow / total * 100),
      'brown': (brown / total * 100),
      'black': (black / total * 100),
    };
  }

  /// 🧪 เมื่อกด Mix Now (จำลองการไปหน้า mixing)
  void _onMixNowPressed() {
    if (result == null) return;

    final L = result!['L'].toDouble();
    final a = result!['a'].toDouble();
    final b = result!['b'].toDouble();

    final formula = _calculatePigment(L, a, b);
    print('🎨 Simulated Pigment Formula: $formula');

    Navigator.pushNamed(context, '/mixing');
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final cardHeight = screenHeight * 0.55;

    return Scaffold(
      bottomNavigationBar: const BottomNavBar(currentIndex: 1),
      body: SafeArea(
        child: loading
            ? const Center(
                child: CircularProgressIndicator(color: AppColors.primaryBrown))
            : SingleChildScrollView(
                child: Column(
                  children: [
                    _header(),
                    SizedBox(height: screenHeight * 0.08),
                    _resultCard(context, cardHeight),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _resultCard(BuildContext context, double cardHeight) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: cardHeight,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
        decoration: BoxDecoration(
          color: AppColors.cream,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text(
              "Your skin tone matched perfectly",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textDark,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),

            // 🟤 สีจำลองจาก LAB
            Container(
              height: 130,
              width: 130,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _labToColor(
                  result!['L'].toDouble(),
                  result!['a'].toDouble(),
                  result!['b'].toDouble(),
                ),
              ),
            ),

            Column(
              children: [
                Text(
                  "${result!['shade_code']} ${result!['shade']}",
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Undertone: ${result!['undertone']}",
                  style: const TextStyle(
                    color: AppColors.textDark,
                    fontSize: 14,
                  ),
                ),
              ],
            ),

            ElevatedButton(
              onPressed: _onMixNowPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBrown,
                padding: const EdgeInsets.symmetric(
                    horizontal: 40, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 3,
              ),
              child: const Text(
                "Mix now",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 🎨 แปลง LAB → RGB แบบคร่าว ๆ
  Color _labToColor(double L, double a, double b) {
    final r = (L + a * 1.1).clamp(0, 100);
    final g = (L - 0.3 * a - 0.6 * b).clamp(0, 100);
    final bl = (L + b * 1.2).clamp(0, 100);

    return Color.fromARGB(
      255,
      (r / 100 * 255).toInt(),
      (g / 100 * 255).toInt(),
      (bl / 100 * 255).toInt(),
    );
  }

  Widget _header() {
    return Container(
      color: AppColors.primaryBrown,
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      child: Row(
        children: const [
          CircleAvatar(
            radius: 30,
            backgroundImage: AssetImage('assets/images/profile.jpg'),
          ),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Hi Pimmy,",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "Perfect tone, Perfect you",
                style: TextStyle(color: Colors.white70),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
