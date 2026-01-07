import 'package:cloud_firestore/cloud_firestore.dart';

class Schedule {
  final String title;
  final DateTime date;
  final String time;
  final String? note;
  final String? childId;
  // final String? location; // Thêm dòng này
  final DateTime createdAt;

  Schedule({
    required this.title,
    required this.date,
    required this.time,
    this.childId,
    this.note,
    // this.location, // Thêm dòng này
    required this.createdAt,
  });

  // Cập nhật hàm fromMap để đọc dữ liệu location từ Firebase
  factory Schedule.fromMap(Map<String, dynamic> map) {
    return Schedule(
      title: map['title'] ?? '',
      date: _convertToDateTime(map['date']),
      time: map['time'] ?? '',
      note: map['note'],
      childId: map['childId'] as String?,
      // location: map['location'], // Thêm dòng này
      createdAt: _convertToDateTime(map['createdAt']),
    );
  }

  // Cập nhật hàm toJson để lưu dữ liệu location lên Firebase
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'title': title,
      'date': date.toIso8601String(),
      'time': time,
      'createdAt': createdAt.toIso8601String(),
    };
    if (childId != null) map['childId'] = childId;
    if (note != null) map['note'] = note;
    return map;
  }

  // Hàm trợ giúp chuyển đổi ngày tháng (đã có từ bước trước)
  static DateTime _convertToDateTime(dynamic value) {
    if (value is Timestamp) return value.toDate();
    if (value is String) return DateTime.parse(value);
    return DateTime.now();
  }
}
