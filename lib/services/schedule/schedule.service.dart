import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:oldcare/models/schedule.model.dart';

class ScheduleService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'schedule_appointments';

  // Reference đến collection
  CollectionReference<Map<String, dynamic>> get _schedulesRef =>
      _firestore.collection(_collection);

  /// CREATE - Tạo lịch hẹn mới
  Future<String> createSchedule(Schedule schedule) async {
    try {
      // Chuyển đổi Schedule sang Map để lưu lên Firestore
      DocumentReference docRef = await _schedulesRef.add(schedule.toJson());
      return docRef.id;
    } catch (e) {
      throw Exception('Lỗi khi tạo lịch hẹn: $e');
    }
  }

  /// READ - Lấy tất cả lịch hẹn (Sử dụng fromMap an toàn)
  Future<List<Schedule>> getAllSchedules() async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await _schedulesRef
          .orderBy('date', descending: false)
          .get();

      return snapshot.docs.map((doc) => Schedule.fromMap(doc.data())).toList();
    } catch (e) {
      throw Exception('Lỗi khi lấy danh sách lịch hẹn: $e');
    }
  }

  /// READ - Stream lấy tất cả lịch hẹn (Real-time & xử lý lỗi subtype)
  Stream<List<Schedule>> getSchedulesStream() {
    return _schedulesRef.orderBy('date', descending: false).snapshots().map((
      snapshot,
    ) {
      return snapshot.docs.map((doc) => Schedule.fromMap(doc.data())).toList();
    });
  }

  /// READ - Lấy lịch hẹn theo ngày
  Future<List<Schedule>> getSchedulesByDate(DateTime date) async {
    try {
      DateTime startOfDay = DateTime(date.year, date.month, date.day);
      DateTime endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);

      QuerySnapshot<Map<String, dynamic>> snapshot = await _schedulesRef
          .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
          .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endOfDay))
          .orderBy('date')
          .get();

      return snapshot.docs.map((doc) => Schedule.fromMap(doc.data())).toList();
    } catch (e) {
      throw Exception('Lỗi khi lấy lịch hẹn theo ngày: $e');
    }
  }

  /// READ - Stream lấy lịch hẹn theo ngày (Real-time)
  Stream<List<Schedule>> getSchedulesByDateStream(DateTime date) {
    DateTime startOfDay = DateTime(date.year, date.month, date.day);
    DateTime endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);

    return _schedulesRef
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
        .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endOfDay))
        .orderBy('date')
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => Schedule.fromMap(doc.data())).toList(),
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

  /// DELETE - Xóa lịch hẹn
  Future<void> deleteSchedule(String id) async {
    try {
      await _schedulesRef.doc(id).delete();
    } catch (e) {
      throw Exception('Lỗi khi xóa lịch hẹn: $e');
    }
  }

  /// SEARCH - Tìm kiếm lịch hẹn theo tiêu đề
  Future<List<Schedule>> searchSchedulesByTitle(String keyword) async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await _schedulesRef
          .orderBy('title')
          .startAt([keyword])
          .endAt(['$keyword\uf8ff'])
          .get();

      return snapshot.docs.map((doc) => Schedule.fromMap(doc.data())).toList();
    } catch (e) {
      throw Exception('Lỗi khi tìm kiếm lịch hẹn: $e');
    }
  }
}
