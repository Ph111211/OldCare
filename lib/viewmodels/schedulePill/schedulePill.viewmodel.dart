import 'package:flutter/material.dart';
import 'package:oldcare/models/schedulePill.model.dart';
import 'package:oldcare/models/user.model.dart';
import 'package:oldcare/services/schedulePhill/schedule_Pill.service.dart';

class SchedulePillViewModel extends ChangeNotifier {
  final SchedulePillService _schedulePillService;

  SchedulePillViewModel(this._schedulePillService);

  // Controllers cho các trường nhập liệu
  final TextEditingController medicineNameController = TextEditingController();
  final TextEditingController dosageController = TextEditingController();
  final TextEditingController frequencyController = TextEditingController();

  // Dữ liệu form
  TimeOfDay? selectedTime;

  // Danh sách lịch uống thuốc
  List<SchedulePill> _schedulePills = [];
  List<SchedulePill> get schedulePills => _schedulePills;

  // Trạng thái loading
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Trạng thái lỗi
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // Trạng thái dialog (đang thêm mới hay chỉnh sửa)
  bool _isEditing = false;
  bool get isEditing => _isEditing;
  String? _editingSchedulePillId;

  // Parent và Child ID
  String? _currentParentId;
  String? _currentChildId;

  /// Load tất cả lịch uống thuốc
  Future<void> loadAllSchedulePills() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      _schedulePills = await _schedulePillService.getAllSchedulePills();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  /// Load lịch uống thuốc theo parentId
  Future<void> loadSchedulePillsByParentId(String parentId) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      _currentParentId = parentId;
      notifyListeners();

      _schedulePills = await _schedulePillService.getSchedulePillsByParentId(
        parentId,
      );

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  /// Load lịch uống thuốc theo childId
  Future<void> loadSchedulePillsByChildId(String childId) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      _currentChildId = childId;
      notifyListeners();

      _schedulePills = await _schedulePillService.getSchedulePillsByChildId(
        childId,
      );

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  /// Load lịch uống thuốc theo parentId và childId
  Future<void> loadSchedulePillsByParentAndChild(
    String parentId,
    String childId,
  ) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      _currentParentId = parentId;
      _currentChildId = childId;
      notifyListeners();

      _schedulePills = await _schedulePillService
          .getSchedulePillsByParentAndChild(parentId, childId);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  /// Lắng nghe thay đổi real-time theo parentId
  Stream<List<SchedulePill>> getSchedulePillsByParentIdStream(String parentId) {
    return _schedulePillService.getSchedulePillsByParentIdStream(parentId);
  }

  /// Lắng nghe thay đổi real-time theo childId
  Stream<List<SchedulePill>> getSchedulePillsByChildIdStream(String childId) {
    return _schedulePillService.getSchedulePillsByChildIdStream(childId);
  }

  /// Lắng nghe thay đổi real-time theo parentId và childId
  Stream<List<SchedulePill>> getSchedulePillsByParentAndChildStream(
    String parentId,
    String childId,
  ) {
    return _schedulePillService.getSchedulePillsByParentAndChildStream(
      parentId,
      childId,
    );
  }

  /// Chọn giờ uống thuốc
  void updateSelectedTime(TimeOfDay time) {
    selectedTime = time;
    notifyListeners();
  }

  /// Mở dialog để thêm lịch uống thuốc mới
  void openAddDialog() {
    _isEditing = false;
    _editingSchedulePillId = null;
    clearForm();
    selectedTime = TimeOfDay.now();
    notifyListeners();
  }

  /// Mở dialog để chỉnh sửa lịch uống thuốc
  void openEditDialog(String schedulePillId, SchedulePill schedulePill) {
    _isEditing = true;
    _editingSchedulePillId = schedulePillId;

    medicineNameController.text = schedulePill.medicineName;
    dosageController.text = schedulePill.dosage;
    frequencyController.text = schedulePill.frequency;

    // Parse time string (format: "8:00 AM")
    selectedTime = _parseTimeString(schedulePill.time);
    notifyListeners();
  }

  /// Validate form
  String? validateForm() {
    if (medicineNameController.text.trim().isEmpty) {
      return 'Vui lòng nhập tên thuốc';
    }
    if (selectedTime == null) {
      return 'Vui lòng chọn thời gian uống thuốc';
    }
    if (dosageController.text.trim().isEmpty) {
      return 'Vui lòng nhập liều lượng';
    }
    if (frequencyController.text.trim().isEmpty) {
      return 'Vui lòng nhập tần suất';
    }
    return null;
  }

