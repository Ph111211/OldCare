import 'package:cloud_firestore/cloud_firestore.dart';

class SchedulePill {
  final String id;
  final String medicineName;
  final String time;
  final String dosage;
  final String frequency;
  final String parentId;
  final String childId;

  SchedulePill({
    required this.id,
    required this.medicineName,
    required this.time,
    required this.dosage,
    required this.frequency,
    required this.parentId,
    required this.childId,
  });

  factory SchedulePill.fromMap(String id, Map<String, dynamic> map) {
    return SchedulePill(
      id: id,
      medicineName: map['medicineName'],
      time: map['time'],
      dosage: map['dosage'],
      frequency: map['frequency'],
      parentId: map['parentId'],
      childId: map['childId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'medicineName': medicineName,
      'time': time,
      'dosage': dosage,
      'frequency': frequency,
      'parentId': parentId,
      'childId': childId,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}
