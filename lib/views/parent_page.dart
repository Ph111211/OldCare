import 'package:flutter/material.dart';

// Class chính hiển thị giao diện Bố Mẹ
class GiaoDiNChNh extends StatelessWidget {
  const GiaoDiNChNh({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
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
                        // --- 1. Phần hiển thị Thời gian ---
                        const Column(
                          children: [
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

                        // --- 2. Danh sách nút chức năng ---
                        Column(
                          children: [
                            _buildActionButton(
                              label: 'SOS KHẨN CẤP',
                              color: const Color(0xFFEF4444),
                              icon: Icons.error_outline,
                              onTap: () {
                                print("Bấm SOS");
                              },
                            ),
                            const SizedBox(height: 20),
                            _buildActionButton(
                              label: 'XÁC NHẬN',
                              color: const Color(0xFF22C55E),
                              icon: Icons.check_circle_outline,
                              onTap: () {
                                print("Bấm Xác nhận");
                              },
                            ),
                            const SizedBox(height: 20),
                            _buildActionButton(
                              label: 'GỌI CON',
                              color: const Color(0xFFFF7F50),
                              icon: Icons.phone_outlined,
                              onTap: () {
                                print("Bấm Gọi con");
                              },
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
        splashColor: Colors.white.withOpacity(0.2), 
        child: Container(
          width: double.infinity,
          height: 140,
          alignment: Alignment.center,
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
      ),
    );
  }
}