import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/bottom_nav.dart';
import '../models/color_history.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final TextEditingController _searchCtrl = TextEditingController();

  List<Map<String, dynamic>> _filteredHistory = [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  void _loadHistory() {
    setState(() {
      _filteredHistory = ColorHistoryRepo.getHistory();
    });
  }

  void _filterSearch(String query) {
    final allHistory = ColorHistoryRepo.getHistory();
    setState(() {
      _filteredHistory = allHistory.where((item) {
        final lowerQuery = query.toLowerCase();
        return item["name"].toLowerCase().contains(lowerQuery) ||
               item["tone"].toLowerCase().contains(lowerQuery) ||
               item["date"].toLowerCase().contains(lowerQuery);
      }).toList();
    });
  }

  Future<void> _filterByDate() async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2026),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryBrown,
              onPrimary: Colors.white,
              surface: AppColors.cream,
              onSurface: AppColors.textDark,
            ),
          ),
          child: child!,
        );
      },
    );

    if (selectedDate != null) {
      final formatted = "${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}";
      final allHistory = ColorHistoryRepo.getHistory();
      setState(() {
        _filteredHistory = allHistory
            .where((item) => item["date"].contains(formatted))
            .toList();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("📅 Showing results for $formatted"),
          backgroundColor: AppColors.primaryBrown,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      bottomNavigationBar: const BottomNavBar(currentIndex: 0),
      body: SafeArea(
        child: Column(
          children: [
            // 🔶 Header
            Container(
              width: double.infinity,
              color: AppColors.primaryBrown,
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: const Center(
                child: Text(
                  "Color History",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            // 🔍 Search Bar + Calendar
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                            color: AppColors.primaryBrown, width: 1),
                      ),
                      child: Row(
                        children: [
                          const SizedBox(width: 8),
                          const Icon(Icons.search,
                              color: AppColors.primaryBrown),
                          const SizedBox(width: 6),
                          Expanded(
                            child: TextField(
                              controller: _searchCtrl,
                              onChanged: _filterSearch,
                              decoration: const InputDecoration(
                                hintText: "Search by name, tone, or date",
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.primaryBrown,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.calendar_today,
                          color: Colors.white),
                      onPressed: _filterByDate,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // 🔹 History List
            Expanded(
              child: _filteredHistory.isEmpty
                  ? const Center(
                      child: Text(
                        "No history found",
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      itemCount: _filteredHistory.length,
                      itemBuilder: (context, index) {
                        final item = _filteredHistory[index];
                        return ColorHistoryCard(
                          name: item["name"],
                          tone: item["tone"],
                          hex: item["hex"],
                          lab: item["lab"],
                          date: item["date"],
                          colorSample: item["color"],
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// 🔸 Card Widget
class ColorHistoryCard extends StatelessWidget {
  final String name;
  final String tone;
  final String hex;
  final String lab;
  final String date;
  final Color colorSample;

  const ColorHistoryCard({
    super.key,
    required this.name,
    required this.tone,
    required this.hex,
    required this.lab,
    required this.date,
    required this.colorSample,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🎨 ตัวอย่างสี
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: colorSample,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
          ),
          const SizedBox(width: 12),

          // 🧾 ข้อมูลเฉดสี
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark)),
                Text(tone,
                    style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        color: AppColors.textDark)),
                const SizedBox(height: 4),
                Text("HEX: $hex",
                    style: const TextStyle(color: AppColors.textDark)),
                Text("LAB: $lab",
                    style: const TextStyle(color: AppColors.textDark)),
                const SizedBox(height: 4),
                Text(date,
                    style: const TextStyle(fontSize: 11, color: Colors.grey)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
