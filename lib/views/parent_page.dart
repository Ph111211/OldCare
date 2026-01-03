// import 'package:flutter/material.dart';
// import 'dart:async'; // Cần thiết để sử dụng Timer

// class GiaoDiNChNh extends StatefulWidget {
//   const GiaoDiNChNh({super.key});

//   @override
//   State<GiaoDiNChNh> createState() => _GiaoDiNChNhState();
// }

// class _GiaoDiNChNhState extends State<GiaoDiNChNh> {
//   late DateTime _now;
//   late Timer _timer;

//   @override
//   void initState() {
//     super.initState();
//     _now = DateTime.now();
//     // Cập nhật thời gian mỗi giây để đảm bảo đồng hồ chính xác
//     _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       setState(() {
//         _now = DateTime.now();
//       });
//     });
//   }

//   @override
//   void dispose() {
//     _timer.cancel(); // Hủy timer khi widget bị hủy để tránh rò rỉ bộ nhớ
//     super.dispose();
//   }

//   // Hàm định dạng giờ:phút (HH:mm)
//   String _formatTime(DateTime dt) {
//     final String hour = dt.hour.toString().padLeft(2, '0');
//     final String minute = dt.minute.toString().padLeft(2, '0');
//     return '$hour:$minute';
//   }

//   // Hàm định dạng ngày tháng tiếng Việt
//   String _formatDate(DateTime dt) {
//     const weekdays = [
//       'Chủ Nhật',
//       'Thứ Hai',
//       'Thứ Ba',
//       'Thứ Tư',
//       'Thứ Năm',
//       'Thứ Sáu',
//       'Thứ Bảy',
//     ];
//     final String weekday = weekdays[dt.weekday % 7];
//     return '$weekday, ${dt.day}/${dt.month}/${dt.year}';
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: LayoutBuilder(
//         builder: (context, constraints) {
//           return SingleChildScrollView(
//             child: ConstrainedBox(
//               constraints: BoxConstraints(minHeight: constraints.maxHeight),
//               child: Container(
//                 width: double.infinity,
//                 decoration: const BoxDecoration(
//                   gradient: LinearGradient(
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                     colors: [
//                       Color(0xFFEFF6FF),
//                       Colors.white,
//                       Color(0xFFF0FDF4),
//                     ],
//                   ),
//                 ),
//                 child: SafeArea(
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 25,
//                       vertical: 20,
//                     ),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         // --- 1. Phần hiển thị Thời gian (Đã cập nhật hệ thống) ---
//                         Column(
//                           children: [
//                             const SizedBox(height: 20),
//                             Text(
//                               _formatTime(_now), // Hiển thị giờ thực
//                               style: const TextStyle(
//                                 color: Color(0xFF111827),
//                                 fontSize: 80,
//                                 fontWeight: FontWeight.w800,
//                                 letterSpacing: -2,
//                                 height: 1,
//                               ),
//                             ),
//                             const SizedBox(height: 10),
//                             Text(
//                               _formatDate(_now), // Hiển thị ngày thực
//                               style: const TextStyle(
//                                 color: Color(0xFF4B5563),
//                                 fontSize: 28,
//                                 fontWeight: FontWeight.w700,
//                               ),
//                             ),
//                           ],
//                         ),

//                         const SizedBox(height: 30),

//                         // --- 2. Danh sách nút chức năng (Giữ nguyên) ---
//                         Column(
//                           children: [
//                             _buildActionButton(
//                               label: 'SOS KHẨN CẤP',
//                               color: const Color(0xFFEF4444),
//                               icon: Icons.error_outline,
//                               onTap: () => print("Bấm SOS"),
//                             ),
//                             const SizedBox(height: 20),
//                             _buildActionButton(
//                               label: 'XÁC NHẬN',
//                               color: const Color(0xFF22C55E),
//                               icon: Icons.check_circle_outline,
//                               onTap: () => print("Bấm Xác nhận"),
//                             ),
//                             const SizedBox(height: 20),
//                             _buildActionButton(
//                               label: 'GỌI CON',
//                               color: const Color(0xFFFF7F50),
//                               icon: Icons.phone_outlined,
//                               onTap: () => print("Bấm Gọi con"),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 10),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   // Giữ nguyên hàm _buildActionButton của bạn
//   Widget _buildActionButton({
//     required String label,
//     required Color color,
//     required IconData icon,
//     required VoidCallback onTap,
//   }) {
//     return Material(
//       color: color,
//       borderRadius: BorderRadius.circular(16),
//       elevation: 6,
//       shadowColor: color.withOpacity(0.4),
//       child: InkWell(
//         onTap: onTap,
//         borderRadius: BorderRadius.circular(16),
//         child: Container(
//           width: double.infinity,
//           height: 140,
//           alignment: Alignment.center,
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(icon, color: Colors.white, size: 50),
//               const SizedBox(height: 8),
//               Text(
//                 label,
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 22,
//                   fontWeight: FontWeight.w900,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:provider/provider.dart';
import '../../models/schedulePill.model.dart';
import '../../viewmodels/schedulePill/schedulePill.viewmodel.dart';

/// Class đóng gói dữ liệu hiển thị thông báo để tránh gọi setState trong build
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
    // Cập nhật thời gian mỗi giây để đồng bộ đồng hồ và tính toán khoảng cách uống thuốc
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _now = DateTime.now();
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  /// Hàm hỗ trợ lấy childId của người dùng hiện tại từ Firestore
  Future<String?> _getChildIdFromFirestore() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    return doc.data()?['childId'] as String?;
  }

  /// Logic xử lý DateTime: So sánh thời gian hệ thống và lịch thuốc
  MedicationNotice _getNotice(List<SchedulePill> pills) {
    String msg = "";
    Color col = const Color(0xFF4B5563);
    Widget? banner;
    String? currentId;

    if (pills.isEmpty) return MedicationNotice(message: msg, color: col);

    for (var pill in pills) {
      if (pill.status == "Completed") continue;

      DateTime pillTime = _parseTimeStringToToday(pill.time);
      int difference = pillTime.difference(_now).inMinutes;

      // Trạng thái Đã quá giờ (Màu đỏ)
      if (difference < 0 && difference >= -60) {
        banner = _buildNotificationBanner(
          title: "Đã quá giờ",
          medicine: pill.medicineName,
          time: pill.time,
          dosage: pill.dosage,
          bgColor: const Color(0xFFEF4444),
        );
        // msg = "ĐẾN GIỜ UỐNG: ${pill.medicineName.toUpperCase()}!";
        msg = "";
        col = Colors.redAccent;
        currentId = pill.id;
        break;
      }
      // Trạng thái Sắp đến giờ hoặc Đã đến giờ (Xanh/Cam)
      else if (difference >= 0 && difference <= 30) {
        banner = _buildNotificationBanner(
          title: difference == 0 ? "Đã đến giờ" : "Sắp đến giờ",
          medicine: pill.medicineName,
          time: pill.time,
          dosage: pill.dosage,
          bgColor: difference == 0
              ? const Color(0xFF22C55E)
              : const Color(0xFF3B82F6),
        );
        // msg = difference == 0
        //     ? "Đã đến giờ uống thuốc!"
        //     : "Sắp uống thuốc (còn $difference phút)";
        col = difference == 0 ? Colors.green : Colors.orangeAccent;
        currentId = pill.id;
        break;
      }
    }
    return MedicationNotice(
      message: msg,
      color: col,
      banner: banner,
      currentPillId: currentId,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Truy cập ViewModel qua Provider (listen: false vì UI dùng Stream)
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

            final stream = streamSnapshot.data;

            return StreamBuilder<List<SchedulePill>>(
              stream: stream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  _localPills = snapshot.data!;
                  _isInitialLoaded = true;
                  print("Số lượng thuốc nhận được: ${snapshot.data!.length}");
                  for (var p in snapshot.data!) {
                    print(
                      "Thuốc: ${p.medicineName} - Giờ: ${p.time} - Trạng thái: ${p.status}",
                    );
                  }
                  // print(_localPills);
                }

                // Tính toán thông báo dựa trên dữ liệu local và thời gian thực
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
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFEFF6FF), Colors.white, Color(0xFFF0FDF4)],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  const SizedBox(height: 20),
                  Text(
                    _formatTime(_now),
                    style: const TextStyle(
                      fontSize: 80,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  if (notice.banner != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: notice.banner!,
                    ),
                  const SizedBox(height: 15),
                  Text(
                    notice.message,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: notice.color,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  _buildActionButton(
                    label: 'SOS KHẨN CẤP',
                    color: const Color(0xFFEF4444),
                    icon: Icons.error_outline,
                    onTap: () {},
                  ),
                  const SizedBox(height: 20),
                  _buildActionButton(
                    label: 'XÁC NHẬN ĐÃ UỐNG',
                    color: const Color(0xFF22C55E),
                    icon: Icons.check_circle_outline,
                    onTap: () {
                      if (notice.currentPillId != null) {
                        vm.confirmPillTaken(notice.currentPillId!);
                        // Cập nhật trạng thái lên Firebase
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  _buildActionButton(
                    label: 'GỌI CON',
                    color: const Color(0xFFFF7F50),
                    icon: Icons.phone_outlined,
                    onTap: () {},
                  ),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  // --- CÁC HELPER WIDGETS ---

  Widget _buildNotificationBanner({
    required String title,
    required String medicine,
    required String time,
    required String dosage,
    required Color bgColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.white.withOpacity(0.2),
            child: const Icon(Icons.notifications_none, color: Colors.white),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
                Text(
                  "$medicine • $time • $dosage",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
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
      borderRadius: BorderRadius.circular(16),
      elevation: 6,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: double.infinity,
          height: 120,
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 50),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
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
      if (parts[1] == 'PM' && hour != 12) hour += 12;
      if (parts[1] == 'AM' && hour == 12) hour = 0;
      return DateTime(_now.year, _now.month, _now.day, hour, minute);
    } catch (e) {
      return _now.add(const Duration(days: 1));
    }
  }
}
