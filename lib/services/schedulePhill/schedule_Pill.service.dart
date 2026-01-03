import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:oldcare/models/schedulePill.model.dart';
import 'package:oldcare/viewmodels/schedulePill/schedulePill.viewmodel.dart';

class SchedulePillService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'schedule_pills';

  // Reference đến collection với kiểu Map cụ thể để tránh lỗi subtype
  CollectionReference<Map<String, dynamic>> get _schedulePillsRef =>
      _firestore.collection(_collection);

  /// CREATE - Tạo lịch uống thuốc mới
  Future<String> createSchedulePill(SchedulePill schedulePill) async {
    try {
      // Sử dụng toJson() đã cập nhật để bao gồm trường 'status'
      DocumentReference docRef = await _schedulePillsRef.add(
        schedulePill.toJson(),
      );
      return docRef.id;
    } catch (e) {
      throw Exception('Lỗi khi tạo lịch uống thuốc: $e');
    }
  }

  Future<void> _saveMedicationSchedule(
    BuildContext context,
    SchedulePillViewModel vm,
  ) async {
    // 1. Lấy thông tin User hiện tại từ Firebase
    final firebaseUser = FirebaseAuth.instance.currentUser;

    if (firebaseUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng đăng nhập để thực hiện thao tác này'),
        ),
      );
      return;
    }

    // 2. Xác định các ID
    // Theo yêu cầu của bạn: childId = ID của người dùng hiện tại (người con)
    final String currentChildId = firebaseUser.uid;

    // Lưu ý: parentId thường là ID của người già được quản lý.
    // Nếu bạn chưa có logic chọn người già, tạm thời để trống hoặc dùng chính ID người con nếu tự quản lý.
    // Ở đây tôi giả định bạn đang gán lịch cho một Parent cụ thể nào đó.
    final String targetParentId = "ID_NGUOI_GIA_CAN_QUAN_LY";

    // 3. Gọi hàm save với childId là ID user hiện tại
    final success = await vm.saveSchedulePill(
      targetParentId, // parentId
      currentChildId, // childId (Gán bằng ID User hiện tại)
    );

    if (success && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lưu lịch uống thuốc thành công!'),
          backgroundColor: Colors.green,
        ),
      );
      // Bạn có thể xóa form sau khi lưu thành công
      vm.clearForm();
    }
  }

  /// READ - Stream lấy lịch uống thuốc theo parentId (Cập nhật thời gian thực cho Dashboard)
  Stream<List<SchedulePill>> getSchedulePillsByParentIdStream(String parentId) {
    return _schedulePillsRef
        .where('parentId', isEqualTo: parentId)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => SchedulePill.fromMap(doc.data(), doc.id))
              .toList(),
        );
  }

  /// UPDATE - Cập nhật trạng thái thuốc Real-time (Đã uống / Bỏ lỡ)
  /// Giúp hiển thị đúng các Badge màu sắc trên giao diện
  Future<void> updatePillStatus(String id, String status) async {
    try {
      await _schedulePillsRef.doc(id).update({
        'status': status,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Lỗi khi cập nhật trạng thái thuốc: $e');
    }
  }

  /// READ - Lấy lịch uống thuốc theo ID
  Future<SchedulePill?> getSchedulePillById(String id) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> doc = await _schedulePillsRef
          .doc(id)
          .get();
      if (doc.exists && doc.data() != null) {
        return SchedulePill.fromMap(doc.data()!, doc.id);
      }
      return null;
    } catch (e) {
      throw Exception('Lỗi khi lấy lịch uống thuốc: $e');
    }
  }

  /// UPDATE - Cập nhật toàn bộ thông tin thuốc
  Future<void> updateSchedulePill(String id, SchedulePill schedulePill) async {
    try {
      await _schedulePillsRef.doc(id).update(schedulePill.toJson());
    } catch (e) {
      throw Exception('Lỗi khi cập nhật: $e');
    }
  }

  /// DELETE - Xóa lịch uống thuốc
  Future<void> deleteSchedulePill(String id) async {
    try {
      await _schedulePillsRef.doc(id).delete();
    } catch (e) {
      throw Exception('Lỗi khi xóa: $e');
    }
  }

  /// UTILITY - Đếm số lịch thuốc (Sử dụng AggregateQuery để tối ưu chi phí)
  Future<int> countSchedulePillsByParentId(String parentId) async {
    try {
      AggregateQuerySnapshot snapshot = await _schedulePillsRef
          .where('parentId', isEqualTo: parentId)
          .count()
          .get();
      // Xử lý null-safety cho kiểu int?
      return snapshot.count ?? 0;
    } catch (e) {
      return 0;
    }
  }

  /// SEARCH - Tìm kiếm theo tên thuốc
  Future<List<SchedulePill>> searchSchedulePillsByMedicineName(
    String keyword,
  ) async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await _schedulePillsRef
          .orderBy('medicineName')
          .startAt([keyword])
          .endAt(['$keyword\uf8ff'])
          .get();

      return snapshot.docs
          .map((doc) => SchedulePill.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw Exception('Lỗi khi tìm kiếm: $e');
    }
  }

  Stream<List<SchedulePill>> getSchedulePillsByChildIdStream(String childId) {
    return _schedulePillsRef
        .where('childId', isEqualTo: childId)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => SchedulePill.fromMap(doc.data(), doc.id))
              .toList(),
        );
  }
}
