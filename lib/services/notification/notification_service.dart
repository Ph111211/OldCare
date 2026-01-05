import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NotificationService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Hàm lắng nghe thông báo SOS dành riêng cho Child
  void listenToSOSAlerts(BuildContext context) {
    final String? currentUserId = _auth.currentUser?.uid;
    if (currentUserId == null) return;

    _db
        .collection('notifications')
        .where('receiverId', isEqualTo: currentUserId)
        .where('type', isEqualTo: 'SOS')
        .where('isRead', isEqualTo: false)
        .snapshots()
        .listen((snapshot) {
          for (var change in snapshot.docChanges) {
            if (change.type == DocumentChangeType.added) {
              final data = change.doc.data();
              if (data != null) {
                _showEmergencyDialog(context, change.doc.id, data);
              }
            }
          }
        });
  }

  void _showEmergencyDialog(
    BuildContext context,
    String docId,
    Map<String, dynamic> data,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false, // Bắt buộc phải tương tác
      builder: (context) => AlertDialog(
        backgroundColor: Colors.red[50],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.red, size: 40),
            SizedBox(width: 10),
            Text(
              "CẢNH BÁO SOS!",
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${data['senderName']} đang cần hỗ trợ khẩn cấp!",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            Text("Lời nhắn: ${data['message']}"),
          ],
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              // Đánh dấu là đã đọc để không hiện lại
              await _db.collection('notifications').doc(docId).update({
                'isRead': true,
              });
              Navigator.pop(context);
            },
            child: const Text("XÁC NHẬN ĐÃ NHẬN TIN"),
          ),
        ],
      ),
    );
  }
}
