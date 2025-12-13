import 'package:flutter/material.dart';

void main() {
  runApp(const FigmaToCodeApp());
}

// --- 1. ROOT WIDGET (Quản lý Theme Sáng/Tối) ---
class FigmaToCodeApp extends StatefulWidget {
  const FigmaToCodeApp({super.key});

  @override
  State<FigmaToCodeApp> createState() => _FigmaToCodeAppState();
}

class _FigmaToCodeAppState extends State<FigmaToCodeApp> {
  // Biến quản lý trạng thái Sáng/Tối
  ThemeMode _themeMode = ThemeMode.light;

  void _toggleTheme(bool isOn) {
    setState(() {
      _themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      // Cấu hình màu cho chế độ Sáng
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF9FAFB),
        useMaterial3: true,
        fontFamily: 'Inter',
      ),
      // Cấu hình màu cho chế độ Tối
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF111827), // Màu nền tối thẫm
        useMaterial3: true,
        fontFamily: 'Inter',
      ),
      home: CITScreen(
        onThemeChanged: _toggleTheme,
        isDarkMode: _themeMode == ThemeMode.dark,
      ),
    );
  }
}

class CITScreen extends StatelessWidget {
  final Function(bool) onThemeChanged;
  final bool isDarkMode;

  const CITScreen({
    super.key,
    required this.onThemeChanged,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: CITContent(
          onThemeChanged: onThemeChanged,
          isDarkMode: isDarkMode,
        ),
      ),
      bottomNavigationBar: BottomNavBar(isDarkMode: isDarkMode),
    );
  }
}

// --- 2. BOTTOM NAV BAR ---
class BottomNavBar extends StatelessWidget {
  final bool isDarkMode;
  const BottomNavBar({super.key, required this.isDarkMode});

  Widget _buildBottomNavItem(String text, IconData icon, bool isSelected) {
    final Color selectedColor = const Color(0xFF2563EB);
    final Color unselectedColor = isDarkMode ? const Color(0xFF9CA3AF) : const Color(0xFF4B5563);
    final Color color = isSelected ? selectedColor : unselectedColor;

    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6),
        decoration: ShapeDecoration(
          color: isSelected 
              ? (isDarkMode ? const Color(0xFF1E3A8A) : const Color(0xFFEFF6FF)) 
              : Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 24, color: color),
            const SizedBox(height: 4),
            Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: color,
                fontSize: 11.5,
                fontWeight: FontWeight.w400,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF1F2937) : Colors.white,
        border: Border(top: BorderSide(width: 1, color: isDarkMode ? const Color(0xFF374151) : const Color(0xFFE5E7EB))),
        boxShadow: [
          BoxShadow(
            color: const Color(0x19000000),
            blurRadius: 15,
            offset: const Offset(0, 10),
            spreadRadius: -3,
          )
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildBottomNavItem('Tổng\nquan', Icons.dashboard_outlined, false),
              _buildBottomNavItem('Thêm\nlịch', Icons.calendar_month_outlined, false),
              _buildBottomNavItem('Lịch\nsử', Icons.history, false),
              _buildBottomNavItem('Cài\nđặt', Icons.settings_outlined, true),
            ],
          ),
        ),
      ),
    );
  }
}

// --- 3. NỘI DUNG CHÍNH ---
class CITContent extends StatefulWidget {
  final Function(bool) onThemeChanged;
  final bool isDarkMode;

  const CITContent({
    super.key,
    required this.onThemeChanged,
    required this.isDarkMode,
  });

  @override
  State<CITContent> createState() => _CITContentState();
}

