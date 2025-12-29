import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:oldcare/models/user.model.dart';
import 'package:oldcare/viewmodels/schedulePill/schedulePill.viewmodel.dart';
import 'package:oldcare/viewmodels/schedule/schedule.viewmodel.dart';
import 'package:oldcare/services/schedulePhill/schedule_Pill.service.dart';
import 'package:oldcare/services/schedule/schedule.service.dart';
import 'package:provider/provider.dart';

class AddSchedule extends StatefulWidget {
  const AddSchedule({super.key});

  @override
  State<AddSchedule> createState() => _AddScheduleState();
}

class _AddScheduleState extends State<AddSchedule> {
  late final SchedulePillViewModel _schedulePillViewModel;
  late final ScheduleViewModel _scheduleViewModel;

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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: _schedulePillViewModel),
        ChangeNotifierProvider.value(value: _scheduleViewModel),
      ],
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildMedicationForm(),
                    const SizedBox(height: 20),
                    _buildAppointmentForm(),
                  ],
                ),
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
        bottomNavigationBar: _buildBottomNav(),
      ),
    );
  }

  // ================= HEADER =================
  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 60, left: 16, right: 16, bottom: 24),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: Colors.blue.withOpacity(0.2),
            child: const Icon(Icons.person, color: Colors.white),
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
  Widget _buildMedicationForm() {
    return Consumer<SchedulePillViewModel>(
      builder: (context, pillVM, child) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: _cardDecoration(),
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
  Widget _buildAppointmentForm() {
    return Consumer<ScheduleViewModel>(
      builder: (context, scheduleVM, child) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: _cardDecoration(),
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

    final success = await vm.addSchedule(
      currentUser: currentUser,
      medicineName: vm.medicineNameController.text,
      time: vm.selectedTime != null ? _formatTime(vm.selectedTime!) : '',
      dosage: vm.dosageController.text,
      frequency: vm.frequencyController.text,
    );

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
  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
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

  Widget _buildBottomNav() {
    return BottomNavigationBar(
      currentIndex: 1,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard),
          label: 'Tổng quan',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add_circle),
          label: 'Thêm lịch',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Lịch sử'),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Cài đặt'),
      ],
    );
  }
}
