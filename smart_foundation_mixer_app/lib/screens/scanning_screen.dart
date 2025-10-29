import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class ScanningScreen extends StatefulWidget {
  const ScanningScreen({super.key});

  @override
  State<ScanningScreen> createState() => _ScanningScreenState();
}

class _ScanningScreenState extends State<ScanningScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  double progressValue = 0;

  @override
  void initState() {
    super.initState();

    // 🔹 จำลองการ "สแกน" 3 วินาที
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..addListener(() {
        setState(() {
          progressValue = _controller.value;
        });
      });

    _controller.forward();

    // 🔹 เมื่อโหลดครบ -> ไปหน้า result (ไม่มี backend)
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed && mounted) {
        Navigator.pushReplacementNamed(context, '/result');
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBrown,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 🟤 ข้อความกลางจอ
                const Text(
                  "Analyzing your skin tone...",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 60),

                // 🔘 Progress bar
                LinearProgressIndicator(
                  value: progressValue,
                  minHeight: 8,
                  color: Colors.white,
                  backgroundColor: Colors.white24,
                  borderRadius: BorderRadius.circular(12),
                ),
                const SizedBox(height: 15),

                // เปอร์เซ็นต์แสดงความคืบหน้า
                Text(
                  "${(progressValue * 100).toInt()}%",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
