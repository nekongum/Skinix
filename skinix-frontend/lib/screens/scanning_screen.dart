import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../services/api_service.dart';

class ScanningScreen extends StatefulWidget {
  const ScanningScreen({super.key});

  @override
  State<ScanningScreen> createState() => _ScanningScreenState();
}

class _ScanningScreenState extends State<ScanningScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  double progressValue = 0;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..addListener(() {
        setState(() {
          progressValue = _controller.value;
        });
      });

    _controller.forward();

    _controller.addStatusListener((status) async {
      if (status == AnimationStatus.completed && mounted) {
        // Fetch AS7341 mock sensor data from API
        try {
          final api = ApiService();
          final sensorData = await api.fetchMockSensorData();
          if (mounted) {
            Navigator.pushReplacementNamed(
              context, 
              '/result',
              arguments: sensorData, // Pass the sensor data to result screen
            );
          }
        } catch (e) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Failed to get sensor data!'))
            );
            Navigator.pop(context);
          }
        }
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
