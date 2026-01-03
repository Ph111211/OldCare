import 'package:flutter/material.dart';
import '../views/add_schedule.dart';
import '../views/child-dashboard.dart';
import '../views/setting_page.dart';
import '../views/history_page.dart';

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
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    debugPrint('Loading history data...');
  }

  // void _onBottomNavTapped(int index) {
  //   setState(() {
  //     _currentIndex = index;
  //   });

  //   switch (index) {
  //     case 0:
  //       debugPrint('Navigate to Dashboard');
  //       break;
  //     case 1:
  //       debugPrint('Navigate to Add Schedule');
  //       break;
  //     case 2:
  //       debugPrint('Already on History');
  //       break;
  //     case 3:
  //       debugPrint('Navigate to Settings');
  //       break;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          _buildHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: <Widget>[
                  _buildComplianceCard(),
                  const SizedBox(height: 20),
                  _buildHistoryList(),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 60, left: 16, right: 16, bottom: 24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: <Color>[Color(0xFF2563EB), Color(0xFF1D4ED8)],
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
            onPressed: () {
              debugPrint('Notifications tapped');
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              debugPrint('Settings tapped');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildComplianceCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            'Thống kê tuân thủ',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            height: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              gradient: const LinearGradient(
                colors: <Color>[Color(0xFFE6F2FF), Color(0xFFF0FFF0)],
              ),
            ),
            child: const Center(
              child: Text(
                'Biểu đồ tuân thủ theo tuần/tháng',
                style: TextStyle(color: Color(0xFF888888), fontSize: 13),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryList() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            'Lịch sử 7 ngày',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 12),
          ..._days.map((String day) => _buildHistoryItem(day)),
        ],
      ),
    );
  }

  Widget _buildHistoryItem(String dayLabel) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                dayLabel,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                children: <Widget>[
                  _buildStatusChip('Sáng'),
                  const SizedBox(width: 6),
                  _buildStatusChip('Trưa'),
                  const SizedBox(width: 6),
                  _buildStatusChip('Tối'),
                ],
              ),
            ],
          ),
          const Text(
            '100% tuân thủ',
            style: TextStyle(
              color: Color(0xFF1A7F1A),
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: const Color(0xFFD4F5D4),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: const TextStyle(color: Color(0xFF1A7F1A), fontSize: 11),
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: <BoxShadow>[
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 4,
          offset: const Offset(0, 1),
        ),
      ],
    );
  }

  Widget _buildBottomNav() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: const Color(0xFF2563EB),
      unselectedItemColor: Colors.grey,
      currentIndex: _currentIndex,
      onTap: _onBottomNavTapped,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: const Icon(Icons.dashboard),
          label: 'Tổng quan',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.add_circle_outline),
          label: 'Thêm lịch',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.history),
          label: 'Lịch sử',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Cài đặt',
        ),
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

  @override
  void dispose() {
    super.dispose();
  }
}
