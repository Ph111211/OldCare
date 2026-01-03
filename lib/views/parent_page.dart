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
import 'package:oldcare/services/schedulePhill/schedule_Pill.service.dart';
import 'dart:async';
import 'package:provider/provider.dart';
import '../../models/schedulePill.model.dart';
import '../../viewmodels/schedulePill/schedulePill.viewmodel.dart';

class GiaoDiNChNh extends StatefulWidget {
  const GiaoDiNChNh({super.key});

  @override
  State<GiaoDiNChNh> createState() => _GiaoDiNChNhState();
}

class _GiaoDiNChNhState extends State<GiaoDiNChNh> {
  late DateTime _now;
  late Timer _timer;
  String _message = "Chúc Bố Mẹ một ngày tốt lành!";
  Color _messageColor = const Color(0xFF4B5563);
  final SchedulePillViewModel pillVM = SchedulePillViewModel(
    SchedulePillService(),
  );

  @override
  void initState() {
    super.initState();
    _now = DateTime.now();
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
    _timer.cancel();
    super.dispose();
  }

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

  @override
  @override
  Widget build(BuildContext context) {
    // 1. Truy cập ViewModel thông qua Provider
    // Đảm bảo widget này nằm dưới MultiProvider trong main.dart

    // 2. Sử dụng FutureBuilder để lấy thông tin User hiện tại từ Firestore
    return FutureBuilder<String?>(
      future: _getChildIdFromFirestore(), // Hàm xử lý lấy childId async
      builder: (context, idSnapshot) {
        // Hiển thị màn hình chờ khi đang truy vấn Firestore
        if (idSnapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final String? currentChildId = idSnapshot.data;

        // 3. Khi đã có ID, dùng StreamBuilder để cập nhật thuốc thời gian thực
        return Scaffold(
          body: FutureBuilder<Stream<List<SchedulePill>>>(
            future: pillVM.getSchedulePillsByChildIdStream(
              currentChildId ?? "",
            ),
            builder: (context, streamSnapshot) {
              if (streamSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (streamSnapshot.hasError) {
                return Center(child: Text('Lỗi tải dữ liệu'));
              }

              final stream = streamSnapshot.data;

              return StreamBuilder<List<SchedulePill>>(
                stream: stream,
                builder: (context, snapshot) {
                  final pills = snapshot.data ?? [];

                  // Xử lý logic tính toán 30 phút và các trạng thái Banner
                  _processMedicationStatus(pills);

                  // Trả về giao diện chính của Bố Mẹ
                  return _buildUI();
                },
              );
            },
          ),
        );
      },
    );
  }

  /// Hàm hỗ trợ lấy childId của người dùng hiện tại
  Future<String?> _getChildIdFromFirestore() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return null;

      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      // Lấy childId chính xác từ document
      return doc.data()?['childId'] as String?;
    } catch (e) {
      debugPrint("Lỗi lấy childId: $e");
      return null;
    }
  }

  Widget _buildNotificationBanner({
    required String title,
    required String medicine,
    required String time,
    required String dosage,
    required Color bgColor,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
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

  Widget? _notificationWidget; // Lưu trữ widget thông báo hiện tại

  void _processMedicationStatus(List<SchedulePill> pills) {
    if (pills.isEmpty) return;

    _notificationWidget = null; // Reset mỗi lần chạy

    for (var pill in pills) {
      if (pill.status == "Completed") continue;

      DateTime pillTime = _parseTimeStringToToday(pill.time);
      int difference = pillTime.difference(_now).inMinutes;

      // 1. Đã quá giờ (Màu Đỏ)
      if (difference < 0 && difference >= -60) {
        _notificationWidget = _buildNotificationBanner(
          title: "Đã quá giờ",
          medicine: pill.medicineName,
          time: pill.time,
          dosage: pill.dosage,
          bgColor: const Color(0xFFEF4444),
        );
        break;
      }
      // 2. Đã đến giờ (Màu Xanh lá)
      else if (difference == 0) {
        _notificationWidget = _buildNotificationBanner(
          title: "Đã đến giờ",
          medicine: pill.medicineName,
          time: pill.time,
          dosage: pill.dosage,
          bgColor: const Color(0xFF22C55E),
        );
        break;
      }
      // 3. Sắp đến giờ 30 phút (Màu Xanh dương)
      else if (difference > 0 && difference <= 30) {
        _notificationWidget = _buildNotificationBanner(
          title: "Sắp đến giờ",
          medicine: pill.medicineName,
          time: pill.time,
          dosage: pill.dosage,
          bgColor: const Color(0xFF3B82F6),
        );
        break;
      }
    }
  }

  Widget _buildUI() {
    // Sử dụng mã UI cũ của bạn nhưng thay thế phần Message
    return Container(
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
              // 1. Thời gian & Thông báo tự động
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
                  const SizedBox(height: 10),
                  Text(
                    _message, // THÔNG BÁO TỰ ĐỘNG CẬP NHẬT
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: _messageColor,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              // 2. Các nút chức năng
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
                    onTap: () {},
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
            ],
          ),
        ),
      ),
    );
  }

  // Các hàm format và build button giữ nguyên như cũ
  String _formatTime(DateTime dt) =>
      "${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}";
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
}
