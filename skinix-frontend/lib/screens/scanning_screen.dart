import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../services/api_service.dart';

class ScanningScreen extends StatefulWidget {
  const ScanningScreen({super.key});

  @override
  State<ScanningScreen> createState() => _ScanningScreenState();
}

class _ScanningScreenState extends State<ScanningScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  double progressValue = 0;
  bool _waitingScan = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20), // ยืดระยะเผื่อ scan ช้าหรือเน็ตช้า
    )..addListener(() {
      setState(() {
        progressValue = _controller.value;
      });
    });

    _controller.forward();

    // เมื่อเข้าสู่หน้า ให้ยิง HTTP ขอ scan sensor ทันที
    _triggerScan();
  }

  Future<void> _triggerScan() async {
    try {
      // Call API scan endpoint (แก้ตาม url/service ของคุณ)
      final api = ApiService();
      final sensorData =
          await api.fetchSensorData(); // <- ตรงนี้ต้องเป็นเรียกจริง ไม่ใช่ mock

      if (!mounted) return;
      _controller.animateTo(
        1.0,
        duration: const Duration(milliseconds: 600),
      ); // ให้ progress วิ่งจบไว

      setState(() {
        _waitingScan = false;
      });

      Navigator.pushReplacementNamed(
        context,
        '/result',
        arguments: sensorData, // ทั้ง object จาก fetchSensorData()
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to get sensor data: $e')));
      Navigator.pop(context);
    }
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
                Text(
                  _waitingScan
                      ? "Analyzing your skin tone..."
                      : "Scan completed!",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 60),
                LinearProgressIndicator(
                  value: progressValue,
                  minHeight: 8,
                  color: Colors.white,
                  backgroundColor: Colors.white24,
                  borderRadius: BorderRadius.circular(12),
                ),
                const SizedBox(height: 15),
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
