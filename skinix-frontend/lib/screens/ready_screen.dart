import 'package:flutter/material.dart';
import '../widgets/bottom_nav.dart';
import '../theme/app_colors.dart';
import '../utils/monk_skin_tones.dart';
import '../models/color_history.dart';

class ReadyScreen extends StatefulWidget {
  const ReadyScreen({super.key});

  @override
  State<ReadyScreen> createState() => _ReadyScreenState();
}

class _ReadyScreenState extends State<ReadyScreen> {
  Map<String, dynamic>? mix;
  bool loading = true;
  int matchedIndex = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final args = ModalRoute.of(context)?.settings.arguments;

    if (args != null &&
        args is Map<String, dynamic> &&
        args.containsKey('matchedIndex') &&
        args['matchedIndex'] != null) {

      matchedIndex = args['matchedIndex'];

      if (matchedIndex < 0 || matchedIndex >= monkSkinTones.length) {
        matchedIndex = 0;
      }

      final tone = monkSkinTones[matchedIndex];

      setState(() {
        mix = {
          'shade_code': "Tone-${matchedIndex + 1}",
          'shade': "Monk Shade",
          'undertone': "Neutral",
          'color': tone['color'],
          'hex': tone['hex'],
          'L': tone['L'],
          'a': tone['a'],
          'b': tone['b'],
        };
        loading = false;
      });
    } else {
      _loadMockMix();
    }
  }

  Future<void> _loadMockMix() async {
    await Future.delayed(const Duration(seconds: 1));
    final tone = monkSkinTones[0];

    setState(() {
      mix = {
        'shade_code': "Tone-1",
        'shade': "Monk Shade",
        'undertone': "Neutral",
        'color': tone['color'],
        'hex': tone['hex'],
        'L': tone['L'],
        'a': tone['a'],
        'b': tone['b'],
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
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24, vertical: 28),
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
                          color: mix!['color'],
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

  /// 💾 Popup บันทึกข้อมูล
  void _showSaveDialog(BuildContext context) {
    final TextEditingController nameCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.cream,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)),
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

                // ⭐ Save เข้า repo
                if (mix != null) {
                  ColorHistoryRepo.addHistory({
                    "name": nameCtrl.text.isEmpty ? "Guest" : nameCtrl.text,
                    "tone": mix!['shade'],
                    "hex": mix!['hex'],
                    "lab": "(${mix!['L']}, ${mix!['a']}, ${mix!['b']})",
                    "date": DateTime.now().toIso8601String().substring(0,10),
                    "color": mix!['color'],
                  });
                }

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("💾 Saved successfully for ${nameCtrl.text.isEmpty ? "Guest" : nameCtrl.text}!"),
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
              child: const Text("Save", style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
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
