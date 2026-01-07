import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:oldcare/models/schedulePill.model.dart';
import 'package:oldcare/services/schedulePhill/schedule_Pill.service.dart';

class SchedulePillViewModel extends ChangeNotifier {
  final SchedulePillService _schedulePillService;

  SchedulePillViewModel(this._schedulePillService);

  // --- CONTROLLERS & FORM DATA ---
  final TextEditingController medicineNameController = TextEditingController();
  final TextEditingController dosageController = TextEditingController();
  final TextEditingController frequencyController = TextEditingController();
  TimeOfDay? selectedTime;

  // --- STATE MANAGEMENT ---
  final List<SchedulePill> _schedulePills = [];
  List<SchedulePill> get schedulePills => _schedulePills;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool _isEditing = false;
  bool get isEditing => _isEditing;
  String? _editingSchedulePillId;

  String? _currentParentId;
  String? _currentChildId;

  // --- READ METHODS (STREAMS) ---

  /// Lắng nghe thay đổi real-time theo parentId (Dùng cho Dashboard)
  Future<Stream<List<SchedulePill>>> getSchedulePillsByParentIdStream() async {
    // _currentParentId = parentId;
    final auth = FirebaseAuth.instance;
    final firestore = FirebaseFirestore.instance;
    final String uid = auth.currentUser!.uid;
    final doc = await firestore.collection('users').doc(uid).get();
    final String? childId = doc.data()!['child_id'];
    print(uid);
    return _schedulePillService.getSchedulePillsByChildIdStream(childId!);
  }

  Future<Stream<List<SchedulePill>>> getSchedulePillsByChildIdStream(
    String currentId,
  ) async {
    return _schedulePillService.getSchedulePillsByChildIdStream(currentId);
  }

  /// Lắng nghe thay đổi real-time theo childId
  Stream<List<SchedulePill>> getSchedulePillsByCurrentChildStream() {
    // 1. Lấy user hiện tại từ FirebaseAuth
    final user = FirebaseAuth.instance.currentUser;

    // 2. Kiểm tra nếu user đã đăng nhập thì lấy UID, nếu chưa thì trả về Stream rỗng
    if (user != null) {
      final String uid = user.uid; // Đây chính là UID bạn cần
      return _schedulePillService.getSchedulePillsByChildIdStream(uid);
    } else {
      // Trả về một Stream rỗng nếu không có user để tránh crash ứng dụng
      return Stream.value([]);
    }
  }

  // --- WRITE METHODS (SAVE / UPDATE / DELETE) ---

  /// Tạo hoặc cập nhật lịch uống thuốc
  Future<bool> saveSchedulePill(String childId, String parentId) async {
    final error = validateForm();
    if (error != null) {
      _errorMessage = error;
      notifyListeners();
      return false;
    }

    _setLoading(true);
    try {
      final timeString = _formatTime(selectedTime!);

      final schedulePill = SchedulePill(
        id: _editingSchedulePillId ?? '',
        medicineName: medicineNameController.text.trim(),
        time: timeString,
        dosage: dosageController.text.trim(),
        frequency: frequencyController.text.trim(),
        parentId: parentId,
        childId: childId,
        // Khi tạo mới, mặc định trạng thái là Upcoming
        status: _isEditing ? null : "Upcoming",
      );

      if (_isEditing && _editingSchedulePillId != null) {
        await _schedulePillService.updateSchedulePill(
          _editingSchedulePillId!,
          schedulePill,
        );
      } else {
        await _schedulePillService.createSchedulePill(schedulePill);
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

  /// Xác nhận đã uống thuốc (Cập nhật trạng thái thành Completed)
  /// Giúp Badge chuyển sang màu xanh trên Dashboard
  Future<void> confirmPillTaken(String id) async {
    try {
      await _schedulePillService.updatePillStatus(id, "Completed");
      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Không thể xác nhận: $e';
      notifyListeners();
    }
  }

  /// Xóa lịch uống thuốc
  Future<bool> deleteSchedulePill(String id) async {
    _setLoading(true);
    try {
      await _schedulePillService.deleteSchedulePill(id);
      return true;
    } catch (e) {
      _errorMessage = 'Lỗi khi xóa: $e';
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // --- FORM HELPERS ---

  void openAddDialog() {
    _isEditing = false;
    _editingSchedulePillId = null;
    clearForm();
    selectedTime = TimeOfDay.now();
    notifyListeners();
  }

  void openEditDialog(String schedulePillId, SchedulePill pill) {
    _isEditing = true;
    _editingSchedulePillId = schedulePillId;
    medicineNameController.text = pill.medicineName;
    dosageController.text = pill.dosage;
    frequencyController.text = pill.frequency;
    selectedTime = _parseTimeString(pill.time);
    notifyListeners();
  }

  String? validateForm() {
    if (medicineNameController.text.trim().isEmpty) {
      return 'Vui lòng nhập tên thuốc';
    }
    if (selectedTime == null) return 'Vui lòng chọn thời gian';
    if (dosageController.text.trim().isEmpty) return 'Vui lòng nhập liều lượng';
    return null;
  }

  void updateSelectedTime(TimeOfDay time) {
    selectedTime = time;
    notifyListeners();
  }

  // --- UTILITIES ---

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  TimeOfDay _parseTimeString(String timeString) {
    try {
      final parts = timeString.split(' ');
      final hourMinute = parts[0].split(':');
      int hour = int.parse(hourMinute[0]);
      int minute = int.parse(hourMinute[1]);

      if (parts.length > 1 && parts[1].toUpperCase() == 'PM' && hour != 12) {
        hour += 12;
      }
      if (parts.length > 1 && parts[1].toUpperCase() == 'AM' && hour == 12) {
        hour = 0;
      }

      return TimeOfDay(hour: hour, minute: minute);
    } catch (e) {
      return TimeOfDay.now();
    }
  }

  void clearForm() {
    medicineNameController.clear();
    dosageController.clear();
    frequencyController.clear();
    selectedTime = null;
    _errorMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    medicineNameController.dispose();
    dosageController.dispose();
    frequencyController.dispose();
    super.dispose();
  }
}
