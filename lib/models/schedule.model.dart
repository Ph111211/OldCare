import 'package:cloud_firestore/cloud_firestore.dart';
class Schedule {
  final String id;
  final String title;        // Tiêu đề lịch hẹn
  final DateTime date;       // Ngày (11/15/2025)
  final String time;         // Giờ (09:00)
  final String? note;        // Ghi chú
  final DateTime createdAt;

  Schedule({
    required this.id,
    required this.title,
    required this.date,
    required this.time,
    this.note,
    required this.createdAt,
  });

  /// JSON -> Schedule
  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
      id: json['id'] as String,
      title: json['title'] as String,
      date: DateTime.parse(json['date']),
      time: json['time'] as String,
      note: json['note'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  /// Schedule -> JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'date': date.toIso8601String(),
      'time': time,
      'note': note,
      'createdAt': createdAt.toIso8601String(),
    };
  }
  factory Schedule.fromFirestore(
  String id,
  Map<String, dynamic> data,
) {
  return Schedule(
    id: id,
    title: data['title'],
    date: (data['date'] as Timestamp).toDate(),
    time: data['time'],
    note: data['note'],
    createdAt: (data['createdAt'] as Timestamp).toDate(),
  );
}

}
