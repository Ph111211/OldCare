import 'package:flutter/material.dart';
import 'package:oldcare/services/auth/auth_service.dart';
import 'package:provider/provider.dart';
import '../viewmodels/auth.viewmodel.dart';
import '../views/add_schedule.dart';
import '../views/child-dashboard.dart';
import '../views/setting_page.dart';
import '../views/history_page.dart';

// --- 1. ROOT WIDGET ---
class AnTamSettingApp extends StatefulWidget {
  const AnTamSettingApp({super.key});

  @override
  State<AnTamSettingApp> createState() => _AnTamSettingAppState();
}

class _AnTamSettingAppState extends State<AnTamSettingApp> {
  bool _isDarkMode = false;

  void _toggleTheme(bool isOn) {
    setState(() {
      _isDarkMode = isOn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'An Tâm Settings',
      // Cấu hình Theme Mode
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF9FAFB),
        primarySwatch: Colors.blue,
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF111827),
        primarySwatch: Colors.blue,
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: SettingScreen(
        isDarkMode: _isDarkMode,
        onThemeChanged: _toggleTheme,
      ),
    );
  }
}

// --- 2. MÀN HÌNH SETTING CHÍNH ---
class SettingScreen extends StatefulWidget {
  final bool isDarkMode;
  final Function(bool) onThemeChanged;

  const SettingScreen({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final int _currentIndex = 3; // Index hiện tại là tab 'Cài đặt'

  // Logic chuyển màn hình
  void _onBottomNavTapped(int index) {
    if (index == _currentIndex) return;

    Widget nextScreen;
    switch (index) {
      case 0:
        nextScreen =
            const ChildDashboard(); // Đảm bảo đã định nghĩa các class này
        break;
      case 1:
        nextScreen = const AddSchedule();
        break;
      case 2:
        nextScreen = const HistoryScreen();
        break;
      case 3:
        nextScreen = const AnTamSettingApp();
        break;
      default:
        return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => nextScreen),
    );
  }

  // Thay thế bằng BottomNavigationBar chuẩn
  Widget _buildBottomNav() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: widget.isDarkMode
          ? const Color(0xFF1F2937)
          : Colors.white,
      selectedItemColor: const Color(0xFF2563EB),
      unselectedItemColor: widget.isDarkMode ? Colors.grey[400] : Colors.grey,
      currentIndex: _currentIndex,
      onTap: _onBottomNavTapped,
      selectedFontSize: 11.5,
      unselectedFontSize: 11.5,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard_outlined),
          activeIcon: Icon(Icons.dashboard),
          label: 'Tổng quan',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_month_outlined),
          activeIcon: Icon(Icons.calendar_month),
          label: 'Thêm lịch',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Lịch sử'),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings_outlined),
          activeIcon: Icon(Icons.settings),
          label: 'Cài đặt',
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: CITContent(
            isDarkMode: widget.isDarkMode,
            onThemeChanged: widget.onThemeChanged,
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }
}

// --- 3. NỘI DUNG CHI TIẾT ---
class CITContent extends StatefulWidget {
  final Function(bool) onThemeChanged;
  final bool isDarkMode;

  const CITContent({
    super.key,
    required this.onThemeChanged,
    required this.isDarkMode,
  });

  @override
  State<CITContent> createState() => _CITContentState();
}

class _CITContentState extends State<CITContent> {
  final String _userName = "Nguyễn Văn A";
  final String _userEmail = "nguyenvana@email.com";
  final String _userPhone = "09xx xxx xxx";
  final String _userAddress = "";

