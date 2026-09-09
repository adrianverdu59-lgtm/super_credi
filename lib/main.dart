import 'package:flutter/material.dart';
import 'features/payments/pago_movil_screen.dart';
import 'features/admin/admin_approvals_screen.dart';

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
      home: const MainNavigationScreen(),
    );
  }
}

class MainNavigationScreen extends StatelessWidget {
  const MainNavigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Super Credi - Inicio'),
        backgroundColor: const Color(0xFF161B22),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              icon: const Icon(Icons.payment),
              label: const Text('PROBAR PAGO MÓVIL (USUARIO)'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PagoMovilScreen(
                      installmentAmountUsd: 25.0,
                      bcvRate: 36.50,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: Colors.amber.shade800,
              ),
              icon: const Icon(Icons.admin_panel_settings),
              label: const Text('PANEL ADMIN (APROBACIONES)'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AdminApprovalsScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
