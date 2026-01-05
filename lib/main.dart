import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'services/notification/notification_service.dart';
// Import cấu hình Firebase
import 'firebase_options.dart';

// Import các Services
import 'package:oldcare/services/schedulePhill/schedule_Pill.service.dart';

// Import các ViewModels
import 'package:oldcare/viewmodels/Schedule/schedule.viewmodel.dart';
import 'package:oldcare/viewmodels/schedulePill/schedulePill.viewmodel.dart';

// Import Gate kiểm tra đăng nhập
import 'auth_gate.dart';

void main() async {
  // Đảm bảo Flutter binding được khởi tạo trước khi gọi Firebase
  WidgetsFlutterBinding.ensureInitialized();

  // Khởi tạo Firebase với cấu hình theo nền tảng
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Sử dụng MultiProvider để quản lý tất cả ViewModel ở cấp cao nhất
    return MultiProvider(
      providers: [
        Provider<NotificationService>(create: (_) => NotificationService()),
        // Khởi tạo ScheduleViewModel (Quản lý lịch hẹn bác sĩ)
        ChangeNotifierProvider(create: (_) => ScheduleViewModel()),

        // Khởi tạo SchedulePillViewModel (Quản lý lịch uống thuốc)
        // Cần truyền Service vào constructor để ViewModel hoạt động
        ChangeNotifierProvider(
          create: (_) => SchedulePillViewModel(SchedulePillService()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'An Tâm Care',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF2563EB), // Màu xanh thương hiệu
          ),
          fontFamily: 'Roboto',
        ),
        // AuthGate sẽ điều hướng người dùng dựa trên trạng thái đăng nhập
        home: const AuthGate(),
      ),
    );
  }
}
