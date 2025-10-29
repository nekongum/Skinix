import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../services/api_service.dart'; // เชื่อม API

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool _isLoading = false;
  bool _obscure1 = true;
  bool _obscure2 = true;

  // ฟังก์ชันตรวจสอบการสมัคร
  void _handleRegister() async {
    if (passwordController.text != confirmPasswordController.text) {
      _showSnackBar("Password and Confirm Password do not match.");
      return;
    }

    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      _showSnackBar("Please fill in all fields.");
      return;
    }

    setState(() => _isLoading = true);

    final api = ApiService();

    try {
      final result = await api.register( // ✅ เรียกใช้ API register
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      _showSnackBar("Registration successful! Please log in.", success: true);

      // ไปหน้า Login หลังการสมัครสำเร็จ
      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      _showSnackBar("Registration failed. Please try again.");
    }

    setState(() => _isLoading = false);
  }

  void _showSnackBar(String message, {bool success = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: success ? AppColors.successGreen : AppColors.errorRed,
      ),
    );
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
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Sign up",
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 40),
                _buildTextField("Email Address", emailController),
                const SizedBox(height: 16),
                _buildTextField("Password", passwordController,
                    obscure: _obscure1, toggle: () {
                  setState(() => _obscure1 = !_obscure1);
                }),
                const SizedBox(height: 16),
                _buildTextField("Confirm Password", confirmPasswordController,
                    obscure: _obscure2, toggle: () {
                  setState(() => _obscure2 = !_obscure2);
                }),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _isLoading ? null : _handleRegister,
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
                      : const Text(
                          "Sign up",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account? ",
                        style: TextStyle(color: AppColors.textDark)),
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(context, '/login'),
                      child: const Text(
                        "Login now",
                        style: TextStyle(
                            color: AppColors.primaryBrown,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {bool obscure = false, VoidCallback? toggle}) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        suffixIcon: toggle != null
            ? IconButton(
                icon: Icon(
                  obscure
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: Colors.grey,
                ),
                onPressed: toggle,
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.primaryBrown),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide:
              const BorderSide(color: AppColors.primaryBrown, width: 2.0),
        ),
      ),
    );
  }
}
