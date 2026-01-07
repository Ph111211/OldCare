import 'package:cloud_firestore/cloud_firestore.dart';

class SchedulePill {
  final String id;
  final String medicineName;
  final String time; // Lưu dạng chuỗi hiển thị (vd: "08:00 AM")
  final String dosage;
  final String frequency;
  final String parentId;
  final String childId;
  final String? status; // Trạng thái: "Completed", "Upcoming", "Missed"
  final DateTime? createdAt;

  SchedulePill({
    required this.id,
    required this.medicineName,
    required this.time,
    required this.dosage,
    required this.frequency,
    required this.parentId,
    required this.childId,
    this.status,
    this.createdAt,
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
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
    };
  }

  /// Hàm hỗ trợ chuyển đổi kiểu dữ liệu ngày tháng an toàn
  static DateTime? _convertToDateTime(dynamic value) {
    if (value is Timestamp) return value.toDate();
    if (value is String) return DateTime.tryParse(value);
    return null;
  }
}
