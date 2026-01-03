import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:oldcare/models/user.model.dart';
import 'package:oldcare/viewmodels/schedulePill/schedulePill.viewmodel.dart';
import 'package:oldcare/viewmodels/schedule/schedule.viewmodel.dart';
import 'package:oldcare/services/schedulePhill/schedule_Pill.service.dart';
import 'package:oldcare/services/schedule/schedule.service.dart';
import 'package:oldcare/views/child-dashboard.dart';
import 'package:oldcare/views/history_page.dart';
import 'package:oldcare/views/setting_page.dart';
import 'package:provider/provider.dart';

class AddSchedule extends StatefulWidget {
  final bool isDarkMode;
  const AddSchedule({super.key, this.isDarkMode = false});

  @override
  State<AddSchedule> createState() => _AddScheduleState();
}

class _AddScheduleState extends State<AddSchedule> {
  late final SchedulePillViewModel _schedulePillViewModel;
  late final ScheduleViewModel _scheduleViewModel;
  final int _currentIndex = 1;
  @override
  void initState() {
    super.initState();
    _schedulePillViewModel = SchedulePillViewModel(SchedulePillService());
    _scheduleViewModel = ScheduleViewModel();
  }

  @override
  void dispose() {
    _scheduleViewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final scaffoldBg = Theme.of(context).scaffoldBackgroundColor;
    final textColor = isDark ? Colors.white : Colors.black87;
    final subTextColor = isDark ? Colors.grey[400] : Colors.grey[600];
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: _schedulePillViewModel),
        ChangeNotifierProvider.value(value: _scheduleViewModel),
      ],
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(isDark, textColor, subTextColor),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildMedicationForm(isDark, textColor),
                    const SizedBox(height: 20),
                    _buildAppointmentForm(isDark, textColor),
                  ],
                ),
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
        bottomNavigationBar: _buildBottomNav(isDark),
      ),
    );
  }

  // ================= HEADER =================
  Widget _buildHeader(bool isDark, Color? textColor, Color? subTextColor) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? Colors.blue.withOpacity(0.05) : Colors.transparent,
      ),
      padding: const EdgeInsets.only(top: 60, left: 16, right: 16, bottom: 24),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: isDark
                ? Colors.blue.withOpacity(0.3)
                : Colors.blue.withOpacity(0.1),
            child: Icon(
              Icons.person,
              color: isDark ? Colors.blue[200] : Colors.blue,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'An Tâm - Con',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text('Chăm sóc Cha Mẹ', style: TextStyle(fontSize: 13)),
              ],
            ),
          ),
          const Icon(Icons.notifications_none),
          const SizedBox(width: 12),
          const Icon(Icons.settings),
        ],
      ),
    );
  }

  // ================= MEDICATION FORM =================
  Widget _buildMedicationForm(isDark, textColor) {
    return Consumer<SchedulePillViewModel>(
      builder: (context, pillVM, child) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: _cardDecoration(isDark),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Tạo lịch uống thuốc mới',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              // Tên thuốc
              _buildTextField(
                'Tên thuốc',
                'Ví dụ: Thuốc huyết áp',
                controller: pillVM.medicineNameController,
              ),
              const SizedBox(height: 12),

              // Thời gian và Liều lượng
              Row(
                children: [
                  Expanded(
                    child: _buildTimePickerField(
                      'Thời gian',
                      pillVM.selectedTime != null
                          ? _formatTime(pillVM.selectedTime!)
                          : '08:00',
                      onTap: () => _selectTime(context, pillVM),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildTextField(
                      'Liều lượng',
                      '1 viên',
                      controller: pillVM.dosageController,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Tần suất
              _buildTextField(
                'Tần suất',
                'Hàng ngày',
                controller: pillVM.frequencyController,
              ),

              // Error message
              if (pillVM.errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    pillVM.errorMessage!,
                    style: const TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),

              const SizedBox(height: 12),

              // Buttons
              Row(
                children: [
                  Expanded(
                    child: _buildButton(
                      'Lưu lịch thuốc',
                      Colors.blue,
                      Colors.white,
                      isLoading: pillVM.isLoading,
                      onPress: () => _saveMedicationSchedule(context, pillVM),
                    ),
                  ),
                  const SizedBox(width: 12),
                  _buildButton(
                    'Hủy',
                    Colors.grey.shade300,
                    Colors.black,
                    onPress: () => pillVM.clearForm(),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  // ================= APPOINTMENT FORM =================
  Widget _buildAppointmentForm(isDark, textColor) {
    return Consumer<ScheduleViewModel>(
      builder: (context, scheduleVM, child) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: _cardDecoration(isDark),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Tạo lịch hẹn',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              // Tiêu đề
              _buildTextField(
                'Tiêu đề',
                'Ví dụ: Tái khám Tim mạch',
                controller: scheduleVM.titleController,
              ),
              const SizedBox(height: 12),

              // Ngày và Giờ
              Row(
                children: [
                  Expanded(
                    child: _buildDatePickerField(
                      'Ngày',
                      scheduleVM.formatDate(scheduleVM.selectedDate),
                      onTap: () => _selectDate(context, scheduleVM),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildTimePickerField(
                      'Giờ',
                      _formatTime(scheduleVM.selectedTime),
                      onTap: () =>
                          _selectTimeForAppointment(context, scheduleVM),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Ghi chú
              _buildTextField(
                'Ghi chú',
                'Địa điểm, bác sĩ, chuẩn bị...',
                controller: scheduleVM.noteController,
                maxLines: 3,
              ),

              // Error message
              if (scheduleVM.errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    scheduleVM.errorMessage!,
                    style: const TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),

              const SizedBox(height: 12),

              // Buttons
              Row(
                children: [
                  Expanded(
                    child: _buildButton(
                      'Lưu lịch hẹn',
                      Colors.blue,
                      Colors.white,
                      isLoading: scheduleVM.isLoading,
                      onPress: () => _saveAppointment(context, scheduleVM),
                    ),
                  ),
                  const SizedBox(width: 12),
                  _buildButton(
                    'Hủy',
                    Colors.grey.shade300,
                    Colors.black,
                    onPress: () => scheduleVM.clearForm(),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  // ================= ACTIONS =================
  Future<void> _saveMedicationSchedule(
    BuildContext context,
    SchedulePillViewModel vm,
  ) async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Vui lòng đăng nhập')));
      return;
    }

    final currentUser = User_App(
      uid: firebaseUser.uid,
      email: firebaseUser.email ?? '',
      role: '',
      name: '',
      phone: '',
      childId: '',
    );

    // Trong widget của bạn, khi nhấn nút Lưu:
    final success = await vm.saveSchedulePill(
      currentUser.uid, // Truyền parentId
      currentUser.childId, // Truyền childId
    );

    if (success) {
      Navigator.pop(context); // Đóng màn hình sau khi lưu thành công
    }

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lưu lịch uống thuốc thành công!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  Future<void> _saveAppointment(
    BuildContext context,
    ScheduleViewModel vm,
  ) async {
    final success = await vm.saveSchedule();

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lưu lịch hẹn thành công!'),
          backgroundColor: Colors.green,
        ),
      );
    } else if (!success && vm.errorMessage != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(vm.errorMessage!), backgroundColor: Colors.red),
      );
    }
  }

  // ================= DATE/TIME PICKERS =================
  Future<void> _selectDate(BuildContext context, ScheduleViewModel vm) async {
    final date = await showDatePicker(
      context: context,
      initialDate: vm.selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date != null) {
      vm.updateSelectedDate(date);
    }
  }

  Future<void> _selectTimeForAppointment(
    BuildContext context,
    ScheduleViewModel vm,
  ) async {
    final time = await showTimePicker(
      context: context,
      initialTime: vm.selectedTime,
    );
    if (time != null) {
      vm.updateSelectedTime(time);
    }
  }

  Future<void> _selectTime(
    BuildContext context,
    SchedulePillViewModel vm,
  ) async {
    final time = await showTimePicker(
      context: context,
      initialTime: vm.selectedTime ?? TimeOfDay.now(),
    );
    if (time != null) {
      vm.updateSelectedTime(time);
    }
  }

  // ================= HELPERS =================
  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  // ================= UI COMPONENTS =================
  BoxDecoration _cardDecoration(bool isDark) {
    return BoxDecoration(
      color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.grey.shade300),
      boxShadow: [
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
    required TextEditingController controller,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDatePickerField(
    String label,
    String value, {
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14)),
        const SizedBox(height: 6),
        InkWell(
          onTap: onTap,
          child: InputDecorator(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
              suffixIcon: const Icon(Icons.calendar_today, size: 20),
            ),
            child: Text(value),
          ),
        ),
      ],
    );
  }

  Widget _buildTimePickerField(
    String label,
    String value, {
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14)),
        const SizedBox(height: 6),
        InkWell(
          onTap: onTap,
          child: InputDecorator(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
              suffixIcon: const Icon(Icons.access_time, size: 20),
            ),
            child: Text(value),
          ),
        ),
      ],
    );
  }

  Widget _buildButton(
    String text,
    Color bg,
    Color textColor, {
    required VoidCallback onPress,
    bool isLoading = false,
  }) {
    return GestureDetector(
      onTap: isLoading ? null : onPress,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isLoading ? bg.withOpacity(0.6) : bg,
          borderRadius: BorderRadius.circular(8),
        ),
        child: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Text(
                text,
                style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
              ),
      ),
    );
  }

  Widget _buildBottomNav(bool isDark) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: isDark ? const Color(0xFF121212) : Colors.white,
      selectedItemColor: const Color(0xFF3B82F6),
      unselectedItemColor: Colors.grey,
      currentIndex: _currentIndex,
      onTap: _onBottomNavTapped,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: const Icon(Icons.dashboard),
          label: 'Tổng quan',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.add_circle_outline),
          label: 'Thêm lịch',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.history),
          label: 'Lịch sử',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Cài đặt',
        ),
      ],
    );
  }

  void _onBottomNavTapped(int index) {
    if (index == _currentIndex) return;

    Widget nextScreen;

    switch (index) {
      case 0:
        nextScreen = const ChildDashboard();
        break;
      case 1:
        nextScreen = const AddSchedule();
        break;
      case 2:
        nextScreen = const HistoryScreen();
        break;
      case 3:
        nextScreen = AnTamSettingApp(isDarkModeI: widget.isDarkMode);
        break;
      default:
        return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => nextScreen),
    );
  }
}
