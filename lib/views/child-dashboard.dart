import 'package:flutter/material.dart';
import 'package:oldcare/services/notification/notification_service.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/Schedule/schedule.viewmodel.dart';
import '../../viewmodels/schedulePill/schedulePill.viewmodel.dart';
import '../../models/schedulePill.model.dart';
import '../views/add_schedule.dart';
import '../views/setting_page.dart';
import '../views/history_page.dart';

class ChildDashboard extends StatefulWidget {
  final bool isDarkMode;
  const ChildDashboard({super.key, this.isDarkMode = false});

  @override
  State<ChildDashboard> createState() => _ChildDashBoardState();
}

class _ChildDashBoardState extends State<ChildDashboard> {
  // 1. Chuyển ViewModel thành biến late để khởi tạo trong initState
  late ScheduleViewModel scheduleViewModel;
  final int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    scheduleViewModel = ScheduleViewModel();
    // Lắng nghe SOS Alerts sau khi khung hình đầu tiên được dựng
    WidgetsBinding.instance.addPostFrameCallback((_) {
      NotificationService().listenToSOSAlerts(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final pillVM = Provider.of<SchedulePillViewModel>(context);
    final bool isDark = widget.isDarkMode;

    final backgroundColor = isDark
        ? const Color(0xFF111827)
        : const Color(0xFFF9FAFB);
    final cardColor = isDark ? const Color(0xFF1F2937) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black87;
    final subTextColor = isDark ? Colors.white60 : Colors.grey.shade600;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          StreamBuilder<List<dynamic>>(
            stream: scheduleViewModel.getSchedulesStream(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              final allSchedules = snapshot.data ?? [];

              return _buildMainScrollContent(
                isDark: isDark,
                content: [
                  _buildAlertCard(isDark),
                  const SizedBox(height: 24),
                  _buildStatGrid(allSchedules.length, isDark),
                  const SizedBox(height: 24),

                  // LỊCH UỐNG THUỐC
                  StreamBuilder<List<SchedulePill>>(
                    stream: pillVM.getSchedulePillsByCurrentChildStream(),
                    builder: (context, pillSnapshot) {
                      final pills = pillSnapshot.data ?? [];
                      return _buildMedicationSchedule(
                        pills,
                        pillVM,
                        isDark,
                        cardColor,
                        textColor,
                        subTextColor,
                      );
                    },
                  ),

                  const SizedBox(height: 24),

                  // LỊCH HẸN BÁC SĨ
                  _buildAppointmentList(
                    allSchedules,
                    isDark,
                    cardColor,
                    textColor,
                    subTextColor,
                  ),
                ],
              );
            },
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildBottomNav(isDark),
          ),
        ],
      ),
    );
  }

  // --- WIDGET THỐNG KÊ ---
  Widget _buildStatGrid(int count, bool isDark) {
    return Row(
      children: [
        _statItem(
          count.toString(),
          "Lịch hẹn",
          isDark ? const Color(0xFF1E3A8A) : const Color(0xFFEFF6FF),
          isDark ? Colors.blue[100]! : const Color(0xFF1E3A8A),
        ),
        const SizedBox(width: 12),
        _statItem(
          "2",
          "Đơn thuốc",
          isDark ? const Color(0xFF064E3B) : const Color(0xFFECFDF5),
          isDark ? Colors.green[100]! : const Color(0xFF064E3B),
        ),
      ],
    );
  }

  Widget _statItem(String value, String label, Color bg, Color textColor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            Text(
              label,
              style: TextStyle(fontSize: 13, color: textColor.withOpacity(0.8)),
            ),
          ],
        ),
      ),
    );
  }

  // --- LỊCH UỐNG THUỐC ---
  Widget _buildMedicationSchedule(
    List<SchedulePill> pills,
    SchedulePillViewModel vm,
    bool isDark,
    Color cardColor,
    Color textColor,
    Color subTextColor,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.white10 : Colors.grey.shade100,
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Lịch uống thuốc hôm nay",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/see_all_medication');
                  },
                  child: const Text("Xem tất cả"),
                ),
              ],
            ),
          ),
          Divider(
            height: 1,
            color: isDark ? Colors.white10 : Colors.grey.shade100,
          ),
          if (pills.isEmpty)
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Text(
                "Không có lịch uống thuốc nào",
                style: TextStyle(color: subTextColor),
              ),
            )
          else
            ...pills.map(
              (pill) => _buildMedicationItem(
                pill,
                vm,
                isDark,
                textColor,
                subTextColor,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMedicationItem(
    SchedulePill pill,
    SchedulePillViewModel vm,
    bool isDark,
    Color textColor,
    Color subTextColor,
  ) {
    bool isDone = pill.status == "Completed";
    Color statusBg = isDone ? const Color(0xFFE8F5E9) : const Color(0xFFFFF8E1);
    Color statusText = isDone
        ? const Color(0xFF2E7D32)
        : const Color(0xFFF57F17);

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      title: Text(
        pill.medicineName,
        style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
      ),
      subtitle: Text(
        "${pill.time} • ${pill.dosage}",
        style: TextStyle(color: subTextColor),
      ),
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: statusBg,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          isDone ? "Đã uống" : "Chưa uống",
          style: TextStyle(
            color: statusText,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      onTap: () {
        if (isDone) return;
        // 2. Sửa lỗi Undefined 'notice': Dùng trực tiếp dữ liệu từ pill
        vm.confirmPillTaken(pill.id, frequency: pill.frequency);
      },
    );
  }

  // --- LỊCH HẸN BÁC SĨ ---
  Widget _buildAppointmentList(
    List<dynamic> schedules,
    bool isDark,
    Color cardColor,
    Color textColor,
    Color subTextColor,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.white10 : Colors.grey.shade100,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_month,
                  color: isDark ? Colors.blue[300] : const Color(0xFF2563EB),
                ),
                const SizedBox(width: 8),
                Text(
                  "Lịch hẹn bác sĩ",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 1,
            color: isDark ? Colors.white10 : Colors.grey.shade100,
          ),
          if (schedules.isEmpty)
            Padding(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: Text(
                  "Không có lịch hẹn nào",
                  style: TextStyle(color: subTextColor),
                ),
              ),
            )
          else
            ...schedules.map(
              (item) => ListTile(
                leading: Icon(
                  Icons.medical_services,
                  color: isDark ? Colors.blue[300] : Colors.blue,
                ),
                title: Text(
                  item.title,
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  "${item.time}\n${item.note ?? ''}",
                  style: TextStyle(color: subTextColor),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMainScrollContent({
    required List<Widget> content,
    required bool isDark,
  }) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildHeader(isDark),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(children: content),
          ),
          const SizedBox(height: 120),
        ],
      ),
    );
  }

  Widget _buildHeader(bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 60, left: 20, right: 20, bottom: 30),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF111827), const Color(0xFF1F2937)]
              : [const Color(0xFF2563EB), const Color(0xFF1D4ED8)],
        ),
      ),
      child: const Row(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: Colors.white24,
            child: Icon(Icons.person, color: Colors.white, size: 30),
          ),
          SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'An Tâm - Con',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Hệ thống giám sát sức khỏe',
                style: TextStyle(color: Colors.white70, fontSize: 13),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAlertCard(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.orange.withOpacity(0.1)
            : const Color(0xFFFFF7ED),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark
              ? Colors.orange.withOpacity(0.3)
              : Colors.orange.shade200,
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.lightbulb_outline, color: Colors.orange),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              "Đừng quên nhắc Cha Mẹ uống thuốc đúng giờ!",
              style: TextStyle(
                fontSize: 14,
                color: isDark ? Colors.orange[200] : Colors.orange[900],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav(bool isDark) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: isDark ? const Color(0xFF111827) : Colors.white,
      selectedItemColor: const Color(0xFF3B82F6),
      unselectedItemColor: isDark ? Colors.white30 : Colors.grey,
      currentIndex: _currentIndex,
      onTap: (index) {
        if (index == 0) return;
        Widget next;
        switch (index) {
          case 1:
            next = const AddSchedule();
            break;
          case 2:
            next = const HistoryScreen();
            break; // Đảm bảo tên class đúng
          default:
            next = AnTamSettingApp(isDarkModeI: widget.isDarkMode);
            break;
        }
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => next),
        );
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_rounded),
          label: 'Trang chủ',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add_box_rounded),
          label: 'Thêm lịch',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.history_rounded),
          label: 'Lịch sử',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings_rounded),
          label: 'Cài đặt',
        ),
      ],
    );
  }
}
