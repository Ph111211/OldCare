// import 'package:flutter/material.dart';
// import '../../viewmodels/Schedule/schedule.viewmodel.dart';
// import '../views/add_schedule.dart';
// import '../views/setting_page.dart';
// import '../views/history_page.dart';

// class ChildDashboard extends StatefulWidget {
//   const ChildDashboard({super.key});

//   @override
//   State<ChildDashboard> createState() => _ChildDashBoardState();
// }

// class _ChildDashBoardState extends State<ChildDashboard> {
//   final ScheduleViewModel scheduleViewModel = ScheduleViewModel();
//   final int _currentIndex = 0;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF9FAFB),
//       body: Stack(
//         children: [
//           StreamBuilder<List<dynamic>>(
//             stream: scheduleViewModel.getSchedulesStream(),
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return const Center(child: CircularProgressIndicator());
//               }

//               // Dữ liệu từ Firebase (Lịch hẹn)
//               final allSchedules = snapshot.data ?? [];

//               return _buildMainScrollContent(
//                 content: [
//                   _buildAlertCard(),
//                   const SizedBox(height: 24),
//                   _buildStatGrid(allSchedules.length),
//                   const SizedBox(height: 24),

//                   // 1. PHẦN LỊCH UỐNG THUỐC (Medication Schedule)
//                   _buildMedicationSchedule(),

//                   const SizedBox(height: 24),

//                   // 2. PHẦN LỊCH HẸN (Appointment List - Dữ liệu thực từ Stream)
//                   _buildAppointmentList(allSchedules),
//                 ],
//               );
//             },
//           ),
//           Positioned(bottom: 0, left: 0, right: 0, child: _buildBottomNav()),
//         ],
//       ),
//     );
//   }

//   // --- PHẦN MỚI: LỊCH UỐNG THUỐC ---
//   Widget _buildMedicationSchedule() {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: Colors.grey.shade100),
//       ),
//       child: Column(
//         children: [
//           // Header của khối thuốc
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Text(
//                   "Lịch uống thuốc hôm nay",
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 ),
//                 TextButton(
//                   onPressed: () {},
//                   child: const Text(
//                     "Xem tất cả",
//                     style: TextStyle(color: Colors.blue),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           const Divider(height: 1),

