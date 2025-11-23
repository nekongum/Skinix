import 'package:flutter/material.dart';
import '../widgets/bottom_nav.dart';
import '../theme/app_colors.dart';
import '../utils/monk_skin_tones.dart';
import 'dart:math';

class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  Map<String, dynamic>? result;
  bool loading = true;
  int matchedIndex = 0; // index เฉดที่ match ใน monkSkinTones

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // รับ arguments จากหน้าก่อน (ควรส่ง lab: { l, a, b })
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && args is Map<String, dynamic> && args['lab'] != null) {
      final lab = args['lab'];
      final L = (lab['l'] as num).toDouble();
      final a = (lab['a'] as num).toDouble();
      final b = (lab['b'] as num).toDouble();

      // หาเฉด skin tone ที่ใกล้ที่สุด
      matchedIndex = _findNearestMonkSkinTone(L, a, b);

      setState(() {
        result = {
          'L': L,
          'a': a,
          'b': b,
          'monk_hex': monkSkinTones[matchedIndex]['hex'],
          'monk_index': matchedIndex + 1, // index เริ่มที่ 1 เพื่อให้ human-friendly
        };
        loading = false;
      });
    } else {
      _loadMockResult();
    }
  }

  /// ถ้าไม่ได้ argument/ยิง api fail จะ fallback มาที่ mock data
  Future<void> _loadMockResult() async {
    await Future.delayed(const Duration(seconds: 1));
    matchedIndex = 0;
    setState(() {
      result = {
        'L': monkSkinTones[matchedIndex]['L'],
        'a': monkSkinTones[matchedIndex]['a'],
        'b': monkSkinTones[matchedIndex]['b'],
        'monk_hex': monkSkinTones[matchedIndex]['hex'],
        'monk_index': matchedIndex + 1,
      };
      loading = false;
    });
  }

  /// หา index เฉดผิวใน monkSkinTones ที่ใกล้เคียงสุดจาก LAB ที่รับมา
  int _findNearestMonkSkinTone(double L, double a, double b) {
    int resultIndex = 0;
    double minDist = double.infinity;
    for (int i = 0; i < monkSkinTones.length; i++) {
      final tone = monkSkinTones[i];
      final d = sqrt(
        pow(L - tone['L'], 2) +
        pow(a - tone['a'], 2) +
        pow(b - tone['b'], 2)
      );
      if (d < minDist) {
        minDist = d;
        resultIndex = i;
      }
    }
    return resultIndex;
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
    final monk = monkSkinTones[matchedIndex];
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
            // Preview color จาก monkSkinTones
            Container(
              height: 130,
              width: 130,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: monk['color'] as Color,
              ),
            ),
            Column(
              children: [
                Text(
                  "Tone #${result!['monk_index']} HEX: ${result!['monk_hex']}",
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "LAB: L*: ${result!['L']}, a*: ${result!['a']}, b*: ${result!['b']}",
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
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

void _onMixNowPressed() {
  Navigator.pushNamed(
    context,
    '/mixing',
    arguments: {
      'matchedIndex': matchedIndex, // ส่ง matchedIndex
    },
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
            backgroundImage: AssetImage('assets/profile.jpg'),
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
