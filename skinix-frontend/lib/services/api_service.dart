import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // ถ้าใช้ emulator ให้เปลี่ยน host ให้ถูก (เช่น 10.0.2.2 สำหรับ Android)
  static const String baseUrl = "http://localhost:55652";
  // ตัวอย่าง: static const String baseUrl = "http://192.168.1.100:3000";

  // ========== AUTH ==========

  // Login
  Future<Map<String, dynamic>> login(String email, String password) async {
    final url = Uri.parse("$baseUrl/api/auth/login");

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Invalid credentials");
    }
  }

  // Register
  Future<Map<String, dynamic>> register(String email, String password) async {
    final url = Uri.parse("$baseUrl/api/auth/register");

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Registration failed");
    }
  }

  // ========== SENSOR DATA ==========

  /// เรียก mock data (สำหรับเทสต์/ดูตัวอย่างเท่านั้น)
  Future<Map<String, dynamic>> fetchMockSensorData() async {
    final url = Uri.parse("$baseUrl/api/sensor/mock-as7341");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to fetch sensor data");
    }
  }

  /// เรียก sensor จริงผ่าน HTTP POST (ควรเอาไปใช้ใน ScanningScreen)
  Future<Map<String, dynamic>> fetchSensorData() async {
    final url = Uri.parse("$baseUrl/api/sensor/scan");
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      // ถ้าต้องการ payload เพิ่มเติม สามารถเพิ่ม body: jsonEncode({...}) ได้
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to fetch sensor scan data");
    }
  }
}
