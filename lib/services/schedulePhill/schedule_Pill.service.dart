import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:oldcare/models/schedulePill.model.dart';

class SchedulePillService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'schedule_pills';

  // Reference đến collection
  CollectionReference get _schedulePillsRef =>
      _firestore.collection(_collection);

  /// CREATE - Tạo lịch uống thuốc mới
  Future<String> createSchedulePill(SchedulePill schedulePill) async {
    try {
      DocumentReference docRef = await _schedulePillsRef.add(
        schedulePill.toMap(),
      );
      return docRef.id;
    } catch (e) {
      throw Exception('Lỗi khi tạo lịch uống thuốc: $e');
    }
  }

  /// READ - Lấy tất cả lịch uống thuốc
  Future<List<SchedulePill>> getAllSchedulePills() async {
    try {
      QuerySnapshot snapshot = await _schedulePillsRef
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map(
            (doc) => SchedulePill.fromMap(
              doc.id,
              doc.data() as Map<String, dynamic>,
            ),
          )
          .toList();
    } catch (e) {
      throw Exception('Lỗi khi lấy danh sách lịch uống thuốc: $e');
    }
  }

  /// READ - Lấy lịch uống thuốc theo ID
  Future<SchedulePill?> getSchedulePillById(String id) async {
    try {
      DocumentSnapshot doc = await _schedulePillsRef.doc(id).get();

      if (doc.exists) {
        return SchedulePill.fromMap(doc.id, doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      throw Exception('Lỗi khi lấy lịch uống thuốc: $e');
    }
  }

  /// READ - Lấy lịch uống thuốc theo parentId
  Future<List<SchedulePill>> getSchedulePillsByParentId(String parentId) async {
    try {
      QuerySnapshot snapshot = await _schedulePillsRef
          .where('parentId', isEqualTo: parentId)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map(
            (doc) => SchedulePill.fromMap(
              doc.id,
              doc.data() as Map<String, dynamic>,
            ),
          )
          .toList();
    } catch (e) {
      throw Exception('Lỗi khi lấy lịch uống thuốc theo parentId: $e');
    }
  }

  /// READ - Lấy lịch uống thuốc theo childId
  Future<List<SchedulePill>> getSchedulePillsByChildId(String childId) async {
    try {
      QuerySnapshot snapshot = await _schedulePillsRef
          .where('childId', isEqualTo: childId)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map(
            (doc) => SchedulePill.fromMap(
              doc.id,
              doc.data() as Map<String, dynamic>,
            ),
          )
          .toList();
    } catch (e) {
      throw Exception('Lỗi khi lấy lịch uống thuốc theo childId: $e');
    }
  }

  /// READ - Lấy lịch uống thuốc theo parentId và childId
  Future<List<SchedulePill>> getSchedulePillsByParentAndChild(
    String parentId,
    String childId,
  ) async {
    try {
      QuerySnapshot snapshot = await _schedulePillsRef
          .where('parentId', isEqualTo: parentId)
          .where('childId', isEqualTo: childId)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map(
            (doc) => SchedulePill.fromMap(
              doc.id,
              doc.data() as Map<String, dynamic>,
            ),
          )
          .toList();
    } catch (e) {
      throw Exception('Lỗi khi lấy lịch uống thuốc: $e');
    }
  }

  /// READ - Lấy lịch uống thuốc theo tên thuốc
  Future<List<SchedulePill>> getSchedulePillsByMedicineName(
    String medicineName,
  ) async {
    try {
      QuerySnapshot snapshot = await _schedulePillsRef
          .where('medicineName', isEqualTo: medicineName)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map(
            (doc) => SchedulePill.fromMap(
              doc.id,
              doc.data() as Map<String, dynamic>,
            ),
          )
          .toList();
    } catch (e) {
      throw Exception('Lỗi khi tìm kiếm lịch uống thuốc: $e');
    }
  }

  /// READ - Lấy lịch uống thuốc theo giờ
  Future<List<SchedulePill>> getSchedulePillsByTime(String time) async {
    try {
      QuerySnapshot snapshot = await _schedulePillsRef
          .where('time', isEqualTo: time)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map(
            (doc) => SchedulePill.fromMap(
              doc.id,
              doc.data() as Map<String, dynamic>,
            ),
          )
          .toList();
    } catch (e) {
      throw Exception('Lỗi khi lấy lịch uống thuốc theo giờ: $e');
    }
  }

  /// READ - Stream lấy tất cả lịch uống thuốc (real-time)
  Stream<List<SchedulePill>> getSchedulePillsStream() {
    return _schedulePillsRef
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => SchedulePill.fromMap(
                  doc.id,
                  doc.data() as Map<String, dynamic>,
                ),
              )
              .toList(),
        );
  }

  /// READ - Stream lấy lịch uống thuốc theo parentId (real-time)
  Stream<List<SchedulePill>> getSchedulePillsByParentIdStream(String parentId) {
    return _schedulePillsRef
        .where('parentId', isEqualTo: parentId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => SchedulePill.fromMap(
                  doc.id,
                  doc.data() as Map<String, dynamic>,
                ),
              )
              .toList(),
        );
  }

  /// READ - Stream lấy lịch uống thuốc theo childId (real-time)
  Stream<List<SchedulePill>> getSchedulePillsByChildIdStream(String childId) {
    return _schedulePillsRef
        .where('childId', isEqualTo: childId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => SchedulePill.fromMap(
                  doc.id,
                  doc.data() as Map<String, dynamic>,
                ),
              )
              .toList(),
        );
  }

  /// READ - Stream lấy lịch uống thuốc theo parentId và childId (real-time)
  Stream<List<SchedulePill>> getSchedulePillsByParentAndChildStream(
    String parentId,
    String childId,
  ) {
    return _schedulePillsRef
        .where('parentId', isEqualTo: parentId)
        .where('childId', isEqualTo: childId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => SchedulePill.fromMap(
                  doc.id,
                  doc.data() as Map<String, dynamic>,
                ),
              )
              .toList(),
        );
  }

  /// UPDATE - Cập nhật lịch uống thuốc
  Future<void> updateSchedulePill(String id, SchedulePill schedulePill) async {
    try {
      await _schedulePillsRef.doc(id).update(schedulePill.toMap());
    } catch (e) {
      throw Exception('Lỗi khi cập nhật lịch uống thuốc: $e');
    }
  }

  /// UPDATE - Cập nhật một số trường cụ thể
  Future<void> updateSchedulePillFields(
    String id,
    Map<String, dynamic> fields,
  ) async {
    try {
      await _schedulePillsRef.doc(id).update(fields);
    } catch (e) {
      throw Exception('Lỗi khi cập nhật lịch uống thuốc: $e');
    }
  }

  /// UPDATE - Cập nhật thời gian uống thuốc
  Future<void> updatePillTime(String id, String newTime) async {
    try {
      await _schedulePillsRef.doc(id).update({'time': newTime});
    } catch (e) {
      throw Exception('Lỗi khi cập nhật thời gian: $e');
    }
  }

  /// UPDATE - Cập nhật liều lượng
  Future<void> updatePillDosage(String id, String newDosage) async {
    try {
      await _schedulePillsRef.doc(id).update({'dosage': newDosage});
    } catch (e) {
      throw Exception('Lỗi khi cập nhật liều lượng: $e');
    }
  }

  /// DELETE - Xóa lịch uống thuốc
  Future<void> deleteSchedulePill(String id) async {
    try {
      await _schedulePillsRef.doc(id).delete();
    } catch (e) {
      throw Exception('Lỗi khi xóa lịch uống thuốc: $e');
    }
  }

  /// DELETE - Xóa nhiều lịch uống thuốc
  Future<void> deleteMultipleSchedulePills(List<String> ids) async {
    try {
      WriteBatch batch = _firestore.batch();

      for (String id in ids) {
        batch.delete(_schedulePillsRef.doc(id));
      }

      await batch.commit();
    } catch (e) {
      throw Exception('Lỗi khi xóa nhiều lịch uống thuốc: $e');
    }
  }

  /// DELETE - Xóa tất cả lịch uống thuốc của một parent
  Future<void> deleteSchedulePillsByParentId(String parentId) async {
    try {
      QuerySnapshot snapshot = await _schedulePillsRef
          .where('parentId', isEqualTo: parentId)
          .get();

      WriteBatch batch = _firestore.batch();

      for (var doc in snapshot.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();
    } catch (e) {
      throw Exception('Lỗi khi xóa lịch uống thuốc: $e');
    }
  }

  /// DELETE - Xóa tất cả lịch uống thuốc của một child
  Future<void> deleteSchedulePillsByChildId(String childId) async {
    try {
      QuerySnapshot snapshot = await _schedulePillsRef
          .where('childId', isEqualTo: childId)
          .get();

      WriteBatch batch = _firestore.batch();

      for (var doc in snapshot.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();
    } catch (e) {
      throw Exception('Lỗi khi xóa lịch uống thuốc: $e');
    }
  }

  /// SEARCH - Tìm kiếm lịch uống thuốc theo tên thuốc (partial match)
  Future<List<SchedulePill>> searchSchedulePillsByMedicineName(
    String keyword,
  ) async {
    try {
      QuerySnapshot snapshot = await _schedulePillsRef
          .orderBy('medicineName')
          .startAt([keyword])
          .endAt([keyword + '\uf8ff'])
          .get();

      return snapshot.docs
          .map(
            (doc) => SchedulePill.fromMap(
              doc.id,
              doc.data() as Map<String, dynamic>,
            ),
          )
          .toList();
    } catch (e) {
      throw Exception('Lỗi khi tìm kiếm lịch uống thuốc: $e');
    }
  }

  /// UTILITY - Đếm số lịch uống thuốc của parent
  Future<int> countSchedulePillsByParentId(String parentId) async {
    try {
      QuerySnapshot snapshot = await _schedulePillsRef
          .where('parentId', isEqualTo: parentId)
          .get();

      return snapshot.docs.length;
    } catch (e) {
      throw Exception('Lỗi khi đếm lịch uống thuốc: $e');
    }
  }

  /// UTILITY - Đếm số lịch uống thuốc của child
  Future<int> countSchedulePillsByChildId(String childId) async {
    try {
      QuerySnapshot snapshot = await _schedulePillsRef
          .where('childId', isEqualTo: childId)
          .get();

      return snapshot.docs.length;
    } catch (e) {
      throw Exception('Lỗi khi đếm lịch uống thuốc: $e');
    }
  }
}
