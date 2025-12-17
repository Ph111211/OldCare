import 'package:flutter/material.dart';

void main() {
  runApp(const FigmaToCodeApp());
}

class FigmaToCodeApp extends StatelessWidget {
  const FigmaToCodeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Tắt chữ debug ở góc màn hình
      theme: ThemeData.light(), // Chuyển về light theme cho giống thiết kế Figma của bạn
      home: Scaffold(
        body: GiaoDiNChNh(),
      ),
    );
  }
}

class GiaoDiNChNh extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Sử dụng LayoutBuilder hoặc SingleChildScrollView để tránh lỗi tràn màn hình trên các máy nhỏ
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            width: double.infinity, // Tự động giãn theo chiều rộng màn hình
            height: 960,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment(-0.30, 0.30),
                end: Alignment(1.30, 0.70),
                colors: [Color(0xFFEFF6FF), Colors.white, Color(0xFFF0FDF4)],
              ),
            ),
            child: Stack(
              children: [
                // Phần hiển thị Giờ
                Positioned(
                  left: 0,
                  right: 0,
                  top: 106,
                  child: Text(
                    '14:30',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: const Color(0xFF111827),
                      fontSize: 70,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                // Phần hiển thị Ngày tháng
                Positioned(
                  left: 0,
                  right: 0,
                  top: 204,
                  child: Text(
                    'Thứ Tư, 19/11/2025',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: const Color(0xFF4B5563),
                      fontSize: 30, // Chỉnh lại một chút cho cân đối
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                // Danh sách các nút chức năng
                Positioned(
                  left: 0,
                  right: 0,
                  top: 280,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 26),
                    child: Column(
                      children: [
                        // Nút SOS
                        _buildBigButton(
                          label: 'SOS KHẨN CẤP',
                          color: const Color(0xFFEF4444),
                          onTap: () => print('SOS Pressed'),
                        ),
                        const SizedBox(height: 20),
                        // Nút Xác Nhận
                        _buildBigButton(
                          label: 'XÁC NHẬN',
                          color: const Color(0xFF22C55E),
                          onTap: () => print('Confirm Pressed'),
                        ),
                        const SizedBox(height: 20),
                        // Nút Gọi Con
                        _buildBigButton(
                          label: 'GỌI CON',
                          color: const Color(0xFFFF7F50),
                          onTap: () => print('Call Child Pressed'),
                        ),
                      ],
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

  // Hàm bổ trợ để tạo các nút bấm cho gọn code
  Widget _buildBigButton({required String label, required Color color, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 40),
        decoration: ShapeDecoration(
          color: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          shadows: const [
            BoxShadow(
              color: Color(0x19000000),
              blurRadius: 15,
              offset: Offset(0, 10),
              spreadRadius: -3,
            )
          ],
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontFamily: 'Inter',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}