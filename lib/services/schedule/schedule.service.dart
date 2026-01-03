import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:oldcare/models/schedule.model.dart';

class ScheduleService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'schedule_appointments';

  // Reference đến collection
  CollectionReference get _schedulesRef => _firestore.collection(_collection);

  /// CREATE - Tạo lịch hẹn mới
  Future<String> createSchedule(Schedule schedule) async {
    try {
      DocumentReference docRef = await _schedulesRef.add(schedule.toJson());
      return docRef.id;
    } catch (e) {
      throw Exception('Lỗi khi tạo lịch hẹn: $e');
    }
  }

  /// READ - Lấy tất cả lịch hẹn
  Future<List<Schedule>> getAllSchedules() async {
    try {
      QuerySnapshot snapshot = await _schedulesRef
          .orderBy('date', descending: false)
          .get();

      return snapshot.docs
          .map(
            (doc) =>
                Schedule.fromMap(doc.id, doc.data() as Map<String, dynamic>),
          )
          .toList();
    } catch (e) {
      throw Exception('Lỗi khi lấy danh sách lịch hẹn: $e');
    }
  }

  /// READ - Lấy lịch hẹn theo ID
  Future<Schedule?> getScheduleById(String id) async {
    try {
      DocumentSnapshot doc = await _schedulesRef.doc(id).get();

      if (doc.exists) {
        return Schedule.fromFirestore(
          doc.id,
          doc.data() as Map<String, dynamic>,
        );
      }
      return null;
    } catch (e) {
      throw Exception('Lỗi khi lấy lịch hẹn: $e');
    }
  }

  /// READ - Lấy lịch hẹn theo ngày
  Future<List<Schedule>> getSchedulesByDate(DateTime date) async {
    try {
      // Lấy thời gian bắt đầu và kết thúc của ngày
      DateTime startOfDay = DateTime(date.year, date.month, date.day);
      DateTime endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);

      QuerySnapshot snapshot = await _schedulesRef
          .where('date', isGreaterThanOrEqualTo: startOfDay)
          .where('date', isLessThanOrEqualTo: endOfDay)
          .orderBy('date')
          .get();

      return snapshot.docs
          .map(
            (doc) => Schedule.fromFirestore(
              doc.id,
              doc.data() as Map<String, dynamic>,
            ),
          )
          .toList();
    } catch (e) {
      throw Exception('Lỗi khi lấy lịch hẹn theo ngày: $e');
    }
  }

  /// READ - Lấy lịch hẹn trong khoảng thời gian
  Future<List<Schedule>> getSchedulesByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      QuerySnapshot snapshot = await _schedulesRef
          .where('date', isGreaterThanOrEqualTo: startDate)
          .where('date', isLessThanOrEqualTo: endDate)
          .orderBy('date')
          .get();

      return snapshot.docs
          .map(
            (doc) => Schedule.fromFirestore(
              doc.id,
              doc.data() as Map<String, dynamic>,
            ),
          )
          .toList();
    } catch (e) {
      throw Exception('Lỗi khi lấy lịch hẹn theo khoảng thời gian: $e');
    }
  }

  /// READ - Stream lấy tất cả lịch hẹn (real-time)
  Stream<List<Schedule>> getSchedulesStream() {
    return _schedulesRef
        .orderBy('date', descending: false)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => Schedule.fromFirestore(
                  doc.id,
                  doc.data() as Map<String, dynamic>,
                ),
              )
              .toList(),
        );
  }

  /// READ - Stream lấy lịch hẹn theo ngày (real-time)
  Stream<List<Schedule>> getSchedulesByDateStream(DateTime date) {
    DateTime startOfDay = DateTime(date.year, date.month, date.day);
    DateTime endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);

    return _schedulesRef
        .where('date', isGreaterThanOrEqualTo: startOfDay)
        .where('date', isLessThanOrEqualTo: endOfDay)
        .orderBy('date')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => Schedule.fromFirestore(
                  doc.id,
                  doc.data() as Map<String, dynamic>,
                ),
              )
              .toList(),
        );
  }

  /// UPDATE - Cập nhật lịch hẹn
  Future<void> updateSchedule(String id, Schedule schedule) async {
    try {
      await _schedulesRef.doc(id).update(schedule.toJson());
    } catch (e) {
      throw Exception('Lỗi khi cập nhật lịch hẹn: $e');
    }
  }

  /// UPDATE - Cập nhật một số trường cụ thể
  Future<void> updateScheduleFields(
    String id,
    Map<String, dynamic> fields,
  ) async {
    try {
      await _schedulesRef.doc(id).update(fields);
    } catch (e) {
      throw Exception('Lỗi khi cập nhật lịch hẹn: $e');
    }
  }

  /// DELETE - Xóa lịch hẹn
  Future<void> deleteSchedule(String id) async {
    try {
      await _schedulesRef.doc(id).delete();
    } catch (e) {
      throw Exception('Lỗi khi xóa lịch hẹn: $e');
    }
  }

  /// DELETE - Xóa nhiều lịch hẹn
  Future<void> deleteMultipleSchedules(List<String> ids) async {
    try {
      WriteBatch batch = _firestore.batch();

      for (String id in ids) {
        batch.delete(_schedulesRef.doc(id));
      }

      await batch.commit();
    } catch (e) {
      throw Exception('Lỗi khi xóa nhiều lịch hẹn: $e');
    }
  }

  /// DELETE - Xóa lịch hẹn cũ (trước ngày cụ thể)
  Future<void> deleteOldSchedules(DateTime beforeDate) async {
    try {
      QuerySnapshot snapshot = await _schedulesRef
          .where('date', isLessThan: beforeDate)
          .get();

      WriteBatch batch = _firestore.batch();

      for (var doc in snapshot.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();
    } catch (e) {
      throw Exception('Lỗi khi xóa lịch hẹn cũ: $e');
    }
  }

  /// SEARCH - Tìm kiếm lịch hẹn theo tiêu đề
  Future<List<Schedule>> searchSchedulesByTitle(String keyword) async {
    try {
      QuerySnapshot snapshot = await _schedulesRef
          .orderBy('title')
          .startAt([keyword])
          .endAt(['$keyword\uf8ff'])
          .get();

      return snapshot.docs
          .map(
            (doc) => Schedule.fromFirestore(
              doc.id,
              doc.data() as Map<String, dynamic>,
            ),
          )
          .toList();
    } catch (e) {
      throw Exception('Lỗi khi tìm kiếm lịch hẹn: $e');
    }
  }
}
