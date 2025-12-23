// import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'views/add_schedule.dart';
import 'views/history_page.dart';

import 'views/login_page.dart';
import 'views/signup_page.dart';
import 'views/setting_page.dart';
import 'views/parent_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'An Tâm Login UI',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      routes: {
        '/': (context) => const LoginScreen(),
        '/signup': (context) => const RegisterScreen(),
        '/parent': (context) => GiaoDiNChNh(),
      },
    );
  }
}
// màn chính ko sửa ở đây.