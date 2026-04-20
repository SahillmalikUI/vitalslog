import 'package:flutter/material.dart';
import 'splash_screen.dart';

void main() {
  runApp(const VitalsLog());
}

class VitalsLog extends StatelessWidget {
  const VitalsLog({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VitalsLog',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF1A1A2E),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6C63FF),
          brightness: Brightness.dark,
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
