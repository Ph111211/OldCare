import 'package:flutter/material.dart';

class SeeAllMedicationPage extends StatelessWidget {
  const SeeAllMedicationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: Stack(
        children: [
          // Nội dung chính có thể cuộn
          SingleChildScrollView(
            child: Column(
              children: [
                _buildHeader(),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTopNavigation(context),
                      const SizedBox(height: 16),
                      _buildTodaySummary(),
                      const SizedBox(height: 16),
                      _buildMedicineList(),
                      const SizedBox(height: 100), // Khoảng trống cho Bottom Nav
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Thanh điều hướng dưới cùng cố định
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

  // 1. Header màu xanh lam
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
                      style: TextStyle(color: Color(0xFFDBEAFE), fontSize: 13)),
                ],
              ),
            ],
          ),
          const Icon(Icons.notifications_none, color: Colors.white),
        ],
      ),
    );
  }

  // 2. Nút quay lại và Ngày tháng
  Widget _buildTopNavigation(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Row(
            children: const [
              Icon(Icons.arrow_back_ios, size: 18, color: Color(0xFF101727)),
              Text('Quay lại', style: TextStyle(fontSize: 16, color: Color(0xFF101727))),
            ],
          ),
        ),
        const Text('Thứ Tư, 10 tháng 12',
            style: TextStyle(color: Color(0xFF697282), fontSize: 14)),
      ],
    );
  }

  // 3. Card tổng quan (Tổng lịch, Hoàn thành, Bỏ lỡ)
  Widget _buildTodaySummary() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Tổng quan hôm nay', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildSummaryItem("3", "Tổng lịch", Colors.black87),
              _buildSummaryItem("1", "Đã hoàn thành", const Color(0xFF00A63D)),
              _buildSummaryItem("1", "Đã bỏ lỡ", const Color(0xFFE7000A)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String value, String label, Color color) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
        Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFF697282))),
      ],
    );
  }

  // 4. Danh sách các liều thuốc
  Widget _buildMedicineList() {
    return Column(
      children: [
        _buildMedicineCard(
          name: "Thuốc Huyết áp",
          time: "08:00",
          dosage: "1 viên",
          note: "Sau bữa sáng",
          statusText: "Đã uống",
          statusColor: const Color(0xFF00A63D),
          statusBg: const Color(0xFFF0FDF4),
        ),
        const SizedBox(height: 12),
        _buildMedicineCard(
          name: "Vitamin D",
          time: "12:00",
          dosage: "1 viên",
          note: "Sau bữa trưa",
          statusText: "Đã lỡ",
          statusColor: const Color(0xFFE7000A),
          statusBg: const Color(0xFFFEF2F2),
        ),
        const SizedBox(height: 12),
        _buildMedicineCard(
          name: "Thuốc Tiểu đường",
          time: "18:00",
          dosage: "1 viên",
          note: "Sau bữa tối",
          statusText: "Chưa đến giờ",
          statusColor: const Color(0xFFD08700),
          statusBg: const Color(0xFFFEFCE8),
        ),
      ],
    );
  }

  Widget _buildMedicineCard({
    required String name,
    required String time,
    required String dosage,
    required String note,
    required String statusText,
    required Color statusColor,
    required Color statusBg,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(color: Color(0xFFEFF6FF), shape: BoxShape.circle),
                    child: const Icon(Icons.medication, color: Color(0xFF2563EB), size: 20),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text('$time • $dosage', style: const TextStyle(color: Color(0xFF697282), fontSize: 14)),
                      Text(note, style: const TextStyle(color: Color(0xFF697282), fontSize: 12)),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusBg,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: statusColor.withOpacity(0.2)),
                ),
                child: Text(statusText, style: TextStyle(color: statusColor, fontSize: 12, fontWeight: FontWeight.w500)),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(height: 1),
          ),
          Row(
            children: [
              Expanded(child: _buildActionButton(Icons.edit, "Sửa", const Color(0xFFF3F4F6), Colors.black87)),
              const SizedBox(width: 12),
              Expanded(child: _buildActionButton(Icons.delete_outline, "Xóa", const Color(0xFFFEF2F2), const Color(0xFFE7000A))),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label, Color bg, Color textColor) {
    return Container(
      height: 40,
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(10)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 16, color: textColor),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(color: textColor, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  // 5. Bottom Navigation Bar
  Widget _buildBottomNav() {
    return Container(
      height: 85,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navItem(Icons.grid_view_rounded, "Tổng quan", true),
          _navItem(Icons.add_circle_outline, "Thêm lịch", false),
          _navItem(Icons.history, "Lịch sử", false),
          _navItem(Icons.settings_outlined, "Cài đặt", false),
        ],
      ),
    );
  }

  Widget _navItem(IconData icon, String label, bool isActive) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: isActive ? const Color(0xFF2563EB) : const Color(0xFF6B7280)),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 11, color: isActive ? const Color(0xFF2563EB) : const Color(0xFF6B7280))),
      ],
    );
  }
}