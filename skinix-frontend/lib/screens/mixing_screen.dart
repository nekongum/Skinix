import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class MixingScreen extends StatefulWidget {
  const MixingScreen({super.key});

  @override
  State<MixingScreen> createState() => _MixingScreenState();
}

class _MixingScreenState extends State<MixingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
int matchedIndex = 0;

@override
void didChangeDependencies() {
  super.didChangeDependencies();
  final args = ModalRoute.of(context)?.settings.arguments;
  if (args != null &&
      args is Map<String, dynamic> &&
      args.containsKey('matchedIndex')) {
    matchedIndex = args['matchedIndex'] ?? 0;
  }
}


  @override
  void initState() {
    super.initState();

    // 🔹 สร้าง animation จำลองการผสมสี (3 วิ)
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..forward();

    // ❗ ย้าย pushReplacementNamed ไป didChangeDependencies ไม่ได้
    // ดังนั้น delay 3 วิ แล้วค่อยส่ง matchedIndex ไป ReadyScreen
    Future.delayed(const Duration(seconds: 3), () {
  if (mounted) {
    Navigator.pushReplacementNamed(
      context,
      '/ready',
      arguments: {'matchedIndex': matchedIndex}, // ส่ง matchedIndex ไป
    );
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
    final screenHeight = MediaQuery.of(context).size.height;
    final circleSize = screenHeight * 0.18;

    return Scaffold(
      backgroundColor: AppColors.primaryBrown,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Mixing your perfect foundation...",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                SizedBox(height: screenHeight * 0.05),

                // 🔸 วงกลม progress
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: circleSize,
                          height: circleSize,
                          child: CircularProgressIndicator(
                            value: _controller.value,
                            valueColor:
                                const AlwaysStoppedAnimation(Colors.white),
                            backgroundColor: Colors.white24,
                            strokeWidth: 6,
                          ),
                        ),
                        const Icon(Icons.brush_rounded,
                            color: Colors.white, size: 48),
                      ],
                    );
                  },
                ),

                SizedBox(height: screenHeight * 0.06),

                // 🔸 แถบ progress ด้านล่าง
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Column(
                      children: [
                        LinearProgressIndicator(
                          value: _controller.value,
                          minHeight: 8,
                          color: Colors.white,
                          backgroundColor: Colors.white30,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "${(_controller.value * 100).toInt()}%",
                          style: const TextStyle(
                              color: Colors.white, fontSize: 16),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
