import 'package:flutter/material.dart';
import 'views/login_page.dart';
import 'views/signup_page.dart';
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
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto', 
        useMaterial3: true,
      ),
    routes: {
      '/': (context) => const LoginScreen(),
      '/signup': (context) => const RegisterScreen(),
    },
    );
  }
}
