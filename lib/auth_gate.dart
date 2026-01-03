import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:oldcare/views/child-dashboard.dart';
import 'package:oldcare/views/parent_page.dart';
import 'views/login_page.dart';
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
        if (snapshot.data?.email?.endsWith("@oldcare.com") ?? false) {
          // Thực hiện hành động nếu email có đuôi @oldcare.com
          return MaterialApp(home: GiaoDiNChNh(), routes: appRoutes);
        }
        // ✅ ĐÃ LOGIN
        return MaterialApp(home: ChildDashboard(), routes: appRoutes);
      },
    );
  }
}