  bool _isMedicineReminderOn = true;
  bool _isEmergencyOn = true;
  final bool _isDailyReportOn = false;
  // final AuthService _authService = AuthService();
  final AuthViewModel _authViewModel = AuthViewModel(AuthService());

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(),
        const SizedBox(height: 16),
        _buildAccountBlock(),
        const SizedBox(height: 16),
        _buildNotificationBlock(),
        const SizedBox(height: 16),
        _buildInterfaceBlock(),
        const SizedBox(height: 16),
        _buildSupportBlock(),
        const SizedBox(height: 16),
        _buildLogoutBlock(),
        const SizedBox(height: 32),
      ],
    );
  }

  // Các Widget con (Header, Card, Switch...)
  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      decoration: BoxDecoration(
        gradient: widget.isDarkMode
            ? const LinearGradient(
                colors: [Color(0xFF1F2937), Color(0xFF111827)],
              )
            : const LinearGradient(
                colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)],
              ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const CircleAvatar(
                backgroundColor: Colors.white24,
                child: Icon(Icons.favorite, color: Colors.white),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'An Tâm - Con',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Chăm sóc Cha Mẹ',
                    style: TextStyle(
                      color: widget.isDarkMode ? Colors.white70 : Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Icon(Icons.notifications_none, color: Colors.white),
        ],
      ),
    );
  }

  // Header cho các khối Card
  Widget _buildCardHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: widget.isDarkMode ? Colors.grey : Colors.blueGrey,
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: widget.isDarkMode ? Colors.white : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  // Khối Tài khoản
  Widget _buildAccountBlock() {
    return _buildCardContainer(
      child: Column(
        children: [
          _buildCardHeader('Tài khoản', Icons.person_outline),
          ListTile(
            leading: const CircleAvatar(
              backgroundColor: Colors.blue,
              child: Text('A', style: TextStyle(color: Colors.white)),
            ),
            title: Text(
              _userName,
              style: TextStyle(
                color: widget.isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            subtitle: Text(_userEmail),
            trailing: TextButton(
              onPressed: () {},
              child: const Text('Chỉnh sửa'),
            ),
          ),
        ],
      ),
    );
  }

  // Khối Giao diện (Dark Mode)
  Widget _buildInterfaceBlock() {
    return _buildCardContainer(
      child: Column(
        children: [
          _buildCardHeader('Giao diện', Icons.desktop_windows_outlined),
          SwitchListTile(
            title: const Text('Chế độ tối'),
            value: widget.isDarkMode,
            onChanged: (val) => widget.onThemeChanged(val),
          ),
        ],
      ),
    );
  }

  // Khối Thông báo
  Widget _buildNotificationBlock() {
    return _buildCardContainer(
      child: Column(
        children: [
          _buildCardHeader('Thông báo', Icons.notifications_outlined),
          SwitchListTile(
            title: const Text('Nhắc uống thuốc'),
            value: _isMedicineReminderOn,
            onChanged: (val) => setState(() => _isMedicineReminderOn = val),
          ),
          SwitchListTile(
            title: const Text('Khẩn cấp'),
            value: _isEmergencyOn,
            onChanged: (val) => setState(() => _isEmergencyOn = val),
          ),
        ],
      ),
    );
  }

  // Khối Hỗ trợ
  Widget _buildSupportBlock() {
    return _buildCardContainer(
      child: Column(
        children: [
          _buildCardHeader('Hỗ trợ', Icons.help_outline),
          const ListTile(
            leading: Icon(Icons.call),
            title: Text('Hotline: 1900 xxxx'),
          ),
          const ListTile(
            leading: Icon(Icons.email),
            title: Text('support@antam.vn'),
          ),
        ],
      ),
    );
  }

  // Khối Đăng xuất
  Widget _buildLogoutBlock() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red[50],
          foregroundColor: Colors.red,
          minimumSize: const Size(double.infinity, 50),
        ),
        onPressed: () {
          // Provider.of<AuthViewModel>(context, listen: false).logout();
          _authViewModel.logout();
        },
        icon: const Icon(Icons.logout),
        label: const Text(
          'Đăng xuất',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildCardContainer({required Widget child}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: widget.isDarkMode ? const Color(0xFF1F2937) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: widget.isDarkMode ? Colors.white10 : Colors.black12,
        ),
      ),
      child: child,
    );
  }
}