//           // Danh sách các loại thuốc theo đúng mẫu ảnh
//           _buildMedicationItem(
//             name: "Thuốc Huyết áp",
//             time: "08:00",
//             dosage: "1 viên",
//             status: "Đã uống",
//             subStatus: "Đã uống lúc 08:05",
//             statusColor: const Color(0xFFE8F5E9), // Xanh lá nhạt
//             textColor: const Color(0xFF2E7D32),
//             icon: Icons.check,
//           ),
//           _buildMedicationItem(
//             name: "Thuốc Tiểu đường",
//             time: "18:00",
//             dosage: "2 viên",
//             status: "Chưa đến giờ",
//             statusColor: const Color(0xFFFFF8E1), // Vàng nhạt
//             textColor: const Color(0xFFF57F17),
//             icon: Icons.access_time,
//           ),
//           _buildMedicationItem(
//             name: "Vitamin D",
//             time: "12:00",
//             dosage: "1 viên",
//             status: "Bỏ lỡ",
//             statusColor: const Color(0xFFFFEBEE), // Đỏ nhạt
//             textColor: const Color(0xFFC62828),
//             icon: Icons.warning_amber_rounded,
//             isLast: true,
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildMedicationItem({
//     required String name,
//     required String time,
//     required String dosage,
//     required String status,
//     String? subStatus,
//     required Color statusColor,
//     required Color textColor,
//     required IconData icon,
//     bool isLast = false,
//   }) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         border: isLast
//             ? null
//             : Border(bottom: BorderSide(color: Colors.grey.shade100)),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 name,
//                 style: const TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               // Badge trạng thái bên phải
//               Container(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 10,
//                   vertical: 6,
//                 ),
//                 decoration: BoxDecoration(
//                   color: statusColor,
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 child: Row(
//                   children: [
//                     Icon(icon, size: 14, color: textColor),
//                     const SizedBox(width: 4),
//                     Text(
//                       status,
//                       style: TextStyle(
//                         color: textColor,
//                         fontWeight: FontWeight.w500,
//                         fontSize: 13,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 4),
//           Text(
//             "$time • $dosage",
//             style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
//           ),
//           if (subStatus != null) ...[
//             const SizedBox(height: 4),
//             Row(
//               children: [
//                 Icon(Icons.check, size: 14, color: textColor),
//                 const SizedBox(width: 4),
//                 Text(
//                   subStatus,
//                   style: TextStyle(color: textColor, fontSize: 13),
//                 ),
//               ],
//             ),
//           ],
//         ],
//       ),
//     );
//   }

//   // --- PHẦN LỊCH HẸN (Dữ liệu từ Firestore) ---
//   Widget _buildAppointmentList(List<dynamic> schedules) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Colors.grey.shade200),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Padding(
//             padding: EdgeInsets.all(16),
//             child: Row(
//               children: [
//                 Icon(Icons.calendar_month, color: Color(0xFF2563EB)),
//                 SizedBox(width: 8),
//                 Text(
//                   "Lịch hẹn bác sĩ",
//                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                 ),
//               ],
//             ),
//           ),
//           const Divider(height: 1),
//           if (schedules.isEmpty)
//             const Padding(
//               padding: EdgeInsets.all(20),
//               child: Center(child: Text("Không có lịch hẹn nào")),
//             )
//           else
//             ...schedules
//                 .map(
//                   (item) => _appointmentItem(
//                     item.title,
//                     "${scheduleViewModel.formatDate(item.date)} • ${item.time}",
//                     item.location ?? "Địa chỉ chưa xác định",
//                   ),
//                 )
//                 .toList(),
//         ],
//       ),
//     );
//   }

//   Widget _appointmentItem(String title, String date, String location) {
//     return ListTile(
//       leading: Container(
//         padding: const EdgeInsets.all(8),
//         decoration: BoxDecoration(
//           color: Colors.blue.shade50,
//           borderRadius: BorderRadius.circular(8),
//         ),
//         child: const Icon(Icons.medical_services_outlined, color: Colors.blue),
//       ),
//       title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
//       subtitle: Text("$date\n$location"),
//       isThreeLine: true,
//       trailing: const Icon(Icons.chevron_right, color: Colors.grey),
//     );
//   }

//   // --- CÁC PHẦN HỖ TRỢ KHÁC ---
//   Widget _buildMainScrollContent({required List<Widget> content}) {
//     return SingleChildScrollView(
//       child: Column(
//         children: [
//           _buildHeader(),
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(children: content),
//           ),
//           const SizedBox(height: 120),
//         ],
//       ),
//     );
//   }

//   Widget _buildHeader() {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.only(top: 60, left: 16, right: 16, bottom: 24),
//       decoration: const BoxDecoration(
//         gradient: LinearGradient(
//           colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)],
//         ),
//       ),
//       child: Row(
//         children: [
//           CircleAvatar(
//             radius: 24,
//             backgroundColor: Colors.white.withOpacity(0.2),
//             child: const Icon(Icons.person, color: Colors.white),
//           ),
//           const SizedBox(width: 12),
//           const Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 'An Tâm - Con',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               Text(
//                 'Hệ thống giám sát sức khỏe',
//                 style: TextStyle(color: Colors.white70, fontSize: 12),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildStatGrid(int count) {
//     return Row(
//       children: [
//         _statItem(
//           count.toString(),
//           "Lịch hẹn",
//           const Color(0xFFEFF6FF),
//           const Color(0xFF1E3A8A),
//         ),
//         const SizedBox(width: 12),
//         _statItem(
//           "2",
//           "Đơn thuốc",
//           const Color(0xFFECFDF5),
//           const Color(0xFF064E3B),
//         ),
//       ],
//     );
//   }

//   Widget _statItem(String value, String label, Color bg, Color textColor) {
//     return Expanded(
//       child: Container(
//         padding: const EdgeInsets.all(12),
//         decoration: BoxDecoration(
//           color: bg,
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               value,
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//                 color: textColor,
//               ),
//             ),
//             Text(label, style: TextStyle(fontSize: 12, color: textColor)),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildAlertCard() {
//     return Container(
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: const Color(0xFFFFF7ED),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Colors.orange.shade200),
//       ),
//       child: const Row(
//         children: [
//           Icon(Icons.info_outline, color: Colors.orange),
//           SizedBox(width: 12),
//           Expanded(
//             child: Text(
//               "Đừng quên nhắc Cha Mẹ uống thuốc đúng giờ!",
//               style: TextStyle(fontSize: 13),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildBottomNav() {
//     return BottomNavigationBar(
//       type: BottomNavigationBarType.fixed,
//       currentIndex: _currentIndex,
//       onTap: (index) {
//         if (index == 1)
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (_) => const AddSchedule()),
//           );
//         if (index == 2)
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (_) => const HistoryScreen()),
//           );
//         if (index == 3)
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (_) => const AnTamSettingApp()),
//           );
//       },
//       items: const [
//         BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Trang chủ'),
//         BottomNavigationBarItem(icon: Icon(Icons.add_box), label: 'Thêm lịch'),
//         BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Lịch sử'),
//         BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Cài đặt'),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/Schedule/schedule.viewmodel.dart';
import '../../viewmodels/schedulePill/schedulePill.viewmodel.dart'; // Đảm bảo đúng đường dẫn
import '../../models/schedulePill.model.dart';
import '../views/add_schedule.dart';
import '../views/setting_page.dart';
import '../views/history_page.dart';

