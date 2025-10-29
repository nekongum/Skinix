import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // ⚠️ ข้อควรระวัง: ถ้าคุณรันบน Android Emulator ให้ลองเปลี่ยนเป็น "http://10.0.2.2:5000"
  // ถ้าคุณรันบน iOS Simulator หรือ Desktop ให้ใช้ "http://localhost:5000"
  static const String baseUrl = "http://localhost:5000";

  // Function for Login
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

  // Function for Register
  Future<Map<String, dynamic>> register(
      String email, String password) async {
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
}