  /// Tạo hoặc cập nhật lịch uống thuốc
  Future<bool> saveSchedulePill(String parentId, String childId) async {
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

      // Format time string
      final timeString = _formatTime(selectedTime!);

      final schedulePill = SchedulePill(
        id: _editingSchedulePillId ?? '',
        medicineName: medicineNameController.text.trim(),
        time: timeString,
        dosage: dosageController.text.trim(),
        frequency: frequencyController.text.trim(),
        parentId: parentId,
        childId: childId,
      );

      if (_isEditing && _editingSchedulePillId != null) {
        // Cập nhật
        await _schedulePillService.updateSchedulePill(
          _editingSchedulePillId!,
          schedulePill,
        );
      } else {
        // Tạo mới
        await _schedulePillService.createSchedulePill(schedulePill);
      }

      // Reload danh sách
      await loadSchedulePillsByParentAndChild(parentId, childId);

      _isLoading = false;
      clearForm();
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Lỗi khi lưu lịch uống thuốc: $e';
      notifyListeners();
      return false;
    }
  }

  /// Thêm lịch uống thuốc (method tương thích với code cũ)
  Future<bool> addSchedule({
    required User_App currentUser,
    required String medicineName,
    required String time,
    required String dosage,
    required String frequency,
  }) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      // Validate
      if (medicineName.trim().isEmpty) {
        _errorMessage = 'Vui lòng nhập tên thuốc';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      if (time.trim().isEmpty) {
        _errorMessage = 'Vui lòng chọn thời gian';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      if (dosage.trim().isEmpty) {
        _errorMessage = 'Vui lòng nhập liều lượng';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      if (frequency.trim().isEmpty) {
        _errorMessage = 'Vui lòng nhập tần suất';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      final schedulePill = SchedulePill(
        id: '',
        medicineName: medicineName.trim(),
        time: time.trim(),
        dosage: dosage.trim(),
        frequency: frequency.trim(),
        parentId: currentUser.uid,
        childId: currentUser.childId,
      );

      await _schedulePillService.createSchedulePill(schedulePill);

      _isLoading = false;
      clearForm();
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Lỗi khi thêm lịch uống thuốc: $e';
      notifyListeners();
      return false;
    }
  }

  /// Xóa lịch uống thuốc
  Future<bool> deleteSchedulePill(String id) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _schedulePillService.deleteSchedulePill(id);

      // Reload danh sách
      if (_currentParentId != null && _currentChildId != null) {
        await loadSchedulePillsByParentAndChild(
          _currentParentId!,
          _currentChildId!,
        );
      } else if (_currentParentId != null) {
        await loadSchedulePillsByParentId(_currentParentId!);
      } else if (_currentChildId != null) {
        await loadSchedulePillsByChildId(_currentChildId!);
      } else {
        await loadAllSchedulePills();
      }

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Lỗi khi xóa lịch uống thuốc: $e';
      notifyListeners();
      return false;
    }
  }

  /// Xóa nhiều lịch uống thuốc
  Future<bool> deleteMultipleSchedulePills(List<String> ids) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _schedulePillService.deleteMultipleSchedulePills(ids);

      // Reload danh sách
      if (_currentParentId != null && _currentChildId != null) {
        await loadSchedulePillsByParentAndChild(
          _currentParentId!,
          _currentChildId!,
        );
      }

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Lỗi khi xóa lịch uống thuốc: $e';
      notifyListeners();
      return false;
    }
  }

  /// Tìm kiếm lịch uống thuốc theo tên thuốc
  Future<void> searchSchedulePills(String keyword) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      if (keyword.trim().isEmpty) {
        if (_currentParentId != null && _currentChildId != null) {
          await loadSchedulePillsByParentAndChild(
            _currentParentId!,
            _currentChildId!,
          );
        } else {
          await loadAllSchedulePills();
        }
      } else {
        _schedulePills = await _schedulePillService
            .searchSchedulePillsByMedicineName(keyword);
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  /// Cập nhật thời gian uống thuốc
  Future<bool> updatePillTime(String id, TimeOfDay newTime) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final timeString = _formatTime(newTime);
      await _schedulePillService.updatePillTime(id, timeString);

      // Reload danh sách
      if (_currentParentId != null && _currentChildId != null) {
        await loadSchedulePillsByParentAndChild(
          _currentParentId!,
          _currentChildId!,
        );
      }

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Lỗi khi cập nhật thời gian: $e';
      notifyListeners();
      return false;
    }
  }

  /// Đếm số lịch uống thuốc
  Future<int> countSchedulePills(String parentId) async {
    try {
      return await _schedulePillService.countSchedulePillsByParentId(parentId);
    } catch (e) {
      return 0;
    }
  }

  /// Format time để hiển thị
  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  /// Parse time string thành TimeOfDay
  TimeOfDay _parseTimeString(String timeString) {
    try {
      final parts = timeString.split(' ');
      final hourMinute = parts[0].split(':');
      int hour = int.parse(hourMinute[0]);
      int minute = int.parse(hourMinute[1]);

      if (parts.length > 1 && parts[1].toUpperCase() == 'PM' && hour != 12) {
        hour += 12;
      } else if (parts.length > 1 &&
          parts[1].toUpperCase() == 'AM' &&
          hour == 12) {
        hour = 0;
      }

      return TimeOfDay(hour: hour, minute: minute);
    } catch (e) {
      return TimeOfDay.now();
    }
  }

  /// Xóa form
  void clearForm() {
    medicineNameController.clear();
    dosageController.clear();
    frequencyController.clear();
    selectedTime = null;
    _errorMessage = null;
  }

  /// Xóa error message
  void clearError() {
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
