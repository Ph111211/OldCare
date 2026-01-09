import 'package:cloud_firestore/cloud_firestore.dart';

class SchedulePill {
  final String id;
  final String medicineName;
  final String time; // Lưu dạng chuỗi hiển thị (vd: "08:00 AM")
  final String dosage;
  final String frequency;
  final String parentId;
  final String childId;
  final String lastTakenDate;
  final String? status; // Trạng thái: "Completed", "Upcoming", "Missed"
  final DateTime? createdAt;
  final DateTime? updatedAt;
  // final DateTime? lastTakenDate;

  SchedulePill({
    required this.id,
    required this.medicineName,
    required this.time,
    required this.dosage,
    required this.frequency,
    required this.parentId,
    required this.childId,
    required this.lastTakenDate,
    this.status,
    this.createdAt,
    this.updatedAt,
    // this.lastTakenDate,
  });

  /// Factory chuyển đổi từ Firestore Map sang Object
  factory SchedulePill.fromMap(Map<String, dynamic> map, String id) {
    return SchedulePill(
      id: id,
      medicineName: map['medicineName'] ?? '',
      time: map['time'] ?? '',
      dosage: map['dosage'] ?? '',
      frequency: map['frequency'] ?? '',
      parentId: map['parentId'] ?? '',
      lastTakenDate: map['lastTakenDate'] ?? 'today',
      // lastTakenDate: map['lastTakenDate'],
      childId: map['childId'] ?? '',
      status: map['status'], // Phải có trường này để hiển thị Badge
    );
  }

  /// Chuyển đổi Object sang Map để lưu lên Firestore
  Map<String, dynamic> toJson() {
    return {
      'medicineName': medicineName,
      'time': time,
      'dosage': dosage,
      'frequency': frequency,
      'parentId': parentId,
      'childId': childId,
      'status': status ?? 'Upcoming', // Mặc định là chưa đến giờ
      'lastTakenDate': lastTakenDate,

      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
      'updatedAt': updatedAt ?? FieldValue.serverTimestamp(),
    };
  }

  /// Hàm hỗ trợ chuyển đổi kiểu dữ liệu ngày tháng an toàn
  static DateTime? _convertToDateTime(dynamic value) {
    if (value is Timestamp) return value.toDate();
    if (value is String) return DateTime.tryParse(value);
    return null;
  }

  DateTime _parseTimeStringToToday(String timeString, String frequency) {
    try {
      final parts = timeString.split(' '); // Ví dụ: ["08:00", "AM"]
      final hm = parts[0].split(':');
      int hour = int.parse(hm[0]);
      int minute = int.parse(hm[1]);

      if (parts.length > 1) {
        if (parts[1].toUpperCase() == 'PM' && hour != 12) hour += 12;
        if (parts[1].toUpperCase() == 'AM' && hour == 12) hour = 0;
      }

      DateTime now = DateTime.now();

      // Nếu tần suất là hàng ngày, chúng ta luôn lấy ngày-tháng-năm hiện tại
      if (frequency.contains("Hàng ngày") ||
          frequency.toLowerCase() == "daily") {
        return DateTime(now.year, now.month, now.day, hour, minute);
      }

      // Nếu không phải hàng ngày, bạn có thể dựa vào createdAt để tính toán (logic tùy chọn)
      return DateTime(now.year, now.month, now.day, hour, minute);
    } catch (e) {
      return DateTime.now().add(const Duration(days: 1)); // Tránh crash
    }
  }
}
