//
// import 'dart:ui';

import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:flutter/material.dart';
// KHÔNG DÙNG: import 'package:flutter/rendering.dart';

class AddSchedule extends StatelessWidget {
  const AddSchedule({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(
                top: 60,
                left: 16,
                right: 16,
                bottom: 24,
              ),
              // decoration: const BoxDecoration(
              //   gradient: LinearGradient(
              //     begin: Alignment.centerLeft,
              //     end: Alignment.centerRight,
              //     colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)],
              //   ),
              // ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    // ✅ SỬA LỖI 1: withValues(alpha: 0.2) -> withOpacity(0.2)
                    backgroundColor: Colors.white.withOpacity(0.2),
                    child: const Icon(Icons.person, color: Colors.white),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'An Tâm - Con',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Chăm sóc Cha Mẹ',
                          style: TextStyle(
                            color: Color(0xFFDBEAFE),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.notifications_none, color: Colors.white),
                  const SizedBox(width: 12),
                  const Icon(Icons.settings, color: Colors.white),
                ],
              ),
            ),

            // Form Content
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                // ✅ ĐÃ SỬA: Loại bỏ thuộc tính spacing: 20
                children: [
                  _buildMedicationForm(),
                  const SizedBox(height: 20), // Thêm khoảng cách thay thế
                  _buildAppointmentForm(),
                ],
              ),
            ),
            const SizedBox(height: 100), // Space for Bottom Nav
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildMedicationForm() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        // ✅ ĐÃ SỬA: Loại bỏ thuộc tính spacing: 12
        children: [
          const Text(
            'Tạo lịch uống thuốc mới',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _buildTextField('Tên thuốc', 'Ví dụ: Thuốc Huyết áp'),
          const SizedBox(height: 12),
          Row(
            // ✅ ĐÃ SỬA: Loại bỏ thuộc tính spacing: 12
            children: [
              Expanded(
                child: _buildTextField(
                  'Thời gian',
                  '08:00 AM',
                  icon: Icons.access_time,
                ),
              ),
              const SizedBox(width: 12), // Khoảng cách ngang
              Expanded(child: _buildTextField('Liều lượng', '1 viên')),
            ],
          ),
          const SizedBox(height: 12),
          _buildTextField('Tần suất', 'Hàng ngày', icon: Icons.arrow_drop_down),
          const SizedBox(height: 8),
          Row(
            // ✅ ĐÃ SỬA: Loại bỏ thuộc tính spacing: 12
            children: [
              Expanded(
                child: _buildButton(
                  'Lưu lịch thuốc',
                  const Color(0xFF2563EB),
                  Colors.white,
                ),
              ),
              const SizedBox(width: 12), // Khoảng cách ngang
              _buildButton(
                'Hủy',
                const Color(0xFFE5E7EB),
                const Color(0xFF374151),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentForm() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        // ✅ ĐÃ SỬA: Loại bỏ thuộc tính spacing: 12
        children: [
          const Text(
            'Tạo lịch hẹn',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _buildTextField('Tiêu đề', 'Ví dụ: Tái khám Tim mạch'),
          const SizedBox(height: 12),
          Row(
            // ✅ ĐÃ SỬA: Loại bỏ thuộc tính spacing: 12
            children: [
              Expanded(
                child: _buildTextField(
                  'Ngày',
                  '11/15/2025',
                  icon: Icons.calendar_today,
                ),
              ),
              const SizedBox(width: 12), // Khoảng cách ngang
              Expanded(
                child: _buildTextField(
                  'Giờ',
                  '09:00 AM',
                  icon: Icons.access_time,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildTextField(
            'Ghi chú',
            'Địa điểm, bác sĩ, chuẩn bị...',
            maxLines: 2,
          ),
          const SizedBox(height: 8),
          Row(
            // ✅ ĐÃ SỬA: Loại bỏ thuộc tính spacing: 12
            children: [
              Expanded(
                child: _buildButton(
                  'Lưu lịch hẹn',
                  const Color(0xFF2563EB),
                  Colors.white,
                ),
              ),
              const SizedBox(width: 12), // Khoảng cách ngang
              _buildButton(
                'Hủy',
                const Color(0xFFE5E7EB),
                const Color(0xFF374151),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Reusable Widgets
  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: const Color(0xFFE5E7EB)),
      boxShadow: [
        // ✅ SỬA LỖI 1: withValues(alpha: 0.05) -> withOpacity(0.05)
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  Widget _buildTextField(
    String label,
    String hint, {
    IconData? icon,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
        ),
        const SizedBox(height: 6),
        TextField(
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            suffixIcon: icon != null ? Icon(icon, size: 20) : null,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildButton(String text, Color bg, Color textCol) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(color: textCol, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildBottomNav() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: const Color(0xFF2563EB),
      unselectedItemColor: Colors.grey,
      currentIndex: 1,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard),
          label: 'Tổng quan',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add_circle),
          label: 'Thêm lịch',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Lịch sử'),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Cài đặt'),
      ],
    );
  }
}