class _CITContentState extends State<CITContent> {
  bool _isMedicineReminderOn = true; 
  bool _isEmergencyOn = true;
  bool _isDailyReportOn = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(), // Header đã được cập nhật logic màu
        const SizedBox(height: 16),
        _buildAccountBlock(),
        const SizedBox(height: 16),
        _buildNotificationBlock(),
        const SizedBox(height: 16),
        _buildInterfaceBlock(),    
        const SizedBox(height: 16),
        _buildSupportBlock(),
        const SizedBox(height: 16),
        _buildLogoutBlock(),
        const SizedBox(height: 32),
      ],
    );
  }

  // --- HEADER (CẬP NHẬT LOGIC TỐI MÀU TẠI ĐÂY) ---
  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      decoration: BoxDecoration(
        // Logic: Nếu Dark Mode -> Gradient Xám Đen, Ngược lại -> Gradient Xanh
        gradient: widget.isDarkMode 
            ? const LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Color(0xFF1F2937), Color(0xFF111827)], // Màu tối
              )
            : const LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)], // Màu xanh gốc
              ),
        boxShadow: [
          BoxShadow(
            color: widget.isDarkMode ? Colors.black45 : const Color(0x19000000), 
            blurRadius: 15, 
            offset: const Offset(0, 10)
          )
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.favorite, color: Colors.white, size: 24),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'An Tâm - Con',
                      style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Chăm sóc Cha Mẹ',
                      // Chỉnh màu chữ phụ nhạt hơn một chút khi ở Dark Mode cho dịu mắt
                      style: TextStyle(
                        color: widget.isDarkMode ? Colors.white70 : const Color(0xFFDBEAFE), 
                        fontSize: 13
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Row(
              children: [
                Stack(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(Icons.notifications_none, color: Colors.white, size: 26),
                    ),
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(color: Color(0xFFEF4444), shape: BoxShape.circle),
                      ),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.call, color: Colors.white, size: 24),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  // --- Khối Tài khoản ---
  Widget _buildAccountBlock() {
    return _buildCardContainer(
      children: [
        _buildCardHeader('Tài khoản', Icons.person_outline),
        Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(colors: [Color(0xFF3B82F6), Color(0xFF2563EB)]),
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: const Text('NV', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Nguyễn Văn A', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: _getTextColor())),
                      const Text('nguyenvana@email.com', style: TextStyle(color: Colors.grey, fontSize: 12)),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFF2563EB)),
                  borderRadius: BorderRadius.circular(8),
                ),
                alignment: Alignment.center,
                child: const Text('Chính sửa', style: TextStyle(color: Color(0xFF2563EB), fontWeight: FontWeight.w500)),
              )
            ],
          ),
        )
      ],
    );
  }

  // --- Khối Thông báo ---
  Widget _buildNotificationBlock() {
    return _buildCardContainer(
      children: [
        _buildCardHeader('Thông báo', Icons.notifications_outlined),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildSwitchRow(
                'Nhắc uống thuốc', 
                'Khi Cha/Mẹ bỏ lỡ', 
                _isMedicineReminderOn, 
                (newValue) {
                  setState(() {
                    _isMedicineReminderOn = newValue;
                  });
                }
              ),
              
              if (_isMedicineReminderOn) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: widget.isDarkMode ? const Color(0xFF1E3A8A).withOpacity(0.3) : const Color(0xFFEFF6FF), 
                    borderRadius: BorderRadius.circular(8)
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Thời gian thông báo:', style: TextStyle(fontWeight: FontWeight.w500, color: _getTextColor())),
                      const SizedBox(height: 12),
                      _buildTimeInput('Trước:', '15', 'phút'),
                      const SizedBox(height: 8),
                      _buildTimeInput('Sau:', '15', 'phút'),
                      const SizedBox(height: 8),
                      const Text('Để trống để chỉ nhắc đúng giờ', style: TextStyle(fontStyle: FontStyle.italic, fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                ),
              ],
              
              const SizedBox(height: 16),
              _buildSwitchRow('Khẩn cấp', 'Khi bấm SOS', _isEmergencyOn, (val) => setState(() => _isEmergencyOn = val)),
              const SizedBox(height: 16),
              _buildSwitchRow('Báo cáo hàng ngày', 'Tóm tắt mỗi tối', _isDailyReportOn, (val) => setState(() => _isDailyReportOn = val)),
            ],
          ),
        )
      ],
    );
  }

  // --- Khối Giao diện ---
  Widget _buildInterfaceBlock() {
    return _buildCardContainer(
      children: [
        _buildCardHeader('Giao diện', Icons.desktop_windows_outlined),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Chế độ tối', style: TextStyle(fontWeight: FontWeight.w600, color: _getTextColor())),
              _buildCustomSwitch(widget.isDarkMode, (value) {
                widget.onThemeChanged(value);
              }),
            ],
          ),
        )
      ],
    );
  }

  // --- Khối Hỗ trợ ---
  Widget _buildSupportBlock() {
    return _buildCardContainer(
      children: [
        _buildCardHeader('Hỗ trợ', Icons.access_time),
        _buildSupportItem(Icons.call_outlined, 'Hotline: 1900 xxxx', const Color(0xFFDBEAFE)),
        _buildSupportItem(Icons.email_outlined, 'support@antam.vn', const Color(0xFFDCFCE7)),
        _buildSupportItem(Icons.help_outline, 'Câu hỏi thường gặp', const Color(0xFFF3E8FF)),
        _buildSupportItem(Icons.menu_book_outlined, 'Hướng dẫn sử dụng', const Color(0xFFFFEDD5), isLast: true),
      ],
    );
  }

  // --- Nút Đăng xuất ---
  Widget _buildLogoutBlock() {
    return Container(
      width: 380,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: _getCardColor(),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _getBorderColor()),
        boxShadow: const [BoxShadow(color: Color(0x0C000000), blurRadius: 2, offset: Offset(0, 1))],
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.logout, color: Color(0xFFDC2626), size: 20),
          SizedBox(width: 8),
          Text('Đăng xuất', style: TextStyle(color: Color(0xFFDC2626), fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  // --- HELPER FUNCTIONS & WIDGETS ---

  Color _getCardColor() => widget.isDarkMode ? const Color(0xFF1F2937) : Colors.white;
  Color _getTextColor() => widget.isDarkMode ? Colors.white : const Color(0xFF111827);
  Color _getBorderColor() => widget.isDarkMode ? const Color(0xFF374151) : const Color(0xFFE5E7EB);

  Widget _buildCardContainer({required List<Widget> children}) {
    return Container(
      width: 380,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: _getCardColor(),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _getBorderColor()),
        boxShadow: const [BoxShadow(color: Color(0x0C000000), blurRadius: 2, offset: Offset(0, 1))],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildCardHeader(String title, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(width: 1, color: widget.isDarkMode ? const Color(0xFF374151) : const Color(0xFFF3F4F6))),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: widget.isDarkMode ? Colors.grey : const Color(0xFF4B5563)),
          const SizedBox(width: 8),
          Text(title, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: _getTextColor())),
        ],
      ),
    );
  }

  Widget _buildSwitchRow(String title, String subtitle, bool value, Function(bool) onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: _getTextColor())),
            Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          ],
        ),
        _buildCustomSwitch(value, onChanged),
      ],
    );
  }

  Widget _buildCustomSwitch(bool value, Function(bool) onChanged) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 48,
        height: 28,
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: value ? const Color(0xFF155DFC) : const Color(0xFFD1D5DC),
          borderRadius: BorderRadius.circular(20),
        ),
        alignment: value ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          width: 24,
          height: 24,
          decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
        ),
      ),
    );
  }

  Widget _buildTimeInput(String label, String time, String unit) {
    return Row(
      children: [
        SizedBox(width: 60, child: Text(label, style: const TextStyle(color: Colors.grey))),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: widget.isDarkMode ? const Color(0xFF374151) : Colors.white,
              border: Border.all(color: widget.isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(time, style: const TextStyle(color: Colors.grey)),
          ),
        ),
        const SizedBox(width: 12),
        Text(unit, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }

  Widget _buildSupportItem(IconData icon, String text, Color bgColor, {bool isLast = false}) {
    final Color iconBg = widget.isDarkMode ? bgColor.withOpacity(0.2) : bgColor;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        border: isLast ? null : Border(bottom: BorderSide(color: widget.isDarkMode ? const Color(0xFF374151) : const Color(0xFFF9FAFB))),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
            child: Icon(icon, size: 18, color: widget.isDarkMode ? Colors.white : const Color(0xFF2563EB)),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: TextStyle(fontWeight: FontWeight.w600, color: _getTextColor()))),
          const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
        ],
      ),
    );
  }
}