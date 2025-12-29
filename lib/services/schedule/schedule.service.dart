import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:oldcare/models/schedule.model.dart';

class ScheduleService {
  Future<List<Schedule>> fetchSchedules() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('schedules')
        .get();
    return querySnapshot.docs
        .map((doc) => Schedule.fromFirestore(doc.id, doc.data()))
        .toList();
  }

  Future<void> addSchedule(Schedule schedule) async {
    await FirebaseFirestore.instance
        .collection('schedules')
        .add(schedule.toJson());
  }

  Future<void> deleteSchedule(String id) async {
    await FirebaseFirestore.instance.collection('schedules').doc(id).delete();
  }
}
