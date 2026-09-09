import 'package:flutter/material.dart';
import 'features/auth/login_screen.dart';

void main() {
  runApp(const SuperCrediApp());
}

class SuperCrediApp extends StatelessWidget {
  const SuperCrediApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Super Credi',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0D0F14),
        primaryColor: const Color(0xFF00A3FF),
        cardColor: const Color(0xFF161B22),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF00A3FF),
          secondary: Color(0xFF00E5FF),
          surface: Color(0xFF161B22),
        ),
      ),
      home: const LoginScreen(),
    );
  }
}
