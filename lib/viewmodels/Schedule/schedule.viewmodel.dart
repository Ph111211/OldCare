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

  // Danh sách lịch hẹn (cho các tác vụ cần List tĩnh như Search)
  List<Schedule> _schedules = [];
  List<Schedule> get schedules => _schedules;

  /// Format date để hiển thị (DD/MM/YYYY)
  String formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  // Trạng thái giao diện
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool _isEditing = false;
  bool get isEditing => _isEditing;
  String? _editingScheduleId;

  ScheduleViewModel() {
    // Không nhất thiết phải gọi loadSchedules() nếu view sử dụng getSchedulesStream()
  }

  // --- LUỒNG DỮ LIỆU (READ) ---

  /// Lắng nghe thay đổi real-time từ Firestore
  /// Sử dụng StreamBuilder ở View để đạt hiệu quả cao nhất
  Stream<List<Schedule>> getSchedulesStream() {
    return _scheduleService.getSchedulesStream();
  }

  /// Load danh sách tĩnh (Dùng cho các trường hợp không cần real-time)
  Future<void> loadSchedules() async {
    _setLoading(true);
    try {
      _schedules = await _scheduleService.getAllSchedules();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  // --- LOGIC NGHIỆP VỤ (CREATE / UPDATE / DELETE) ---

  /// Lưu lịch hẹn (Tự động phân biệt Thêm mới hoặc Cập nhật)
  Future<bool> saveSchedule() async {
    if (titleController.text.trim().isEmpty) {
      _errorMessage = 'Vui lòng nhập tiêu đề';
      notifyListeners();
      return false;
    }

    _setLoading(true);
    try {
      // Hợp nhất ngày và giờ đã chọn thành một đối tượng DateTime duy nhất
      final finalDateTime = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        selectedTime.hour,
        selectedTime.minute,
      );

      final schedule = Schedule(
        title: titleController.text.trim(),
        date: finalDateTime,
        time: _formatTimeOfDay(selectedTime),
        note: noteController.text.trim().isEmpty
            ? null
            : noteController.text.trim(),
        createdAt: DateTime.now(),
      );

      if (_isEditing && _editingScheduleId != null) {
        await _scheduleService.updateSchedule(_editingScheduleId!, schedule);
      } else {
        await _scheduleService.createSchedule(schedule);
      }

      clearForm();
      return true;
    } catch (e) {
      _errorMessage = 'Lỗi hệ thống: $e';
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Xóa lịch hẹn theo ID
  Future<void> deleteSchedule(String id) async {
    try {
      await _scheduleService.deleteSchedule(id);
    } catch (e) {
      _errorMessage = 'Không thể xóa lịch hẹn: $e';
      notifyListeners();
    }
  }

  // --- QUẢN LÝ TRẠNG THÁI FORM ---

  void openAddDialog() {
    _isEditing = false;
    _editingScheduleId = null;
    clearForm();
    selectedDate = DateTime.now();
    selectedTime = TimeOfDay.now();
    notifyListeners();
  }

  void openEditDialog(String scheduleId, Schedule schedule) {
    _isEditing = true;
    _editingScheduleId = scheduleId;

    titleController.text = schedule.title;
    noteController.text = schedule.note ?? '';
    selectedDate = schedule.date;
    selectedTime = TimeOfDay.fromDateTime(schedule.date);

    _errorMessage = null;
    notifyListeners();
  }

  void updateSelectedDate(DateTime date) {
    selectedDate = date;
    notifyListeners();
  }

  void updateSelectedTime(TimeOfDay time) {
    selectedTime = time;
    notifyListeners();
  }

  // --- HELPER METHODS ---

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  String _formatTimeOfDay(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  void clearForm() {
    titleController.clear();
    noteController.clear();
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
