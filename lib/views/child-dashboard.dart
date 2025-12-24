import 'package:flutter/material.dart';

class ChildDashboard extends StatelessWidget {
  const ChildDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      // Sử dụng SafeArea để tránh bị lẹm vào tai thỏ/nốt ruồi của điện thoại
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  _buildHeader(),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 20, 16, 100),
                    child: Column(
                      children: [
                        _buildWarningCard(),
                        const SizedBox(height: 20),
                        _buildQuickStats(),
                        const SizedBox(height: 24),
                        _buildMedicationSection(),
                        const SizedBox(height: 24),
                        _buildAppointmentSection(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            _buildCustomBottomNav(),
          ],
        ),
      ),
    );
  }

  // 1. Header Blue Gradient
  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white.withOpacity(0.5), width: 2),
                ),
                child: const CircleAvatar(
                  radius: 22,
                  backgroundColor: Colors.white24,
                  child: Icon(Icons.person, color: Colors.white),
                ),
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
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              _headerIconButton(Icons.notifications_none_outlined, true),
              const SizedBox(width: 12),
              _headerIconButton(Icons.settings_outlined, false),
            ],
          ),
        ],
      ),
    );
  }

  Widget _headerIconButton(IconData icon, bool hasNotification) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: Colors.white, size: 22),
        ),
        if (hasNotification)
          Positioned(
            right: 4,
            top: 4,
            child: Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
            ),
          ),
      ],
    );
  }

  // 2. Warning Card
  Widget _buildWarningCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF2F2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFCA5A5), width: 1.5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.warning_rounded, color: Color(0xFFEF4444), size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Cảnh báo: Chưa uống thuốc',
                  style: TextStyle(
                    color: Color(0xFF991B1B),
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Cha/Mẹ chưa xác nhận uống Vitamin D lúc 12:00. Đã quá 30 phút.',
                  style: TextStyle(color: Color(0xFFB91C1C), fontSize: 13),
                ),
                const SizedBox(height: 8),
                InkWell(
                  onTap: () {},
                  child: const Text(
                    'Gọi điện ngay',
                    style: TextStyle(
                      color: Color(0xFFDC2626),
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 3. Quick Stats Grid
  Widget _buildQuickStats() {
    return Row(
      children: [
        _statCard('90%', 'Tuân thủ\ntháng này', Icons.check_circle_outline, const Color(0xFFF0FDF4), const Color(0xFF15803D)),
        const SizedBox(width: 12),
        _statCard('3/3', 'Lịch thuốc\nhôm nay', Icons.medication_outlined, const Color(0xFFEFF6FF), const Color(0xFF1D4ED8)),
        const SizedBox(width: 12),
        _statCard('2', 'Lịch hẹn\nsắp tới', Icons.calendar_today_outlined, const Color(0xFFFAF5FF), const Color(0xFF7E22CE)),
      ],
    );
  }

  Widget _statCard(String val, String label, IconData icon, Color bg, Color textCol) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: textCol.withOpacity(0.1)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: textCol, size: 24),
            const SizedBox(height: 12),
            Text(val, style: TextStyle(color: textCol, fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(label, style: TextStyle(color: textCol.withOpacity(0.8), fontSize: 11, height: 1.2)),
          ],
        ),
      ),
    );
  }

  // 4. Medication Section
  Widget _buildMedicationSection() {
    return _sectionWrapper(
      title: 'Lịch uống thuốc hôm nay',
      onViewAll: () {},
      child: Column(
        children: [
          _medicationTile('Thuốc Huyết áp', '08:00 • 1 viên', 'Đã uống lúc 08:05', Colors.green, Icons.done_all),
          _divider(),
          _medicationTile('Vitamin D', '12:00 • 1 viên', 'Bỏ lỡ', Colors.red, Icons.close),
          _divider(),
          _medicationTile('Thuốc Tiểu đường', '18:00 • 2 viên', 'Chưa đến giờ', Colors.orange, Icons.access_time),
        ],
      ),
    );
  }

  Widget _medicationTile(String name, String info, String status, Color col, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: col.withOpacity(0.1), shape: BoxShape.circle),
            child: Icon(Icons.pill, color: col, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                Text(info, style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: col.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Icon(icon, color: col, size: 14),
                const SizedBox(width: 4),
                Text(status, style: TextStyle(color: col, fontSize: 11, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 5. Appointment Section
  Widget _buildAppointmentSection() {
    return _sectionWrapper(
      title: 'Lịch hẹn sắp tới',
      onViewAll: () {},
      child: Column(
        children: [
          _appointmentTile('15', 'Th 11', 'Tái khám Tim mạch', 'BS. Nguyễn Văn A'),
          _divider(),
          _appointmentTile('20', 'Th 11', 'Xét nghiệm máu', 'Phòng khám Bình An'),
        ],
      ),
    );
  }

  Widget _appointmentTile(String day, String month, String title, String sub) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Container(
            width: 50,
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Text(month, style: const TextStyle(fontSize: 10, color: Color(0xFF2563EB), fontWeight: FontWeight.bold)),
                Text(day, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E3A8A))),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                const SizedBox(height: 2),
                Text(sub, style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
    );
  }

  // Helper Widgets
  Widget _sectionWrapper({required String title, required VoidCallback onViewAll, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 15, offset: const Offset(0, 5)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1F2937))),
              TextButton(onPressed: onViewAll, child: const Text('Xem tất cả', style: TextStyle(color: Color(0xFF2563EB), fontSize: 13))),
            ],
          ),
          child,
        ],
      ),
    );
  }

  Widget _divider() => Divider(color: Colors.grey.withOpacity(0.1), height: 1);

  // 6. Custom Bottom Nav
  Widget _buildCustomBottomNav() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 20, offset: const Offset(0, -5))],
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _navItem(Icons.grid_view_rounded, 'Tổng quan', true),
            _navItem(Icons.add_circle_outline_rounded, 'Thêm lịch', false),
            _navItem(Icons.history_rounded, 'Lịch sử', false),
            _navItem(Icons.person_outline_rounded, 'Cài đặt', false),
          ],
        ),
      ),
    );
  }

  Widget _navItem(IconData icon, String label, bool isActive) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: isActive ? const Color(0xFF2563EB) : const Color(0xFF9CA3AF), size: 26),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            color: isActive ? const Color(0xFF2563EB) : const Color(0xFF9CA3AF),
          ),
        ),
      ],
    );
  }
}