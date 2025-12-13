import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'An Tâm Setting Screen',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto', 
        useMaterial3: true,
      ),
      home: const SettingScreen(), // Đặt màn hình Cài đặt làm màn hình chính
    );
  }
}

// --- MÀN HÌNH CÀI ĐẶT (SETTING SCREEN) ---
class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  // Màu chủ đạo
  final Color _primaryColor = const Color(0xFF2563EB);
  final Color _backgroundColor = const Color(0xFFF8FAFC);
  final Color _iconColor = const Color(0xFF94A3B8); // Màu icon xám nhạt
  final Color _borderColor = const Color(0xFFE2E8F0); // Đã thêm định nghĩa này

  // Trạng thái các switch
  bool _notificationEnabled = true; // Thông báo
  bool _medicineReminderEnabled = true; // Nhắc uống thuốc
  int _timeBefore = 15; // Thời gian trước
  int _timeAfter = 15; // Thời gian sau
  bool _emergencySOS = true; // Khẩn cấp
  bool _dailyReport = false; // Báo cáo hằng ngày
  bool _darkMode = false; // Chế độ tối (Giao diện)

  // Widget tiêu đề nhóm
  Widget _buildGroupTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.grey[700],
        ),
      ),
    );
  }

  // Widget Switch (Toggle)
  Widget _buildToggleRow({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
    String? subtitle,
    IconData? icon,
    bool showIcon = true,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (showIcon) 
            Icon(icon ?? Icons.notifications_none, color: _iconColor, size: 20),
          if (showIcon) const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black87),
                ),
                if (subtitle != null)
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 13, color: Colors.grey[500]),
                  ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.white,
            activeTrackColor: _primaryColor,
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: Colors.grey[300],
          ),
        ],
      ),
    );
  }

  // Widget cho mục Hỗ trợ (Icon + Text + Arrow)
  Widget _buildSupportItem({
    required String title,
    required String content,
    required Color iconBgColor,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: iconBgColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: iconBgColor, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                ),
                Text(
                  content,
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        ],
      ),
    );
  }


  // Widget chứa tất cả nội dung cài đặt bên trong thẻ trắng
  Widget _buildSettingCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      margin: const EdgeInsets.only(top: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      // --- APP BAR (THANH TRÊN) ---
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: _primaryColor,
        toolbarHeight: 80,
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.favorite, color: Colors.white, size: 18),
            ),
            const SizedBox(width: 8),
            const Text(
              'An Tâm - Con',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.white, size: 24),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.call, color: Colors.white, size: 24),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- 1. TÀI KHOẢN ---
            _buildGroupTitle('Tài khoản'),
            _buildSettingCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // Avatar placeholder
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: _primaryColor,
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Text(
                            'NV',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Nguyễn Văn A',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'nguyenvana@antam.com',
                            style:
                                TextStyle(fontSize: 13, color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Nút Chỉnh sửa
                  SizedBox(
                    width: double.infinity,
                    height: 40,
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: _primaryColor, width: 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        foregroundColor: _primaryColor,
                      ),
                      child: const Text('Chỉnh sửa',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  )
                ],
              ),
            ),

            // --- 2. THÔNG BÁO ---
            _buildGroupTitle('Thông báo'),
            _buildSettingCard(
              child: Column(
                children: [
                  // Nhắc uống thuốc
                  _buildToggleRow(
                    title: 'Nhắc uống thuốc',
                    subtitle: 'Khi Cha Mẹ bỏ lỡ',
                    value: _medicineReminderEnabled,
                    icon: Icons.notifications_none,
                    onChanged: (bool value) {
                      setState(() {
                        _medicineReminderEnabled = value;
                      });
                    },
                  ),
                  
                  // Chỉ hiển thị phần thời gian nếu Nhắc uống thuốc được bật
                  if (_medicineReminderEnabled)
                    Padding(
                      padding: const EdgeInsets.only(top: 10, left: 32),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              // Input "Trước"
                              const Text('Trước:', style: TextStyle(fontSize: 14, color: Colors.black87)),
                              const SizedBox(width: 8),
                              SizedBox(
                                width: 70,
                                child: _buildTimeInput(_timeBefore, (value) {
                                  setState(() => _timeBefore = value);
                                }),
                              ),
                              const SizedBox(width: 8),
                              const Text('phút', style: TextStyle(fontSize: 14, color: Colors.black87)),
                              
                              const SizedBox(width: 24),

                              // Input "Sau"
                              const Text('Sau:', style: TextStyle(fontSize: 14, color: Colors.black87)),
                              const SizedBox(width: 8),
                              SizedBox(
                                width: 70,
                                child: _buildTimeInput(_timeAfter, (value) {
                                  setState(() => _timeAfter = value);
                                }),
                              ),
                              const SizedBox(width: 8),
                              const Text('phút', style: TextStyle(fontSize: 14, color: Colors.black87)),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Chỉ hoạt động khi chế độ dùng giờ được bật',
                            style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                          ),
                        ],
                      ),
                    ),

                  const SizedBox(height: 16),
                  
                  // Khẩn cấp
                  _buildToggleRow(
                    title: 'Khẩn cấp',
                    subtitle: 'Khi bấm SOS',
                    value: _emergencySOS,
                    icon: Icons.warning_amber_rounded,
                    onChanged: (bool value) {
                      setState(() {
                        _emergencySOS = value;
                      });
                    },
                  ),
                  
                  // Báo cáo hằng ngày (không có icon bên trái)
                  _buildToggleRow(
                    title: 'Báo cáo hằng ngày',
                    subtitle: 'Tóm tắt mọi thứ',
                    value: _dailyReport,
                    icon: Icons.calendar_today_outlined,
                    showIcon: false,
                    onChanged: (bool value) {
                      setState(() {
                        _dailyReport = value;
                      });
                    },
                  ),
                ],
              ),
            ),

            // --- 3. GIAO DIỆN ---
            _buildGroupTitle('Giao diện'),
            _buildSettingCard(
              child: _buildToggleRow(
                title: 'Chế độ tối',
                subtitle: null,
                value: _darkMode,
                icon: Icons.brightness_6_outlined,
                showIcon: false, // Icon được đặt riêng trong thiết kế này
                onChanged: (bool value) {
                  setState(() {
                    _darkMode = value;
                  });
                },
              ),
            ),

            // --- 4. HỖ TRỢ ---
            _buildGroupTitle('Hỗ trợ'),
            _buildSettingCard(
              child: Column(
                children: [
                  _buildSupportItem(
                    title: 'Hotline:',
                    content: '1900 xxxx',
                    iconBgColor: Colors.green,
                    icon: Icons.phone_outlined,
                  ),
                  _buildSupportItem(
                    title: 'support@antam.vn',
                    content: '', // Không có nội dung phụ
                    iconBgColor: _primaryColor,
                    icon: Icons.email_outlined,
                  ),
                  _buildSupportItem(
                    title: 'Câu hỏi thường gặp',
                    content: '',
                    iconBgColor: Colors.red,
                    icon: Icons.help_outline,
                  ),
                  _buildSupportItem(
                    title: 'Hướng dẫn sử dụng',
                    content: '',
                    iconBgColor: Colors.orange,
                    icon: Icons.menu_book_outlined,
                  ),
                ],
              ),
            ),
            
            // --- ĐĂNG XUẤT ---
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 32.0),
              child: Center(
                child: TextButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.logout, color: Colors.red[600]),
                  label: Text(
                    'Đăng xuất',
                    style: TextStyle(
                      color: Colors.red[600],
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

      // --- BOTTOM NAVIGATION BAR (THANH DƯỚI) ---
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: _primaryColor,
        unselectedItemColor: Colors.grey,
        currentIndex: 3, // Đã sửa: Cài đặt là tab thứ 4 (chỉ số 3)
        items: [
          _buildBottomNavItem(Icons.home_outlined, 'Tổng quan'),
          _buildBottomNavItem(Icons.add_circle_outline, 'Thêm mới'),
          _buildBottomNavItem(Icons.history_toggle_off, 'Lịch sử'),
          _buildBottomNavItem(Icons.settings_outlined, 'Cài đặt'),
        ],
        onTap: (index) {
          // Xử lý chuyển tab
        },
      ),
    );
  }

  // Widget hỗ trợ cho BottomNavigationBar
  BottomNavigationBarItem _buildBottomNavItem(IconData icon, String label) {
    return BottomNavigationBarItem(
      icon: Padding(
        padding: const EdgeInsets.only(bottom: 2.0),
        child: Icon(icon),
      ),
      label: label,
    );
  }

  // Widget input thời gian nhỏ
  Widget _buildTimeInput(int value, ValueChanged<int> onChanged) {
    return TextFormField(
      initialValue: value.toString(),
      textAlign: TextAlign.center,
      keyboardType: TextInputType.number,
      onChanged: (text) {
        final int? parsedValue = int.tryParse(text);
        if (parsedValue != null) {
          onChanged(parsedValue);
        }
      },
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        isDense: true,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: _borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: _primaryColor),
        ),
        fillColor: Colors.white,
        filled: true,
      ),
    );
  }
}