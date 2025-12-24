import 'package:flutter/material.dart';

class PopupAddSchedule extends StatefulWidget {
  const PopupAddSchedule({super.key});

  @override
  State<PopupAddSchedule> createState() => _PopupAddScheduleState();
}

class _PopupAddScheduleState extends State<PopupAddSchedule> {
  // Biến trạng thái để biết đang ở tab nào: 0 là Lịch thuốc, 1 là Lịch hẹn
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      // Bo góc lớn 32px theo phong cách hiện đại của dashboard
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Thanh kéo (Handle) phía trên cùng của popup
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 24), // Đã sửa từ EdgeInsets.bottom
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // 1. Tab Switcher để chọn loại lịch
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                _buildTabItem(0, 'Uống thuốc', Icons.medication_rounded),
                _buildTabItem(1, 'Lịch khám', Icons.calendar_month_rounded),
              ],
            ),
          ),
          const SizedBox(height: 28),

          // 2. Nội dung thay đổi dựa trên tab được chọn
          _selectedTab == 0 ? _buildMedicationForm() : _buildAppointmentForm(),

          const SizedBox(height: 32),

          // 3. Hàng nút bấm Lưu / Hủy
          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  'Hủy',
                  const Color(0xFFF1F5F9),
                  const Color(0xFF475569),
                  () => Navigator.pop(context),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildActionButton(
                  'Lưu lịch',
                  const Color(0xFF2563EB),
                  Colors.white,
                  () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Widget con: Mục Tab
  Widget _buildTabItem(int index, String label, IconData icon) {
    bool isActive = _selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTab = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isActive ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            boxShadow: isActive
                ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 18, color: isActive ? const Color(0xFF2563EB) : Colors.grey),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: isActive ? const Color(0xFF2563EB) : Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget con: Form cho Lịch Thuốc
  Widget _buildMedicationForm() {
    return Column(
      children: [
        _buildInputField('Tên loại thuốc', 'Ví dụ: Thuốc Huyết áp', Icons.edit_note_rounded),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _buildInputField('Giờ uống', '08:00 AM', Icons.access_time_rounded)),
            const SizedBox(width: 12),
            Expanded(child: _buildInputField('Liều lượng', '1 viên', Icons.numbers_rounded)),
          ],
        ),
        const SizedBox(height: 16),
        _buildInputField('Tần suất', 'Hàng ngày', Icons.repeat_rounded),
        const SizedBox(height: 16),
        _buildInputField('Ghi chú (tùy chọn)', 'Sau bữa ăn sáng', Icons.description_rounded),
      ],
    );
  }

  // Widget con: Form cho Lịch Khám
  Widget _buildAppointmentForm() {
    return Column(
      children: [
        _buildInputField('Nội dung khám', 'Ví dụ: Tái khám Tim mạch', Icons.health_and_safety_rounded),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _buildInputField('Ngày khám', '15/11/2023', Icons.calendar_today_rounded)),
            const SizedBox(width: 12),
            Expanded(child: _buildInputField('Giờ hẹn', '09:00 AM', Icons.access_time_rounded)),
          ],
        ),
        const SizedBox(height: 16),
        _buildInputField('Bác sĩ / Bệnh viện', 'BS. Nguyễn Văn A', Icons.person_search_rounded),
        const SizedBox(height: 16),
        _buildInputField('Ghi chú', 'Mang theo kết quả xét nghiệm cũ', Icons.notes_rounded),
      ],
    );
  }

  // Widget hỗ trợ: Ô nhập liệu
  Widget _buildInputField(String label, String hint, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF64748B)),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: TextField(
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 15),
              icon: Icon(icon, size: 20, color: const Color(0xFF94A3B8)),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ),
      ],
    );
  }

  // Widget hỗ trợ: Nút bấm
  Widget _buildActionButton(String label, Color bg, Color textCol, VoidCallback onTap) {
    return SizedBox(
      height: 52,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: bg,
          foregroundColor: textCol,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      ),
    );
  }
p