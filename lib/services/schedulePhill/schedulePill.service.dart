import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:oldcare/models/schedulePill.model.dart';

class SchedulePillService {
  // Example method to fetch schedules from Firestore
  Future<List<SchedulePill>> fetchSchedules() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('schedulePills')
        .get();
    return querySnapshot.docs
        .map((doc) => SchedulePill.fromFirestore(doc.id, doc.data()))
        .toList();
  }

  Future<void> addSchedulePill(SchedulePill schedulePill) async {
    await FirebaseFirestore.instance
        .collection('schedulePills')
        .add(schedulePill.toJson());
  }

  Future<void> deleteSchedulePill(String id) async {
    await FirebaseFirestore.instance
        .collection('schedulePills')
        .doc(id)
        .delete();
  }
}
