import 'package:cloud_firestore/cloud_firestore.dart';

class Schedule {
  final String title; // Tiêu đề lịch hẹn
  final DateTime date; // Ngày (11/15/2025)
  final String time; // Giờ (09:00)
  final String? note; // Ghi chú
  final DateTime createdAt;

  Schedule({
    required this.title,
    required this.date,
    required this.time,
    this.note,
    required this.createdAt,
  });

  /// JSON -> Schedule
  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
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
      'title': title,
      'date': date.toIso8601String(),
      'time': time,
      'note': note,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Schedule.fromFirestore(String id, Map<String, dynamic> data) {
    return Schedule(
      title: data['title'],
      date: (data['date'] as Timestamp).toDate(),
      time: data['time'],
      note: data['note'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }
  factory Schedule.fromMap(String id, Map<String, dynamic> map) {
    return Schedule(
      title: map['title'],
      date: (map['date'] as Timestamp).toDate(),
      time: map['time'],
      note: map['note'],
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }
}
