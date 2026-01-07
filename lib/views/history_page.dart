import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:oldcare/services/notification/notification_service.dart';
import '../views/add_schedule.dart';
import '../views/child-dashboard.dart';
import '../views/setting_page.dart';

class HistoryScreen extends StatefulWidget {
  final bool isDarkMode;
  const HistoryScreen({super.key, this.isDarkMode = false});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final int _currentIndex = 2;

  // Lấy childId của user hiện tại để lọc dữ liệu thuốc của bố mẹ
  Future<String?> _getChildId() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;
    // final doc = await FirebaseFirestore.instance
    //     .collection('users')
    //     .doc(user.uid)
    //     .get();
    // print(user.uid);
    return user.uid; // Đảm bảo field này khớp với DB của bạn
  }

  @override
  void initState() {
    super.initState();
    // Bắt đầu lắng nghe SOS và Call ngay khi vào màn hình
    WidgetsBinding.instance.addPostFrameCallback((_) {
      NotificationService().listenToSOSAlerts(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = widget.isDarkMode;

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF111827)
          : const Color(0xFFF9FAFB),
      body: FutureBuilder<String?>(
        future: _getChildId(),
        builder: (context, idSnapshot) {
          if (idSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final childId = idSnapshot.data ?? "";
          print(childId);

          return StreamBuilder<QuerySnapshot>(
            // Lấy lịch sử thuốc dựa trên childId
            stream: FirebaseFirestore.instance
                .collection('schedule_pills')
                .where('childId', isEqualTo: childId)
                .orderBy(
                  'updatedAt',
                  descending: true,
                ) // Sắp xếp mới nhất lên đầu
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError)
                return Center(child: Text("Lỗi: ${snapshot.error}"));
              if (!snapshot.hasData)
                return const Center(child: CircularProgressIndicator());

              final docs = snapshot.data!.docs;
              print(docs);

              // Tính toán hiệu suất tuân thủ
              int completed = docs
                  .where((d) => d['status'] == 'Completed')
                  .length;
              int total = docs.length;
              double complianceRate = total > 0 ? (completed / total) * 100 : 0;

              return Column(
                children: <Widget>[
                  _buildHeader(isDark),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: <Widget>[
                          _buildComplianceCard(
                            isDark,
                            complianceRate,
                            total,
                            completed,
                          ),
                          const SizedBox(height: 20),
                          _buildHistoryList(isDark, docs),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildHeader(bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 60, left: 16, right: 16, bottom: 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: isDark
              ? [const Color(0xFF1E3A8A), const Color(0xFF111827)]
              : [const Color(0xFF2563EB), const Color(0xFF1D4ED8)],
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
                  'Lịch sử chăm sóc',
                  style: TextStyle(color: Color(0xFFDBEAFE), fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComplianceCard(
    bool isDark,
    double rate,
    int total,
    int completed,
  ) {
    Color progressColor = rate >= 80
        ? Colors.green
        : (rate >= 50 ? Colors.orange : Colors.red);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Hiệu suất tuân thủ',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              Text(
                '${rate.toStringAsFixed(0)}%',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: progressColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: total > 0 ? rate / 100 : 0,
            backgroundColor: isDark ? Colors.grey[800] : Colors.grey[200],
            color: progressColor,
            minHeight: 10,
            borderRadius: BorderRadius.circular(5),
          ),
          const SizedBox(height: 12),
          Text(
            'Đã hoàn thành: $completed / Tổng số: $total liều',
            style: TextStyle(
              color: isDark ? Colors.grey[400] : Colors.grey[600],
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryList(bool isDark, List<QueryDocumentSnapshot> docs) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Chi tiết uống thuốc',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          if (docs.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Center(child: Text("Chưa có dữ liệu lịch sử")),
            ),
          ...docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return _buildHistoryItem(
              data['medicineName'] ?? "Không tên",
              data['time'] ?? "--:--",
              data['status'] ?? "Pending",
              isDark,
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildHistoryItem(
    String name,
    String time,
    String status,
    bool isDark,
  ) {
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
                name,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Giờ: $time",
                style: TextStyle(
                  fontSize: 13,
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
            ],
          ),
          _buildStatusBadge(status),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    String text;
    switch (status) {
      case 'Completed':
        color = Colors.green;
        text = "Đã uống";
        break;
      case 'Missed':
        color = Colors.red;
        text = "Bỏ lỡ";
        break;
      default:
        color = Colors.orange;
        text = "Chờ uống";
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  BoxDecoration _cardDecoration(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return BoxDecoration(
      color: isDark ? const Color(0xFF1F2937) : Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: isDark ? Colors.black26 : Colors.black.withOpacity(0.05),
          blurRadius: 4,
          offset: const Offset(0, 1),
        ),
      ],
    );
  }

  Widget _buildBottomNav() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: widget.isDarkMode
          ? const Color(0xFF1F2937)
          : Colors.white,
      selectedItemColor: const Color(0xFF2563EB),
      unselectedItemColor: Colors.grey,
      currentIndex: _currentIndex,
      onTap: _onBottomNavTapped,
      items: const [
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
        nextScreen = ChildDashboard(isDarkMode: widget.isDarkMode);
        break;
      case 1:
        nextScreen = AddSchedule();
        break;
      case 2:
        nextScreen = HistoryScreen(isDarkMode: widget.isDarkMode);
        break;
      case 3:
        nextScreen = AnTamSettingApp(isDarkModeI: widget.isDarkMode);
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
