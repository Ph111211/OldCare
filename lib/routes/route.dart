import '../views/add_schedule.dart';
import '../views/history_page.dart';
import '../views/login_page.dart';
import '../views/signup_page.dart';
import '../views/setting_page.dart';
import '../views/parent_page.dart';
import 'package:flutter/material.dart';

// Mặc định đường dẫn / sẽ ở trang login
// nếu muốn đi đến đường đẫn khác thì thêm /#/tên_đường_dẫn
// Vd: http:localhost:4321/#/parent sẽ đến trang bố mẹ
final Map<String, WidgetBuilder> appRoutes = {
  '/': (context) => const LoginScreen(),
  '/signup': (context) => const RegisterScreen(),
  '/parent': (context) => const GiaoDiNChNh(),
  '/add_schedule': (context) => const AddSchedule(),
  '/history': (context) => const HistoryScreen(),
  '/settings': (context) => const AnTamSettingApp(),
};
