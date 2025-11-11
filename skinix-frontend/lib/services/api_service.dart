import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // If using emulator, update the host accordingly!
  //static const String baseUrl = "http://localhost:5000";
  static const String baseUrl = "http://localhost:55652";

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

  // New: Function for fetching mock AS7341 sensor data
  Future<Map<String, dynamic>> fetchMockSensorData() async {
    final url = Uri.parse("$baseUrl/api/sensor/mock-as7341");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to fetch sensor data");
    }
  }
}
