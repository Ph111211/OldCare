import 'package:flutter/material.dart';

class ChildDashboard extends StatelessWidget {
  const ChildDashboard({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: Stack(
        children: [
          // Phần nội dung có thể cuộn
          SingleChildScrollView(
            child: Column(
              children: [
                _buildHeader(),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      _buildAlertCard(),
                      const SizedBox(height: 24),
                      _buildStatGrid(),
                      const SizedBox(height: 24),
                      _buildMedicationSchedule(),
                      const SizedBox(height: 24),
                      _buildAppointmentSchedule(),
                      const SizedBox(height: 120), // Khoảng trống để không bị Bottom Nav che
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Bottom Navigation cố định
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildBottomNav(),
          ),
        ],
      ),
    );
  }

  // 1. Header Blue Section
  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 60, left: 16, right: 16, bottom: 24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: Colors.white.withOpacity(0.2),
                child: const Icon(Icons.person, color: Colors.white),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('An Tâm - Con',
                      style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                  Text('Chăm sóc Cha Mẹ',
                      style: TextStyle(color: Colors.blue.shade100, fontSize: 13)),
                ],
              ),
            ],
          ),
          const Icon(Icons.notifications_none, color: Colors.white),
        ],
      ),
    );
  }

  // 2. Alert Card (Cảnh báo chưa uống thuốc)
  Widget _buildAlertCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF2F2),
        border: Border.all(color: const Color(0xFFEF4444), width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.warning_amber_rounded, color: Color(0xFFEF4444)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Cảnh báo: Chưa uống thuốc',
                    style: TextStyle(color: Color(0xFF7F1D1D), fontWeight: FontWeight.bold, fontSize: 15)),
                const Text('Cha/Mẹ chưa xác nhận uống Vitamin D lúc 12:00. Đã quá 30 phút.',
                    style: TextStyle(color: Color(0xFFB91C1C), fontSize: 13)),
                const SizedBox(height: 8),
                Text('Gọi điện ngay',
                    style: TextStyle(color: Colors.red.shade700, decoration: TextDecoration.underline, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 3. Statistics Grid (90%, 3/3, 2)
  Widget _buildStatGrid() {
    return Row(
      children: [
        _statItem("90%", "Tuân thủ\ntháng này", const Color(0xFFF0FDF4), const Color(0xFF14532D)),
        const SizedBox(width: 12),
        _statItem("3/3", "Lịch thuốc\nhôm nay", const Color(0xFFEFF6FF), const Color(0xFF1E3A8A)),
        const SizedBox(width: 12),
        _statItem("2", "Lịch hẹn\nsắp tới", const Color(0xFFFAF5FF), const Color(0xFF581C87)),
      ],
    );
  }

  Widget _statItem(String value, String label, Color bg, Color textColor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: textColor.withOpacity(0.1)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textColor)),
            const SizedBox(height: 4),
            Text(label, style: TextStyle(fontSize: 11, color: textColor.withOpacity(0.8))),
          ],
        ),
      ),
    );
  }

  // 4. Medication List
  Widget _buildMedicationSchedule() {
    return _buildSectionCard(
      title: "Lịch uống thuốc hôm nay",
      children: [
        _medItem("Thuốc Huyết áp", "08:00 • 1 viên", "Đã uống lúc 08:05", Colors.green),
        _medItem("Vitamin D", "12:00 • 1 viên", "Bỏ lỡ", Colors.red),
      ],
    );
  }

  // 5. Appointment List
  Widget _buildAppointmentSchedule() {
    return _buildSectionCard(
      title: "Lịch hẹn sắp tới",
      children: [
        _appointmentItem("Tái khám Tim mạch", "15 Th 11 • 09:00", "BS. Nguyễn Văn A"),
      ],
    );
  }

  // Helper Widgets
  Widget _buildSectionCard({required String title, required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
          const Divider(height: 1),
          ...children,
        ],
      ),
    );
  }

  Widget _medItem(String name, String info, String status, Color color) {
    return ListTile(
      title: Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(info),
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
        child: Text(status, style: TextStyle(color: color, fontSize: 12)),
      ),
    );
  }

  Widget _appointmentItem(String title, String date, String doctor) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(8)),
        child: const Icon(Icons.calendar_today, color: Colors.blue),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text("$date\n$doctor"),
      isThreeLine: true,
    );
  }

  Widget _buildBottomNav() {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navItem(Icons.dashboard, "Tổng quan", true),
          _navItem(Icons.add_box, "Thêm lịch", false),
          _navItem(Icons.history, "Lịch sử", false),
          _navItem(Icons.settings, "Cài đặt", false),
        ],
      ),
    );
  }

  Widget _navItem(IconData icon, String label, bool active) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: active ? Colors.blue : Colors.grey),
        Text(label, style: TextStyle(color: active ? Colors.blue : Colors.grey, fontSize: 10)),
      ],
    );
  }
}