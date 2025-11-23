class ColorHistoryRepo {
  static final List<Map<String, dynamic>> items = [];

  static void addHistory(Map<String, dynamic> data) {
    items.add(data);
  }

  static List<Map<String, dynamic>> getHistory() {
    return List.from(items.reversed); // ให้ล่าสุดอยู่บน
  }
}
