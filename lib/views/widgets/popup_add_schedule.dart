import 'package:flutter/material.dart';

class PopupAddSchedule extends StatelessWidget {
  const PopupAddSchedule({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tên thuốc
          _buildInputField(
            label: 'Tên thuốc',
            value: 'Thuốc Huyết áp',
          ),
          const SizedBox(height: 16),

          // Giờ uống và Liều lượng (Chia 2 cột)
          Row(
            children: [
              Expanded(
                child: _buildInputField(
                  label: 'Giờ uống',
                  value: '08:00 AM',
                  suffixIcon: Icons.access_time,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildInputField(
                  label: 'Liều lượng',
                  value: '1 viên',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Tần suất
          _buildInputField(
            label: 'Tần suất',
            value: 'Hàng ngày',
            suffixIcon: Icons.arrow_drop_down,
          ),
          const SizedBox(height: 16),

          // Ghi chú
          _buildInputField(
            label: 'Ghi chú (tùy chọn)',
            value: 'Sau bữa sáng',
            isHint: true,
          ),
          const SizedBox(height: 24),

          // Nút bấm Lưu / Hủy
          Row(
            children: [
              Expanded(
                child: _buildButton(
                  label: 'Lưu',
                  onPressed: () {},
                  color: const Color(0xFF2B7FFF),
                  textColor: Colors.white,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildButton(
                  label: 'Hủy',
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  color: const Color(0xFFE5E7EB),
                  textColor: const Color(0xFF354152),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Widget dùng chung cho các ô nhập liệu (View-only hoặc Trigger)
  Widget _buildInputField({
    required String label,
    required String value,
    IconData? suffixIcon,
    bool isHint = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF697282),
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: const Color(0xFFE5E7EB)),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                value,
                style: TextStyle(
                  color: isHint ? const Color(0x7F101727) : const Color(0xFF101727),
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
              if (suffixIcon != null)
                Icon(suffixIcon, size: 18, color: const Color(0xFF697282)),
            ],
          ),
        ),
      ],
    );
  }

  // Widget dùng chung cho Nút bấm
  Widget _buildButton({
    required String label,
    required VoidCallback onPressed,
    required Color color,
    required Color textColor,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 44,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: textColor,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}