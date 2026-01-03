import 'package:flutter/material.dart';
import '../views/add_schedule.dart';
import '../views/child-dashboard.dart';
import '../views/setting_page.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final int _currentIndex = 2;

  final List<String> _days = [
    'Thứ 2, 12/11',
    'Thứ 3, 13/11',
    'Thứ 4, 14/11',
    'Thứ 5, 15/11',
    'Thứ 6, 16/11',
    'Thứ 7, 17/11',
    'Chủ Nhật, 18/11',
  ];

  @override
  Widget build(BuildContext context) {
    // Kiểm tra chế độ Dark Mode hiện tại
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      // Sử dụng màu nền từ Theme để đồng bộ với Setting Page
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: <Widget>[
          _buildHeader(isDark),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: <Widget>[
                  _buildComplianceCard(isDark),
                  const SizedBox(height: 20),
                  _buildHistoryList(isDark),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildHeader(bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 60, left: 16, right: 16, bottom: 24),
      decoration: BoxDecoration(
        // Giữ màu gradient đặc trưng hoặc làm tối đi trong Dark Mode
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: isDark
              ? <Color>[
                  const Color(0xFF1E3A8A),
                  const Color(0xFF111827),
                ] // Dark Blue/Gray
              : <Color>[
                  const Color(0xFF2563EB),
                  const Color(0xFF1D4ED8),
                ], // Primary Blue
        ),
      ),
      child: Row(
        children: <Widget>[
          CircleAvatar(
            radius: 24,
            backgroundColor: Colors.white.withOpacity(0.2),
            child: const Icon(Icons.person, color: Colors.white),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'An Tâm - Con',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Chăm sóc Cha Mẹ',
                  style: TextStyle(color: Color(0xFFDBEAFE), fontSize: 13),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildComplianceCard(bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Thống kê tuân thủ',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : const Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            height: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              // Màu nền biểu đồ nhẹ nhàng hơn trong Dark Mode
              gradient: LinearGradient(
                colors: isDark
                    ? <Color>[const Color(0xFF374151), const Color(0xFF1F2937)]
                    : <Color>[const Color(0xFFE6F2FF), const Color(0xFFF0FFF0)],
              ),
            ),
            child: Center(
              child: Text(
                'Biểu đồ tuân thủ theo tuần/tháng',
                style: TextStyle(
                  color: isDark ? Colors.grey[400] : const Color(0xFF888888),
                  fontSize: 13,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryList(bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Lịch sử 7 ngày',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : const Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 12),
          ..._days.map((String day) => _buildHistoryItem(day, isDark)),
        ],
      ),
    );
  }

  Widget _buildHistoryItem(String dayLabel, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: isDark ? Colors.grey[800]! : const Color(0xFFEEEEEE),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                dayLabel,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                  color: isDark ? Colors.grey[300] : Colors.black,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                children: <Widget>[
                  _buildStatusChip('Sáng', isDark),
                  const SizedBox(width: 6),
                  _buildStatusChip('Trưa', isDark),
                  const SizedBox(width: 6),
                  _buildStatusChip('Tối', isDark),
                ],
              ),
            ],
          ),
          const Text(
            '100% tuân thủ',
            style: TextStyle(
              color: Color(0xFF4ADE80), // Xanh lá sáng hơn cho Dark Mode
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String label, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF064E3B) : const Color(0xFFD4F5D4),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isDark ? const Color(0xFF34D399) : const Color(0xFF1A7F1A),
          fontSize: 11,
        ),
      ),
    );
  }

  BoxDecoration _cardDecoration(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return BoxDecoration(
      color: Theme.of(context).cardColor,
      borderRadius: BorderRadius.circular(12),
      boxShadow: <BoxShadow>[
        BoxShadow(
          color: isDark
              ? Colors.black.withOpacity(0.3)
              : Colors.black.withOpacity(0.05),
          blurRadius: 4,
          offset: const Offset(0, 1),
        ),
      ],
    );
  }

  Widget _buildBottomNav() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Theme.of(context).cardColor, // Đồng bộ màu nền nav
      selectedItemColor: const Color(0xFF2563EB),
      unselectedItemColor: Colors.grey,
      currentIndex: _currentIndex,
      onTap: _onBottomNavTapped,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard),
          label: 'Tổng quan',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add_circle_outline),
          label: 'Thêm lịch',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Lịch sử'),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Cài đặt'),
      ],
    );
  }

  void _onBottomNavTapped(int index) {
    if (index == _currentIndex) return;
    Widget nextScreen;
    switch (index) {
      case 0:
        nextScreen = const ChildDashboard();
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
}
