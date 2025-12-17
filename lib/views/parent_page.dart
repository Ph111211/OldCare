import 'package:flutter/material.dart';

void main() {
  runApp(const FigmaToCodeApp());
}

class FigmaToCodeApp extends StatelessWidget {
  const FigmaToCodeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: GiaoDiNChNh(),
      ),
    );
  }
}

class GiaoDiNChNh extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // LayoutBuilder + SingleChildScrollView: "Công thức" để tránh lỗi sọc vàng
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              // Đảm bảo chiều cao tối thiểu bằng màn hình (để hiển thị đẹp trên máy lớn)
              minHeight: constraints.maxHeight,
            ),
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFEFF6FF), Colors.white, Color(0xFFF0FDF4)],
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween, 
                    children: [
                      // Phần hiển thị Thời gian
                      Column(
                        children: const [
                          SizedBox(height: 20),
                          Text(
                            '14:30',
                            style: TextStyle(
                              color: Color(0xFF111827),
                              fontSize: 80,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -2,
                              height: 1,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Thứ Tư, 19/11/2025',
                            style: TextStyle(
                              color: Color(0xFF4B5563),
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 30),

                      Column(
                        children: [
                          _buildActionButton(
                            label: 'SOS KHẨN CẤP',
                            color: const Color(0xFFEF4444),
                            icon: Icons.error_outline,
                            onTap: () {},
                          ),
                          const SizedBox(height: 20),
                          _buildActionButton(
                            label: 'XÁC NHẬN',
                            color: const Color(0xFF22C55E),
                            icon: Icons.check_circle_outline, 
                            onTap: () {},
                          ),
                          const SizedBox(height: 20),
                          _buildActionButton(
                            label: 'GỌI CON',
                            color: const Color(0xFFFF7F50),
                            icon: Icons.phone_outlined, 
                            onTap: () {},
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
    );
  }

  Widget _buildActionButton({
    required String label,
    required Color color,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16), 
      child: Container(
        width: double.infinity,
        height: 140, 
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 50,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}