import 'package:flutter/material.dart';

class ModalDeleteSchedule extends StatelessWidget {
  const ModalDeleteSchedule({super.key});
  @override
  Widget build(BuildContext context) {
    return Center( // Căn giữa modal nếu cần
      child: Container(
        width: 397,
        // Bỏ height cố định để container tự co giãn theo nội dung
        padding: const EdgeInsets.all(24), 
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 1,
              color: Colors.black.withValues(alpha: 0.10),
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          shadows: const [
            BoxShadow(
              color: Color(0x19000000),
              blurRadius: 6,
              offset: Offset(0, 4),
              spreadRadius: -4,
            ), // Đã thêm dấu phẩy ở đây
            BoxShadow(
              color: Color(0x19000000),
              blurRadius: 15,
              offset: Offset(0, 10),
              spreadRadius: -3,
            )
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tiêu đề và Icon
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFEF2F2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.delete_outline, color: Color(0xFFE7000A)),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Xác nhận xóa lịch',
                  style: TextStyle(
                    color: Color(0xFF101727),
                    fontSize: 18,
                    fontFamily: 'Arimo',
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Nội dung câu hỏi
            RichText(
              text: TextSpan(
                style: const TextStyle(
                  color: Color(0xFF697282),
                  fontSize: 14,
                  fontFamily: 'Arimo',
                  height: 1.5,
                ),
                children: [
                  const TextSpan(text: 'Bạn có chắc chắn muốn xóa lịch '),
                  TextSpan(
                    text: '"Thuốc Huyết áp"',
                    style: const TextStyle(
                      color: Color(0xFF101727),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const TextSpan(text: ' lúc '),
                  TextSpan(
                    text: '18:00',
                    style: const TextStyle(
                      color: Color(0xFF101727),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const TextSpan(text: '?'),
                ],
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Hành động này không thể hoàn tác.',
              style: TextStyle(
                color: Color(0xFF697282),
                fontSize: 14,
                fontFamily: 'Arimo',
              ),
            ),
            const SizedBox(height: 24),
            
            // Hàng nút bấm
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Nút Hủy
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE5E7EB),
                    foregroundColor: const Color(0xFF354152),
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  ),
                  child: const Text('Hủy'),
                ),
                const SizedBox(width: 8),
                // Nút Xóa
                ElevatedButton(
                  onPressed: () {
                    // Xử lý logic xóa ở đây
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE7000A),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  ),
                  child: const Text('Xóa lịch'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}