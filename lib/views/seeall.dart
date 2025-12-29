import 'package:flutter/material.dart';

// Tên Widget: Đổi tên thành tiếng Anh để dễ làm việc, nhưng giữ nguyên ý nghĩa
class Seeall extends StatefulWidget {
  const Seeall({super.key});

  @override
  State<Seeall> createState() => _SeeallState();
}

class _SeeallState extends State<Seeall> {
  // --- WIDGET CON: HEADER & ICONS ---

  // Header chứa Avatar và Tên (Màu xanh Gradient)
  Widget _buildHeader(BuildContext context) {
    // Để cho AppBar tự điều chỉnh chiều rộng
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)],
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x19000000),
            blurRadius: 6,
            offset: Offset(0, 4),
            spreadRadius: -4,
          ),
          BoxShadow(
            color: Color(0x19000000),
            blurRadius: 15,
            offset: Offset(0, 10),
            spreadRadius: -3,
          )
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Cụm bên trái: Avatar + Tên
            Row(
              children: [
                _buildAvatar(),
                const SizedBox(width: 12),
                const Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'An Tâm - Con',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 23.60, // Giữ kích thước ban đầu
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700,
                        height: 1.36,
                      ),
                    ),
                    Text(
                      'Chăm sóc Cha Mẹ',
                      style: TextStyle(
                        color: Color(0xFFDBEAFE),
                        fontSize: 13.30, // Giữ kích thước ban đầu
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        height: 1.50,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            // Cụm bên phải: Thông báo + Cài đặt
            Row(
              children: [
                _buildNotificationIcon(),
                const SizedBox(width: 8),
                _buildSettingsIcon(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Widget Avatar tròn
  Widget _buildAvatar() {
    return Container(
      width: 48,
      height: 48,
      decoration: const BoxDecoration(
        color: Colors.white38, // Dùng Colors.white38 thay cho Colors.white.withValues(alpha: 0.20)
        shape: BoxShape.circle,
      ),
      child: const Icon(Icons.person, color: Colors.white), // Thêm Icon
    );
  }

  // Widget Icon thông báo có dấu chấm đỏ
  Widget _buildNotificationIcon() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          const Icon(Icons.notifications_none_outlined, color: Colors.white, size: 24),
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Color(0xFFEF4444),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget Icon cài đặt
  Widget _buildSettingsIcon() {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: Icon(Icons.settings_outlined, color: Colors.white, size: 24),
    );
  }

  // --- WIDGET CON: NAVIGATION BAR DƯỚI ĐÁY ---
  Widget _buildBottomNavBar() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(width: 1, color: Color(0xFFE5E7EB))),
        boxShadow: [
          BoxShadow(
            color: Color(0x19000000),
            blurRadius: 15,
            offset: Offset(0, 10),
            spreadRadius: -3,
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _navBarItem(icon: Icons.dashboard_outlined, label: 'Tổng\nquan', isSelected: true),
              _navBarItem(icon: Icons.add_circle_outline, label: 'Thêm\nlịch', isSelected: false),
              _navBarItem(icon: Icons.history, label: 'Lịch\nsử', isSelected: false),
              _navBarItem(icon: Icons.settings_outlined, label: 'Cài\nđặt', isSelected: false),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navBarItem({required IconData icon, required String label, required bool isSelected}) {
    final color = isSelected ? const Color(0xFF2563EB) : const Color(0xFF4B5563);
    final bgColor = isSelected ? const Color(0xFFEFF6FF) : Colors.transparent;

    return Expanded(
      child: InkWell(
        onTap: () {
          // Xử lý sự kiện chuyển tab/màn hình ở đây
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(height: 4),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: color,
                  fontSize: 11.40,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  height: 1.40,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- WIDGET CHÍNH: BUILD ---

  @override
  Widget build(BuildContext context) {
    // 🔴 Dùng Scaffold để có cấu trúc màn hình chuẩn
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB), // Màu nền của body
      // Dùng PreferredSize để tạo AppBar tùy chỉnh với chiều cao lớn
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100.0), // Chiều cao phù hợp cho header
        child: _buildHeader(context),
      ),
      // Dùng Stack để xếp chồng các lớp widget (nếu cần thiết)
      body: SingleChildScrollView( // 🔴 Đảm bảo nội dung có thể cuộn
        child: Padding(
          padding: const EdgeInsets.all(16.0), // Padding chung cho body
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. THANH QUAY LẠI & NGÀY THÁNG
              _buildTopBar(),
              const SizedBox(height: 16),

              // 2. CARD TỔNG QUAN HÔM NAY
              _buildTodayOverviewCard(),
              const SizedBox(height: 16),

              // 3. CARD LỊCH TRÌNH
              const Text(
                'Lịch trình hôm nay',
                style: TextStyle(
                  color: Color(0xFF101727),
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              _buildScheduleCard(
                title: 'Thuốc Huyết áp',
                time: '08:00',
                status: 'Đã uống',
                pillCount: '1 viên',
                note: 'Sau bữa sáng',
                isCompleted: true,
                isMissed: false,
              ),
              const SizedBox(height: 12),
              _buildScheduleCard(
                title: 'Vitamin D',
                time: '12:00',
                status: 'Đã lỡ',
                pillCount: '1 viên',
                note: null, // Không có ghi chú
                isCompleted: false,
                isMissed: true,
              ),
              const SizedBox(height: 12),
              _buildScheduleCard(
                title: 'Thuốc Huyết áp',
                time: '18:00',
                status: 'Chưa đến giờ',
                pillCount: '1 viên',
                note: 'Sau bữa tối',
                isCompleted: false,
                isMissed: false,
              ),
            ],
          ),
        ),
      ),
      // 🔴 Dùng thuộc tính bottomNavigationBar để đặt thanh điều hướng
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  // --- CÁC WIDGET CON KHÁC CHO BODY ---

  Widget _buildTopBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Nút Quay lại
        TextButton.icon(
          onPressed: () {
            Navigator.pop(context); // Quay lại màn hình trước
          },
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF101727), size: 16),
          label: const Text(
            'Quay lại',
            style: TextStyle(
              color: Color(0xFF101727),
              fontSize: 16,
              fontFamily: 'Arimo',
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        // Ngày tháng
        const Text(
          'Thứ Tư, 10 tháng 12',
          style: TextStyle(
            color: Color(0xFF697282),
            fontSize: 14,
            fontFamily: 'Arimo',
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildTodayOverviewCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x19000000),
            blurRadius: 3,
            offset: Offset(0, 1),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tổng quan hôm nay',
            style: TextStyle(
              color: Color(0xFF101727),
              fontSize: 16,
              fontFamily: 'Arimo',
              fontWeight: FontWeight.w400,
              height: 1.50,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildOverviewItem(count: '3', label: 'Tổng lịch', color: const Color(0xFF101727)),
              _buildOverviewItem(count: '1', label: 'Đã hoàn thành', color: const Color(0xFF00A63D)),
              _buildOverviewItem(count: '1', label: 'Đã bỏ lỡ', color: const Color(0xFFE7000A)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewItem({required String count, required String label, required Color color}) {
    return Expanded(
      child: Column(
        children: [
          Text(
            count,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: color,
              fontSize: 24,
              fontFamily: 'Arimo',
              fontWeight: FontWeight.w400,
            ),
          ),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF697282),
              fontSize: 12,
              fontFamily: 'Arimo',
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleCard({
    required String title,
    required String time,
    required String status,
    required String pillCount,
    required String? note,
    required bool isCompleted,
    required bool isMissed,
  }) {
    Color statusColor;
    Color statusBgColor;
    String iconPath;

    if (isCompleted) {
      statusColor = const Color(0xFF00A63D);
      statusBgColor = const Color(0xFFF0FDF4);
      iconPath = 'check_circle_fill'; // Giả định icon đã uống/hoàn thành
    } else if (isMissed) {
      statusColor = const Color(0xFFE7000A);
      statusBgColor = const Color(0xFFFEF2F2);
      iconPath = 'close_circle_fill'; // Giả định icon đã lỡ
    } else {
      statusColor = const Color(0xFFD08700);
      statusBgColor = const Color(0xFFFEFCE8);
      iconPath = 'timer_fill'; // Giả định icon chờ
    }

    return Container(
      padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x19000000),
            blurRadius: 3,
            offset: Offset(0, 1),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Icon thuốc
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF6FF),
                        borderRadius: BorderRadius.circular(9999),
                      ),
                      child: const Icon(Icons.medication_liquid, color: Color(0xFF2563EB)), // Thay thế Stack bằng Icon
                    ),
                    const SizedBox(width: 12),
                    // Thông tin lịch
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              color: Color(0xFF101727),
                              fontSize: 16,
                              fontFamily: 'Arimo',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 4),
                          // Chi tiết thời gian và số lượng
                          Row(
                            children: [
                              const Icon(Icons.access_time, size: 14, color: Color(0xFF697282)), // Icon đồng hồ
                              const SizedBox(width: 4),
                              Text(time, style: const TextStyle(color: Color(0xFF697282), fontSize: 14)),
                              const SizedBox(width: 8),
                              const Text('•', style: TextStyle(color: Color(0xFF697282), fontSize: 14)),
                              const SizedBox(width: 8),
                              Text(pillCount, style: const TextStyle(color: Color(0xFF697282), fontSize: 14)),
                            ],
                          ),
                          if (note != null) ...[
                            const SizedBox(height: 4),
                            // Ghi chú
                            Row(
                              children: [
                                const Icon(Icons.notes, size: 12, color: Color(0xFF697282)), // Icon ghi chú
                                const SizedBox(width: 4),
                                Text(
                                  note,
                                  style: const TextStyle(color: Color(0xFF697282), fontSize: 12),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Trạng thái (Đã uống, Đã lỡ, Chưa đến giờ)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: statusBgColor,
                  borderRadius: BorderRadius.circular(9999),
                  border: Border.all(
                    width: 1,
                    color: statusColor.withOpacity(0.5), // Tạo màu border phù hợp
                  ),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 12,
                    fontFamily: 'Arimo',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
          // Nút Sửa/Xóa
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Container(
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(width: 1, color: Color(0xFFE5E7EB))),
              ),
              padding: const EdgeInsets.only(top: 8, bottom: 8),
              child: Row(
                children: [
                  _actionButton(
                      label: 'Sửa',
                      icon: Icons.edit_outlined,
                      bgColor: const Color(0xFFF3F4F6),
                      textColor: const Color(0xFF101727),
                      onTap: () {}),
                  const SizedBox(width: 8),
                  _actionButton(
                      label: 'Xóa',
                      icon: Icons.delete_outline,
                      bgColor: const Color(0xFFFEF2F2),
                      textColor: const Color(0xFFE7000A),
                      onTap: () {}),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionButton({
    required String label,
    required IconData icon,
    required Color bgColor,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 40,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: textColor, size: 18), // Icon
              const SizedBox(width: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: textColor,
                  fontSize: 16,
                  fontFamily: 'Arimo',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}