import 'package:flutter/material.dart';
import 'dart:async'; // Cần thiết để sử dụng Timer

class GiaoDiNChNh extends StatefulWidget {
  const GiaoDiNChNh({super.key});

  @override
  State<GiaoDiNChNh> createState() => _GiaoDiNChNhState();
}

class _GiaoDiNChNhState extends State<GiaoDiNChNh> {
  late DateTime _now;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _now = DateTime.now();
    // Cập nhật thời gian mỗi giây để đảm bảo đồng hồ chính xác
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _now = DateTime.now();
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel(); // Hủy timer khi widget bị hủy để tránh rò rỉ bộ nhớ
    super.dispose();
  }

  // Hàm định dạng giờ:phút (HH:mm)
  String _formatTime(DateTime dt) {
    final String hour = dt.hour.toString().padLeft(2, '0');
    final String minute = dt.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  // Hàm định dạng ngày tháng tiếng Việt
  String _formatDate(DateTime dt) {
    const weekdays = [
      'Chủ Nhật',
      'Thứ Hai',
      'Thứ Ba',
      'Thứ Tư',
      'Thứ Năm',
      'Thứ Sáu',
      'Thứ Bảy',
    ];
    final String weekday = weekdays[dt.weekday % 7];
    return '$weekday, ${dt.day}/${dt.month}/${dt.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFFEFF6FF),
                      Colors.white,
                      Color(0xFFF0FDF4),
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 25,
                      vertical: 20,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // --- 1. Phần hiển thị Thời gian (Đã cập nhật hệ thống) ---
                        Column(
                          children: [
                            const SizedBox(height: 20),
                            Text(
                              _formatTime(_now), // Hiển thị giờ thực
                              style: const TextStyle(
                                color: Color(0xFF111827),
                                fontSize: 80,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -2,
                                height: 1,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              _formatDate(_now), // Hiển thị ngày thực
                              style: const TextStyle(
                                color: Color(0xFF4B5563),
                                fontSize: 28,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 30),

                        // --- 2. Danh sách nút chức năng (Giữ nguyên) ---
                        Column(
                          children: [
                            _buildActionButton(
                              label: 'SOS KHẨN CẤP',
                              color: const Color(0xFFEF4444),
                              icon: Icons.error_outline,
                              onTap: () => print("Bấm SOS"),
                            ),
                            const SizedBox(height: 20),
                            _buildActionButton(
                              label: 'XÁC NHẬN',
                              color: const Color(0xFF22C55E),
                              icon: Icons.check_circle_outline,
                              onTap: () => print("Bấm Xác nhận"),
                            ),
                            const SizedBox(height: 20),
                            _buildActionButton(
                              label: 'GỌI CON',
                              color: const Color(0xFFFF7F50),
                              icon: Icons.phone_outlined,
                              onTap: () => print("Bấm Gọi con"),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // Giữ nguyên hàm _buildActionButton của bạn
  Widget _buildActionButton({
    required String label,
    required Color color,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(16),
      elevation: 6,
      shadowColor: color.withOpacity(0.4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: double.infinity,
          height: 140,
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 50),
              const SizedBox(height: 8),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
