import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../services/api_service.dart'; // ✅ เพิ่มการเชื่อม API

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _obscureText = true;
  bool _isLoading = false;

  void _showSnackBar(String message, {bool success = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: success ? AppColors.successGreen : AppColors.errorRed,
      ),
    );
  }

  // ✅ เชื่อม backend login จริง
  void _handleLogin() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      _showSnackBar("Please enter both email and password.");
      return;
    }

    setState(() => _isLoading = true);
    final api = ApiService();

    try {
      final result = await api.login(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      _showSnackBar("Login successful!", success: true);
      print("✅ Token: ${result['token']}");

      // ไปหน้า Home หลัง login สำเร็จ
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      _showSnackBar("Invalid credentials. Try again.");
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/login_bg.jpg',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(color: Colors.grey[200]);
            },
          ),
          Container(color: Colors.white.withOpacity(0.85)),
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 80),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Login",
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  "Welcome Back!",
                  style: TextStyle(fontSize: 16, color: AppColors.textDark),
                ),
                const SizedBox(height: 40),

                // 🔹 Email field
                TextField(
                  controller: emailController,
                  decoration: _inputDecoration("Email Address", "Email"),
                ),
                const SizedBox(height: 16),

                // 🔹 Password field
                TextField(
                  controller: passwordController,
                  obscureText: _obscureText,
                  decoration: _inputDecoration("Password", "Password").copyWith(
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureText
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() => _obscureText = !_obscureText);
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      _showSnackBar("Forgot password feature coming soon!");
                    },
                    child: const Text(
                      "Forgot Password",
                      style: TextStyle(color: AppColors.primaryBrown),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // 🔹 ปุ่ม Login จริง
                ElevatedButton(
                  onPressed: _isLoading ? null : _handleLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBrown,
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 3,
                          ),
                        )
                      : const Text("Login",
                          style:
                              TextStyle(color: Colors.white, fontSize: 16)),
                ),
                const SizedBox(height: 16),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don’t have an account? ",
                        style: TextStyle(color: AppColors.textDark)),
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(context, '/signup'), // ✅ ไปหน้า SignUp
                      child: const Text(
                        "Sign up",
                        style: TextStyle(
                            color: AppColors.primaryBrown,
                            fontWeight: FontWeight.w600),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String label, String hint) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.primaryBrown),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide:
            const BorderSide(color: AppColors.primaryBrown, width: 2.0),
      ),
    );
  }
}
