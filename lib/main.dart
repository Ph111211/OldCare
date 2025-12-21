import 'package:flutter/material.dart';
import 'package:oldcare/views/seeall.dart';
import 'views/child-dashboard.dart';
import 'views/login_page.dart';
import 'views/signup_page.dart';
void main() {
  runApp(const FigmaToCodeApp());
}

class FigmaToCodeApp extends StatelessWidget {
  const FigmaToCodeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF9FAFB),
        fontFamily: 'Inter',
        useMaterial3: true,
      ),
      home: const ChildDashboard(),
    );
  }
}

