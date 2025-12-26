import 'package:cloud_firestore/cloud_firestore.dart';

class SchedulePill {
  final String id;
  final String medicineName;
  final String time; // HH:mm (08:00)
  final String dosage; // 1 viên
  final ScheduleFrequency frequency;
  final DateTime createdAt;

  SchedulePill({
    required this.id,
    required this.medicineName,
    required this.time,
    required this.dosage,
    required this.frequency,
    required this.createdAt,
  });

  /// Convert JSON → Schedule
  factory SchedulePill.fromJson(Map<String, dynamic> json) {
    return SchedulePill(
      id: json['id'] as String,
      medicineName: json['medicineName'] as String,
      time: json['time'] as String,
      dosage: json['dosage'] as String,
      frequency: ScheduleFrequencyExtension.fromString(json['frequency']),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  /// Convert Firestore Document → Schedule
  factory SchedulePill.fromFirestore(String id, Map<String, dynamic> data) {
    return SchedulePill(
      id: id,
      medicineName: data['medicineName'],
      time: data['time'],
      dosage: data['dosage'],
      frequency: ScheduleFrequencyExtension.fromString(data['frequency']),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  /// Convert Schedule → JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'medicineName': medicineName,
      'time': time,
      'dosage': dosage,
      'frequency': frequency.value,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

enum ScheduleFrequency { daily, weekly, custom }

extension ScheduleFrequencyExtension on ScheduleFrequency {
  String get value {
    switch (this) {
      case ScheduleFrequency.daily:
        return 'daily';
      case ScheduleFrequency.weekly:
        return 'weekly';
      case ScheduleFrequency.custom:
        return 'custom';
    }
  }

  static ScheduleFrequency fromString(String value) {
    switch (value) {
      case 'daily':
        return ScheduleFrequency.daily;
      case 'weekly':
        return ScheduleFrequency.weekly;
      case 'custom':
        return ScheduleFrequency.custom;
      default:
        return ScheduleFrequency.daily;
    }
  }

  /// Hiển thị UI
  String get label {
    switch (this) {
      case ScheduleFrequency.daily:
        return 'Hàng ngày';
      case ScheduleFrequency.weekly:
        return 'Hàng tuần';
      case ScheduleFrequency.custom:
        return 'Tùy chỉnh';
    }
  }
}
