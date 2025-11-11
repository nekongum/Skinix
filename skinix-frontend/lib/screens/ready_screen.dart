import 'package:flutter/material.dart';
import '../widgets/bottom_nav.dart';
import '../theme/app_colors.dart';

class ReadyScreen extends StatefulWidget {
  const ReadyScreen({super.key});

  @override
  State<ReadyScreen> createState() => _ReadyScreenState();
}

class _ReadyScreenState extends State<ReadyScreen> {
  Map<String, dynamic>? mix;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadMockMix(); // ✅ ใช้ mock data แทน API
  }

  /// 🎨 จำลองข้อมูลการผสมล่าสุด
  Future<void> _loadMockMix() async {
    await Future.delayed(const Duration(seconds: 1)); // จำลองโหลดข้อมูล
    setState(() {
      mix = {
        'L': 68.0,
        'a': 14.0,
        'b': 20.5,
        'shade_code': 'SF-03',
        'shade': 'Natural Beige',
        'undertone': 'Neutral',
        'formula': {
          'white': 25.0,
          'red': 20.0,
          'yellow': 30.0,
          'brown': 15.0,
          'black': 10.0,
        },
      };
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final cardHeight = screenHeight * 0.55;

    if (loading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: AppColors.primaryBrown),
        ),
      );
    }

    if (mix == null) {
      return const Scaffold(
        body: Center(child: Text("No mix data found")),
      );
    }

    final color = _labToColor(
      mix!['L']?.toDouble() ?? 70,
      mix!['a']?.toDouble() ?? 0,
      mix!['b']?.toDouble() ?? 0,
    );

    return Scaffold(
      bottomNavigationBar: const BottomNavBar(currentIndex: 1),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _header(),
              SizedBox(height: screenHeight * 0.07),
              Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: cardHeight,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
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
                      const Icon(Icons.check_circle,
                          size: 60, color: AppColors.primaryBrown),
                      const Text(
                        "Foundation Ready!",
                        style: TextStyle(
                          color: AppColors.textDark,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        height: 120,
                        width: 120,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                        ),
                      ),
                      Column(
                        children: [
                          Text(
                            "${mix!['shade_code']} ${mix!['shade']}",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textDark,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Undertone: ${mix!['undertone']}",
                            style: const TextStyle(
                              color: AppColors.textDark,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () => _showSaveDialog(context),
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
                          "Save",
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
              ),
              const SizedBox(height: 40),
            ],
          ),
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

  /// 💾 Popup จำลองสำหรับบันทึกข้อมูล
  void _showSaveDialog(BuildContext context) {
    final TextEditingController nameCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.cream,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Enter your name"),
        content: TextField(
          controller: nameCtrl,
          decoration: const InputDecoration(
            hintText: "Your name",
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
          ),
        ),
        actions: [
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        "💾 Saved successfully for ${nameCtrl.text.isEmpty ? "Guest" : nameCtrl.text}!"),
                    backgroundColor: AppColors.primaryBrown,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBrown,
                padding: const EdgeInsets.symmetric(
                    horizontal: 40, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text("Save",
                  style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  /// 🧍 Header ด้านบน
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
