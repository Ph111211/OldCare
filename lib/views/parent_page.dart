import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:provider/provider.dart';
import '../../models/schedulePill.model.dart';
import '../../viewmodels/schedulePill/schedulePill.viewmodel.dart';

/// Class đóng gói dữ liệu hiển thị thông báo
class MedicationNotice {
  final String message;
  final Color color;
  final Widget? banner;
  final String? currentPillId;

  MedicationNotice({
    required this.message,
    required this.color,
    this.banner,
    this.currentPillId,
  });
}

class GiaoDiNChNh extends StatefulWidget {
  const GiaoDiNChNh({super.key});

  @override
  State<GiaoDiNChNh> createState() => _GiaoDiNChNhState();
}

class _GiaoDiNChNhState extends State<GiaoDiNChNh> {
  late DateTime _now;
  Timer? _timer;
  List<SchedulePill> _localPills = [];
  bool _isInitialLoaded = false;

  @override
  void initState() {
    super.initState();
    _now = DateTime.now();
    // Cập nhật mỗi giây để đồng bộ đồng hồ và kiểm tra lịch thuốc sát sao
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) setState(() => _now = DateTime.now());
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // Hàm lấy childId từ Firestore
  Future<String?> _getChildIdFromFirestore() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    return doc.data()?['childId'] as String?;
  }

  // Định dạng Thứ, Ngày/Tháng/Năm tiếng Việt chuẩn
  String _formatFullDate(DateTime dt) {
    const days = [
      'Chủ Nhật',
      'Thứ Hai',
      'Thứ Ba',
      'Thứ Tư',
      'Thứ Năm',
      'Thứ Sáu',
      'Thứ Bảy',
    ];
    String dayName = days[dt.weekday % 7];
    return "$dayName, ${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}";
  }

  MedicationNotice _getNotice(List<SchedulePill> pills) {
    if (pills.isEmpty)
      return MedicationNotice(message: "", color: const Color(0xFF4B5563));

    for (var pill in pills) {
      if (pill.status == "Completed") continue;

      DateTime pillTime = _parseTimeStringToToday(pill.time);
      int difference = pillTime.difference(_now).inMinutes;

      // Logic hiển thị banner dựa trên khoảng cách thời gian
      if (difference < 0 && difference >= -60) {
        return MedicationNotice(
          message: "ĐÃ QUÁ GIỜ UỐNG THUỐC!",
          color: Colors.redAccent,
          currentPillId: pill.id,
          banner: _buildNotificationBanner(
            title: "Đã quá giờ",
            medicine: pill.medicineName,
            time: pill.time,
            dosage: pill.dosage,
            bgColor: const Color(0xFFEF4444),
          ),
        );
      } else if (difference >= 0 && difference <= 30) {
        return MedicationNotice(
          message: difference == 0
              ? "ĐẾN GIỜ UỐNG THUỐC RỒI!"
              : "Chuẩn bị uống thuốc",
          color: difference == 0 ? Colors.green : Colors.orangeAccent,
          currentPillId: pill.id,
          banner: _buildNotificationBanner(
            title: difference == 0 ? "Đã đến giờ" : "Sắp đến giờ",
            medicine: pill.medicineName,
            time: pill.time,
            dosage: pill.dosage,
            bgColor: difference == 0
                ? const Color(0xFF22C55E)
                : const Color(0xFF3B82F6),
          ),
        );
      }
    }
    return MedicationNotice(message: "", color: const Color(0xFF4B5563));
  }

  @override
  Widget build(BuildContext context) {
    final pillVM = Provider.of<SchedulePillViewModel>(context, listen: false);

    return FutureBuilder<String?>(
      future: _getChildIdFromFirestore(),
      builder: (context, idSnapshot) {
        if (idSnapshot.connectionState == ConnectionState.waiting &&
            !_isInitialLoaded) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return FutureBuilder<Stream<List<SchedulePill>>>(
          future: pillVM.getSchedulePillsByParentIdStream(),
          builder: (context, streamSnapshot) {
            if (streamSnapshot.connectionState == ConnectionState.waiting &&
                !_isInitialLoaded) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            return StreamBuilder<List<SchedulePill>>(
              stream: streamSnapshot.data,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  _localPills = snapshot.data!;
                  _isInitialLoaded = true;
                }
                final notice = _getNotice(_localPills);
                return Scaffold(body: _buildUI(notice, pillVM));
              },
            );
          },
        );
      },
    );
  }

  Widget _buildUI(MedicationNotice notice, SchedulePillViewModel vm) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFEFF6FF), Colors.white],
        ),
      ),
      child: SafeArea(
        // SỬA LỖI OVERFLOW: Bọc bằng SingleChildScrollView để nội dung không bị tràn
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
          child: Column(
            children: [
              const SizedBox(height: 30),
              // 1. Đồng hồ thời gian thực
              Text(
                _formatTime(_now),
                style: const TextStyle(
                  fontSize: 90,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF111827),
                  height: 1,
                ),
              ),
              // 2. PHẦN MỚI: Thứ, Ngày Tháng Năm
              const SizedBox(height: 10),
              Text(
                _formatFullDate(_now),
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF4B5563),
                ),
              ),

              const SizedBox(height: 30),

              // 3. Banner thông báo thuốc (nếu có)
              if (notice.banner != null) notice.banner!,

              const SizedBox(height: 20),
              if (notice.message.isNotEmpty)
                Text(
                  notice.message,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: notice.color,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

              const SizedBox(height: 40),

              // 4. Danh sách nút bấm điều khiển
              _buildActionButton(
                label: 'SOS KHẨN CẤP',
                color: const Color(0xFFEF4444),
                icon: Icons.error_outline,
                onTap: () => _showSOSDialog(),
              ),
              const SizedBox(height: 20),
              _buildActionButton(
                label: 'XÁC NHẬN ĐÃ UỐNG',
                color: const Color(0xFF22C55E),
                icon: Icons.check_circle_outline,
                onTap: () {
                  if (notice.currentPillId != null)
                    vm.confirmPillTaken(notice.currentPillId!);
                },
              ),
              const SizedBox(height: 20),
              _buildActionButton(
                label: 'GỌI CON',
                color: const Color(0xFFFF7F50),
                icon: Icons.phone_outlined,
                onTap: () => print("Gọi cho con..."),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationBanner({
    required String title,
    required String medicine,
    required String time,
    required String dosage,
    required Color bgColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: bgColor.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.notifications_active, color: Colors.white, size: 40),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
                Text(
                  "$medicine ($dosage)",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Giờ uống: $time",
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String label,
    required Color color,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(20),
      elevation: 8,
      shadowColor: color.withOpacity(0.4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: double.infinity,
          height: 110,
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 35),
              const SizedBox(width: 15),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime dt) =>
      "${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}";

  DateTime _parseTimeStringToToday(String timeString) {
    try {
      final parts = timeString.split(' ');
      final hm = parts[0].split(':');
      int hour = int.parse(hm[0]);
      int minute = int.parse(hm[1]);
      if (parts.length > 1) {
        if (parts[1].toUpperCase() == 'PM' && hour != 12) hour += 12;
        if (parts[1].toUpperCase() == 'AM' && hour == 12) hour = 0;
      }
      return DateTime(_now.year, _now.month, _now.day, hour, minute);
    } catch (e) {
      return _now.add(const Duration(days: 1));
    }
  }

  void _showSOSDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Gửi SOS?"),
        content: const Text(
          "Hệ thống sẽ gửi cảnh báo khẩn cấp đến con của bạn.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("HỦY"),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context); // Đóng dialog ngay
              await _sendSOSAlert(); // Gọi hàm gửi tín hiệu
            },
            child: const Text("GỬI NGAY", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  /// Hàm thực hiện ghi dữ liệu SOS vào Firestore
  Future<void> _sendSOSAlert() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      // 1. Lấy thông tin childId và tên của Bố/Mẹ
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      final String? childId = userDoc.data()?['child_id'];
      final String parentName = userDoc.data()?['name'] ?? "Bố/Mẹ";

      if (childId == null || childId.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Không tìm thấy ID người con để gửi SOS!"),
            ),
          );
        }
        return;
      }

      // 2. Tạo một bản ghi SOS mới trong Firestore
      await FirebaseFirestore.instance.collection('notifications').add({
        'receiverId': childId, // ID của người con nhận thông báo
        'senderId': user.uid, // ID của Bố/Mẹ gửi
        'senderName': parentName,
        'type': 'SOS', // Loại thông báo là SOS
        'message': '$parentName đang cần hỗ trợ khẩn cấp!',
        'timestamp': FieldValue.serverTimestamp(),
        'isRead': false,
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Đã gửi tín hiệu SOS thành công!"),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Lỗi khi gửi SOS: $e")));
      }
    }
  }
}
