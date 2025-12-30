import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'views/login_page.dart';
import 'views/add_schedule.dart';
import 'views/child-dashboard.dart';
import 'views/history_page.dart';
import 'routes/route.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Đang kiểm tra auth
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // ❌ CHƯA LOGIN
        if (!snapshot.hasData) {
          return LoginScreen();
        }
        // ✅ ĐÃ LOGIN
        return MaterialApp(
          home: HistoryScreen(),
          routes: appRoutes,
        );
      },
    );
  }
}