class ChildDashboard extends StatefulWidget {
  const ChildDashboard({super.key});

  @override
  State<ChildDashboard> createState() => _ChildDashBoardState();
}

class _ChildDashBoardState extends State<ChildDashboard> {
  // Khởi tạo ViewModel
  final ScheduleViewModel scheduleViewModel = ScheduleViewModel();
  final int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    // Lấy instance của SchedulePillViewModel thông qua Provider
    final pillVM = Provider.of<SchedulePillViewModel>(context);

    // Giả định một ID người dùng cố định để demo (Thay thế bằng ID thực tế từ Auth)
    // const String currentUserId = ;

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: Stack(
        children: [
          StreamBuilder<List<dynamic>>(
            stream: scheduleViewModel.getSchedulesStream(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              final allSchedules = snapshot.data ?? [];

              return _buildMainScrollContent(
                content: [
                  _buildAlertCard(),
                  const SizedBox(height: 24),
                  _buildStatGrid(allSchedules.length),
                  const SizedBox(height: 24),

                  // 1. PHẦN LỊCH UỐNG THUỐC (Sử dụng dữ liệu thực từ Stream)
                  StreamBuilder<List<SchedulePill>>(
                    stream: pillVM.getSchedulePillsByCurrentChildStream(),
                    builder: (context, pillSnapshot) {
                      final pills = pillSnapshot.data ?? [];
                      return _buildMedicationSchedule(pills, pillVM);
                    },
                  ),

                  const SizedBox(height: 24),

                  // 2. PHẦN LỊCH HẸN
                  _buildAppointmentList(allSchedules),
                ],
              );
            },
          ),
          Positioned(bottom: 0, left: 0, right: 0, child: _buildBottomNav()),
        ],
      ),
    );
  }

  // --- CẬP NHẬT: LỊCH UỐNG THUỐC VỚI DỮ LIỆU THỰC ---
  Widget _buildMedicationSchedule(
    List<SchedulePill> pills,
    SchedulePillViewModel vm,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Lịch uống thuốc hôm nay",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    "Xem tất cả",
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          if (pills.isEmpty)
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text("Không có lịch uống thuốc nào hôm nay"),
            )
          else
            ...pills.map((pill) {
              // Logic xác định màu sắc dựa trên status
              Color statusColor = const Color(0xFFFFF8E1);
              Color textColor = const Color(0xFFF57F17);
              IconData icon = Icons.access_time;
              String statusLabel = "Chưa uống";

              if (pill.status == "Completed") {
                statusColor = const Color(0xFFE8F5E9);
                textColor = const Color(0xFF2E7D32);
                icon = Icons.check;
                statusLabel = "Đã uống";
              } else if (pill.status == "Missed") {
                statusColor = const Color(0xFFFFEBEE);
                textColor = const Color(0xFFC62828);
                icon = Icons.warning_amber_rounded;
                statusLabel = "Bỏ lỡ";
              }

              return _buildMedicationItem(
                pillId: pill.id,
                name: pill.medicineName,
                time: pill.time,
                dosage: pill.dosage,
                status: statusLabel,
                subStatus: pill.status == "Completed" ? "Đã xác nhận" : null,
                statusColor: statusColor,
                textColor: textColor,
                icon: icon,
                onConfirm: () =>
                    vm.confirmPillTaken(pill.id), // Gọi hàm xác nhận
                isLast: pills.last == pill,
              );
            }).toList(),
        ],
      ),
    );
  }

  Widget _buildMedicationItem({
    required String pillId,
    required String name,
    required String time,
    required String dosage,
    required String status,
    String? subStatus,
    required Color statusColor,
    required Color textColor,
    required IconData icon,
    required VoidCallback onConfirm,
    bool isLast = false,
  }) {
    return InkWell(
      onTap: status == "Chưa uống"
          ? onConfirm
          : null, // Nhấn để xác nhận đã uống
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: isLast
              ? null
              : Border(bottom: BorderSide(color: Colors.grey.shade100)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Icon(icon, size: 14, color: textColor),
                      const SizedBox(width: 4),
                      Text(
                        status,
                        style: TextStyle(
                          color: textColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              "$time • $dosage",
              style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
            ),
            if (subStatus != null) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.check, size: 14, color: textColor),
                  const SizedBox(width: 4),
                  Text(
                    subStatus,
                    style: TextStyle(color: textColor, fontSize: 13),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  // --- GIỮ NGUYÊN CÁC HÀM KHÁC TỪ MÃ CŨ CỦA BẠN ---
  Widget _buildAppointmentList(List<dynamic> schedules) {
    /* ... Giữ nguyên ... */
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(Icons.calendar_month, color: Color(0xFF2563EB)),
                SizedBox(width: 8),
                Text(
                  "Lịch hẹn bác sĩ",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          if (schedules.isEmpty)
            const Padding(
              padding: EdgeInsets.all(20),
              child: Center(child: Text("Không có lịch hẹn nào")),
            )
          else
            ...schedules
                .map(
                  (item) => _appointmentItem(
                    item.title,
                    "${scheduleViewModel.formatDate(item.date)} • ${item.time}",
                    item.location ?? "Địa chỉ chưa xác định",
                  ),
                )
                .toList(),
        ],
      ),
    );
  }

  Widget _appointmentItem(String title, String date, String location) {
    /* ... Giữ nguyên ... */
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(Icons.medical_services_outlined, color: Colors.blue),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text("$date\n$location"),
      isThreeLine: true,
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
    );
  }

  Widget _buildMainScrollContent({required List<Widget> content}) {
    /* ... Giữ nguyên ... */
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildHeader(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(children: content),
          ),
          const SizedBox(height: 120),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    /* ... Giữ nguyên ... */
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 60, left: 16, right: 16, bottom: 24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)],
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: Colors.white.withOpacity(0.2),
            child: const Icon(Icons.person, color: Colors.white),
          ),
          const SizedBox(width: 12),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'An Tâm - Con',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Hệ thống giám sát sức khỏe',
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatGrid(int count) {
    /* ... Giữ nguyên ... */
    return Row(
      children: [
        _statItem(
          count.toString(),
          "Lịch hẹn",
          const Color(0xFFEFF6FF),
          const Color(0xFF1E3A8A),
        ),
        const SizedBox(width: 12),
        _statItem(
          "2",
          "Đơn thuốc",
          const Color(0xFFECFDF5),
          const Color(0xFF064E3B),
        ),
      ],
    );
  }

  Widget _statItem(String value, String label, Color bg, Color textColor) {
    /* ... Giữ nguyên ... */
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            Text(label, style: TextStyle(fontSize: 12, color: textColor)),
          ],
        ),
      ),
    );
  }

  Widget _buildAlertCard() {
    /* ... Giữ nguyên ... */
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7ED),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.shade200),
      ),
      child: const Row(
        children: [
          Icon(Icons.info_outline, color: Colors.orange),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              "Đừng quên nhắc Cha Mẹ uống thuốc đúng giờ!",
              style: TextStyle(fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    /* ... Giữ nguyên ... */
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: _currentIndex,
      onTap: (index) {
        if (index == 1)
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddSchedule()),
          );
        if (index == 2)
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const HistoryScreen()),
          );
        if (index == 3)
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AnTamSettingApp()),
          );
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Trang chủ'),
        BottomNavigationBarItem(icon: Icon(Icons.add_box), label: 'Thêm lịch'),
        BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Lịch sử'),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Cài đặt'),
      ],
    );
  }
}
