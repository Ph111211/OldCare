import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart'; // Thêm dòng này để xử lý Locale

// Import cấu hình Firebase
import 'firebase_options.dart';

// Import các Services
import 'package:oldcare/services/notification/notification_service.dart';
import 'package:oldcare/services/schedulePhill/schedule_Pill.service.dart';

// Import các ViewModels
import 'package:oldcare/viewmodels/Schedule/schedule.viewmodel.dart';
import 'package:oldcare/viewmodels/schedulePill/schedulePill.viewmodel.dart';

// Import Gate và các Trang cần thiết
import 'auth_gate.dart';
import 'views/seeall.dart'; // Import trang xem tất cả

void main() async {
  // 1. Đảm bảo Flutter binding được khởi tạo
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Khởi tạo Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // 3. Khởi tạo định dạng ngày tháng tiếng Việt để fix lỗi LocaleDataException
  await initializeDateFormatting('vi', null);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<NotificationService>(create: (_) => NotificationService()),
        ChangeNotifierProvider(create: (_) => ScheduleViewModel()),
        ChangeNotifierProvider(
          create: (_) => SchedulePillViewModel(SchedulePillService()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'An Tâm Care',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2563EB)),
          fontFamily: 'Roboto',
        ),

        // Cấu hình Route để sử dụng Navigator.pushNamed
        routes: {
          '/see_all_medication': (context) => const SeeAllMedicationPage(),
        },

        home: const AuthGate(),
      ),
    );
  }
}
