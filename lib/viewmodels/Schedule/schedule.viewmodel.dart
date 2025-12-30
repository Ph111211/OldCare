import 'package:flutter/material.dart';
import 'package:oldcare/models/schedule.model.dart';
import 'package:oldcare/services/schedule/schedule.service.dart';

class ScheduleViewModel extends ChangeNotifier {
  final ScheduleService _scheduleService = ScheduleService();

  // Controllers cho các trường nhập liệu
  final TextEditingController titleController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  // Dữ liệu form
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  // Danh sách lịch hẹn
  List<Schedule> _schedules = [];
  List<Schedule> get schedules => _schedules;

  // Trạng thái loading
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Trạng thái lỗi
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // Trạng thái dialog (đang thêm mới hay chỉnh sửa)
  bool _isEditing = false;
  bool get isEditing => _isEditing;
  String? _editingScheduleId;

  ScheduleViewModel() {
    loadSchedules();
  }

  /// Load tất cả lịch hẹn
  Future<void> loadSchedules() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      _schedules = await _scheduleService.getAllSchedules();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  /// Load lịch hẹn theo ngày
  Future<void> loadSchedulesByDate(DateTime date) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      _schedules = await _scheduleService.getSchedulesByDate(date);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  /// Lắng nghe thay đổi real-time
  Stream<List<Schedule>> getSchedulesStream() {
    return _scheduleService.getSchedulesStream();
  }

  /// Chọn ngày
  void updateSelectedDate(DateTime date) {
    selectedDate = date;
    notifyListeners();
  }

  /// Chọn giờ
  void updateSelectedTime(TimeOfDay time) {
    selectedTime = time;
    notifyListeners();
  }

  /// Mở dialog để thêm lịch hẹn mới
  void openAddDialog() {
    _isEditing = false;
    _editingScheduleId = null;
    clearForm();
    selectedDate = DateTime.now();
    selectedTime = TimeOfDay.now();
    notifyListeners();
  }

  /// Mở dialog để chỉnh sửa lịch hẹn
  void openEditDialog(String scheduleId, Schedule schedule) {
    _isEditing = true;
    _editingScheduleId = scheduleId;

    titleController.text = schedule.title;
    noteController.text = schedule.note ?? '';
    selectedDate = schedule.date;

    // Parse time string (format: "09:00 AM")
    final timeParts = schedule.time.split(' ');
    final hourMinute = timeParts[0].split(':');
    int hour = int.parse(hourMinute[0]);
    int minute = int.parse(hourMinute[1]);

    if (timeParts.length > 1 && timeParts[1] == 'PM' && hour != 12) {
      hour += 12;
    } else if (timeParts.length > 1 && timeParts[1] == 'AM' && hour == 12) {
      hour = 0;
    }

    selectedTime = TimeOfDay(hour: hour, minute: minute);
    notifyListeners();
  }

  /// Validate form
  String? validateForm() {
    if (titleController.text.trim().isEmpty) {
      return 'Vui lòng nhập tiêu đề';
    }
    return null;
  }

  /// Tạo hoặc cập nhật lịch hẹn
  Future<bool> saveSchedule() async {
    // Validate
    final error = validateForm();
    if (error != null) {
      _errorMessage = error;
      notifyListeners();
      return false;
    }

    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      // Tạo datetime với ngày và giờ đã chọn
      final scheduleDateTime = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        selectedTime.hour,
        selectedTime.minute,
      );

      // Format time string
      final timeString = _formatTime(selectedTime);

      final schedule = Schedule(
        title: titleController.text.trim(),
        date: scheduleDateTime,
        time: timeString,
        note: noteController.text.trim().isEmpty
            ? null
            : noteController.text.trim(),
        createdAt: DateTime.now(),
      );

      if (_isEditing && _editingScheduleId != null) {
        // Cập nhật
        await _scheduleService.updateSchedule(_editingScheduleId!, schedule);
      } else {
        // Tạo mới
        await _scheduleService.createSchedule(schedule);
      }

      // Reload danh sách
      await loadSchedules();

      _isLoading = false;
      clearForm();
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Lỗi khi lưu lịch hẹn: $e';
      notifyListeners();
      return false;
    }
  }

  /// Xóa lịch hẹn
  Future<bool> deleteSchedule(String id) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _scheduleService.deleteSchedule(id);
      await loadSchedules();

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Lỗi khi xóa lịch hẹn: $e';
      notifyListeners();
      return false;
    }
  }

  /// Xóa nhiều lịch hẹn
  Future<bool> deleteMultipleSchedules(List<String> ids) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _scheduleService.deleteMultipleSchedules(ids);
      await loadSchedules();

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Lỗi khi xóa lịch hẹn: $e';
      notifyListeners();
      return false;
    }
  }

  /// Tìm kiếm lịch hẹn
  Future<void> searchSchedules(String keyword) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      if (keyword.trim().isEmpty) {
        await loadSchedules();
      } else {
        _schedules = await _scheduleService.searchSchedulesByTitle(keyword);
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  /// Format time để hiển thị
  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  /// Format date để hiển thị
  String formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  /// Xóa form
  void clearForm() {
    titleController.clear();
    noteController.clear();
    _errorMessage = null;
  }

  /// Xóa error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    titleController.dispose();
    noteController.dispose();
    super.dispose();
  }
}
