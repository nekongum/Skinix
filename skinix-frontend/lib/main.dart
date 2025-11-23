import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/home_screen.dart';
import 'screens/scanning_screen.dart';
import 'screens/result_screen.dart';
import 'screens/ready_screen.dart';
import 'screens/mixing_screen.dart';
import 'screens/history_screen.dart';
import 'screens/profile_screen.dart'; 
void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Skinix Auth Demo',
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/home': (context) => const HomeScreen(),
        '/scanning': (context) => const ScanningScreen(),
        '/result': (context) => const ResultScreen(),
        '/mixing': (context) => const MixingScreen(),
        '/ready': (context) => const ReadyScreen(),
        '/history': (context) => const HistoryScreen(),  
        '/profile': (context) => const ProfileScreen(),
      },
    );
  }
}
