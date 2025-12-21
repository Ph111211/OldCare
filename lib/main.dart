import 'package:flutter/material.dart';
import 'package:oldcare/views/seeall.dart';

import 'views/login_page.dart';
import 'views/signup_page.dart';
void main() {
  runApp(const FigmaToCodeApp());
}

class FigmaToCodeApp extends StatelessWidget {
  const FigmaToCodeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF9FAFB),
        fontFamily: 'Inter',
        useMaterial3: true,
      ),
      home: const CaregiverDashboardScreen(),
    );
  }
}

class CaregiverDashboardScreen extends StatelessWidget {
  const CaregiverDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const double containerHeight = 1151;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SizedBox(
        width: screenWidth,
        height: containerHeight,
        child: Stack(
          children: [
            // --- Content and Scrollable Area ---
            Positioned.fill(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 24),
                child: Column(
                  children: [
                    _buildHeader(screenWidth),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 24),
                          _buildAlertBox(),
                          const SizedBox(height: 24),
                          _buildMetricCards(),
                          const SizedBox(height: 24),
                          _buildMedicineScheduleCard(),
                          const SizedBox(height: 24),
                          _buildAppointmentScheduleCard(),
                          const SizedBox(height: 120),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // --- Bottom Navigation Bar (Fixed) ---
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: _buildBottomNavBar(screenWidth),
            ),
          ],
        ),
      ),
    );
  }

  // MARK: - Header Widget
  Widget _buildHeader(double screenWidth) {
    return Container(
      width: screenWidth,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment(0.00, 0.50),
          end: Alignment(1.00, 0.50),
          colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 4),
            spreadRadius: -4,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 10),
            spreadRadius: -3,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              // Avatar (ĐÃ SỬA LỖI DÒNG 133)
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration( // Đã chuyển sang BoxDecoration
                  color: Colors.white.withOpacity(0.20),
                  shape: BoxShape.circle, // BoxShape.circle hợp lệ trong BoxDecoration
                ),
                child: const Center(
                  child: Icon(Icons.person, color: Colors.white, size: 24),
                ),
              ),
              const SizedBox(width: 12),
              // Text Info
              const Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'An Tâm - Con',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24, 
                      fontWeight: FontWeight.w700,
                      height: 1.36,
                    ),
                  ),
                  Text(
                    'Chăm sóc Cha Mẹ',
                    style: TextStyle(
                      color: Color(0xFFDBEAFE),
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      height: 1.50,
                    ),
                  ),
                ],
              ),
            ],
          ),
          // Actions
          Row(
            children: [
              // Notification Icon
              Container(
                padding: const EdgeInsets.all(8),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    const Icon(Icons.notifications_none, color: Colors.white, size: 24),
                    const Positioned(
                      right: -4,
                      top: -4,
                      child: CircleAvatar(
                        radius: 4,
                        backgroundColor: Color(0xFFEF4444),
                      ),
                    ),
                  ],
                ),
              ),
              // Menu Icon
              Container(
                padding: const EdgeInsets.all(8),
                child: const Icon(Icons.more_vert, color: Colors.white, size: 24),
              ),
            ],
          ),
        ],
      title: 'An Tâm Login UI',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto', 
        useMaterial3: true,
      ),
    routes: {
      '/': (context) => const LoginScreen(),
      '/signup': (context) => const RegisterScreen(),
    },
    );
  }

  // MARK: - Alert Box Widget
  Widget _buildAlertBox() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(
        top: 16,
        left: 20,
        right: 16,
        bottom: 16,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF2F2),
        border: Border.all(
          width: 4,
          color: const Color(0xFFEF4444),
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 26,
            padding: const EdgeInsets.only(top: 2),
            child: const Icon(Icons.warning_amber_rounded, color: Color(0xFFEF4444), size: 24),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Cảnh báo: Chưa uống thuốc',
                  style: TextStyle(
                    color: Color(0xFF7F1D1D),
                    fontSize: 15.5,
                    fontWeight: FontWeight.w700,
                    height: 1.55,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Cha/Mẹ chưa xác nhận uống Vitamin D lúc\n12:00. Đã quá 30 phút.',
                  style: TextStyle(
                    color: Color(0xFFB91C1C),
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    height: 1.50,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Gọi điện ngay',
                  style: TextStyle(
                    color: Color(0xFFDC2626),
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    decoration: TextDecoration.underline,
                    height: 1.53,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // MARK: - Metric Cards Widget
  Widget _buildMetricCards() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: _buildMetricItem(
          gradientColors: const [Color(0xFFF0FDF4), Color(0xFFDCFCE7)],
          borderColor: const Color(0xFFBBF7D0),
          icon: Icons.check_circle_outline,
          iconColor: const Color(0xFF14532D),
          value: '90%',
          valueColor: const Color(0xFF14532D),
          label: 'Tuân thủ\ntháng này',
          labelColor: const Color(0xFF15803D),
        )),
        const SizedBox(width: 16),
        Expanded(child: _buildMetricItem(
          gradientColors: const [Color(0xFFEFF6FF), Color(0xFFDBEAFE)],
          borderColor: const Color(0xFFBFDBFE),
          icon: Icons.access_time_outlined,
          iconColor: const Color(0xFF1E3A8A),
          value: '3/3',
          valueColor: const Color(0xFF1E3A8A),
          label: 'Lịch thuốc\nhôm nay',
          labelColor: const Color(0xFF1D4ED8),
        )),
        const SizedBox(width: 16),
        Expanded(child: _buildMetricItem(
          gradientColors: const [Color(0xFFFAF5FF), Color(0xFFF3E8FF)],
          borderColor: const Color(0xFFE9D5FF),
          icon: Icons.calendar_month_outlined,
          iconColor: const Color(0xFF581C87),
          value: '2',
          valueColor: const Color(0xFF581C87),
          label: 'Lịch hẹn\nsắp tới',
          labelColor: const Color(0xFF7E22CE),
        )),
      ],
    );
  }

  Widget _buildMetricItem({
    required List<Color> gradientColors,
    required Color borderColor,
    required IconData icon,
    required Color iconColor,
    required String value,
    required Color valueColor,
    required String label,
    required Color labelColor,
  }) {
    return Container(
      height: 130,
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: const Alignment(-0.15, 0.15),
          end: const Alignment(1.15, 0.85),
          colors: gradientColors,
        ),
        border: Border.all(width: 1, color: borderColor),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 32),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(
                  color: valueColor,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  height: 1.4,
                ),
              ),
              Text(
                label,
                style: TextStyle(
                  color: labelColor,
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // MARK: - Schedule Card Components
  Widget _buildScheduleHeader(String title) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 17),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(width: 1, color: Color(0xFFE5E7EB))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF111827),
              fontSize: 17,
              fontWeight: FontWeight.w700,
              height: 1.61,
            ),
          ),
          // ...existing code...
          Builder(
            builder: (context) => GestureDetector(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const Seeall())),
              child: const Text('Xem tất cả', 
                      style: TextStyle(
                      color: Color(0xFF2563EB),
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      height: 1.56,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMedicineItem({
    required String name,
    required String details,
    String? statusDetail,
    required String statusText,
    required Color statusBgColor,
    required Color statusTextColor,
    required IconData statusIcon,
  }) {
    return Container(
      padding: const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 24),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(width: 1, color: Color(0xFFF3F4F6))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: Color(0xFF111827),
                    fontSize: 15.5,
                    fontWeight: FontWeight.w700,
                    height: 1.57,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  details,
                  style: const TextStyle(
                    color: Color(0xFF4B5563),
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    height: 1.55,
                  ),
                ),
                if (statusDetail != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      statusDetail,
                      style: const TextStyle(
                        color: Color(0xFF16A34A),
                        fontSize: 11.5,
                        fontWeight: FontWeight.w400,
                        height: 1.40,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: statusBgColor,
              borderRadius: BorderRadius.circular(9999),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(statusIcon, color: statusTextColor, size: 16),
                const SizedBox(width: 4),
                Text(
                  statusText,
                  style: TextStyle(
                    color: statusTextColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    height: 1.50,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMedicineScheduleCard() {
    return _buildCard(
      children: [
        _buildScheduleHeader('Lịch uống thuốc hôm nay'),
        _buildMedicineItem(
          name: 'Thuốc Huyết áp',
          details: '08:00 • 1 viên',
          statusDetail: '✓ Đã uống lúc 08:05',
          statusText: 'Đã uống',
          statusBgColor: const Color(0xFFDCFCE7),
          statusTextColor: const Color(0xFF15803D),
          statusIcon: Icons.check,
        ),
        _buildMedicineItem(
          name: 'Thuốc Tiểu đường',
          details: '18:00 • 2 viên',
          statusText: 'Chưa đến giờ',
          statusBgColor: const Color(0xFFFEF9C3),
          statusTextColor: const Color(0xFFA16207),
          statusIcon: Icons.access_time_filled,
        ),
        _buildMedicineItem(
          name: 'Vitamin D',
          details: '12:00 • 1 viên',
          statusText: 'Bỏ lỡ',
          statusBgColor: const Color(0xFFFEE2E2),
          statusTextColor: const Color(0xFFB91C1C),
          statusIcon: Icons.cancel,
        ),
      ],
    );
  }

  Widget _buildAppointmentItem({
    required String monthAbbreviation,
    required String day,
    required String title,
    required String details,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(width: 1, color: Color(0xFFF3F4F6))),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Date Box
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFDBEAFE),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  monthAbbreviation,
                  style: const TextStyle(
                    color: Color(0xFF2563EB),
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    height: 1.33,
                  ),
                ),
                Text(
                  day,
                  style: const TextStyle(
                    color: Color(0xFF1E3A8A),
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    height: 1.58,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Appointment Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF111827),
                    fontSize: 15.5,
                    fontWeight: FontWeight.w700,
                    height: 1.54,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  details,
                  style: const TextStyle(
                    color: Color(0xFF4B5563),
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    height: 1.52,
                  ),
                ),
              ],
            ),
          ),
          // Detail Button
          const Center(
            child: Text(
              'Chi tiết',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF2563EB),
                fontSize: 13,
                fontWeight: FontWeight.w400,
                height: 1.56,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentScheduleCard() {
    return _buildCard(
      children: [
        _buildScheduleHeader('Lịch hẹn sắp tới'),
        _buildAppointmentItem(
          monthAbbreviation: 'Th 11',
          day: '15',
          title: 'Tái khám Tim mạch',
          details: '09:00 • BS. Nguyễn Văn A',
        ),
        _buildAppointmentItem(
          monthAbbreviation: 'Th 11',
          day: '20',
          title: 'Xét nghiệm máu',
          details: '07:30 • Phòng khám Bình An',
        ),
      ],
    );
  }

  // MARK: - Generic Card Builder
  Widget _buildCard({required List<Widget> children}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(1),
      decoration: BoxDecoration( 
        color: Colors.white,
        border: Border.all(
          width: 1,
          color: const Color(0xFFE5E7EB),
        ),
        borderRadius: BorderRadius.circular(12), 
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 2,
            offset: const Offset(0, 1),
            spreadRadius: 0,
          )
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  // MARK: - Bottom Navigation Bar
  Widget _buildBottomNavBar(double screenWidth) {
    return Container(
      width: screenWidth,
      padding: const EdgeInsets.only(top: 1),
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(top: BorderSide(width: 1, color: Color(0xFFE5E7EB))),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 4),
            spreadRadius: -4,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 10),
            spreadRadius: -3,
          )
        ],
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 896),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.dashboard, 'Tổng\nquan', true),
              _buildNavItem(Icons.add_circle_outline, 'Thêm\nlịch', false),
              _buildNavItem(Icons.history, 'Lịch\nsử', false),
              _buildNavItem(Icons.settings_outlined, 'Cài\nđặt', false),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isActive) {
    const Color activeColor = Color(0xFF2563EB);
    const Color inactiveColor = Color(0xFF4B5563);

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 4),
              decoration: BoxDecoration(
                color: isActive ? const Color(0xFFEFF6FF) : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Icon(icon, color: isActive ? activeColor : inactiveColor, size: 24),
                  const SizedBox(height: 4),
                  Text(
                    label,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: isActive ? activeColor : inactiveColor,
                      fontSize: 11.5,
                      fontWeight: FontWeight.w400,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}