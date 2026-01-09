// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:intl/intl.dart';
// import '../../models/schedulePill.model.dart';
// import '../../viewmodels/schedulePill/schedulePill.viewmodel.dart';

// class SeeAllMedicationPage extends StatelessWidget {
//   const SeeAllMedicationPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // Truy cập ViewModel qua Provider
//     final pillVM = Provider.of<SchedulePillViewModel>(context);
//     final String todayStr = DateFormat('yyyy-MM-dd').format(DateTime.now());

//     return Scaffold(
//       backgroundColor: const Color(0xFFF9FAFB),
//       body: Stack(
//         children: [
//           StreamBuilder<List<SchedulePill>>(
//             // Lấy luồng dữ liệu thuốc của người con hiện tại
//             stream: pillVM.getSchedulePillsByCurrentChildStream(),
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return const Center(child: CircularProgressIndicator());
//               }

//               final List<SchedulePill> allPills = snapshot.data ?? [];

//               // Tính toán các chỉ số thống kê thực tế
//               final int total = allPills.length;
//               final int completed = allPills
//                   .where(
//                     (p) =>
//                         p.status == "Completed" && p.lastTakenDate == todayStr,
//                   )
//                   .length;
//               final int missed = allPills
//                   .where((p) => p.status == "Missed")
//                   .length;

//               return SingleChildScrollView(
//                 child: Column(
//                   children: [
//                     _buildHeader(),
//                     Padding(
//                       padding: const EdgeInsets.all(16.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           _buildTopNavigation(context),
//                           const SizedBox(height: 16),
//                           _buildTodaySummary(total, completed, missed),
//                           const SizedBox(height: 16),
//                           _buildMedicineList(allPills, todayStr),
//                           const SizedBox(height: 100),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               );
//             },
//           ),
//           Positioned(bottom: 0, left: 0, right: 0, child: _buildBottomNav()),
//         ],
//       ),
//     );
//   }

//   // Header giữ nguyên gradient
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
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               Text(
//                 'Danh sách thuốc của Cha Mẹ',
//                 style: TextStyle(color: Color(0xFFDBEAFE), fontSize: 13),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildTopNavigation(BuildContext context) {
//     String formattedDate = DateFormat(
//       'EEEE, d MMMM',
//       'vi',
//     ).format(DateTime.now());
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         GestureDetector(
//           onTap: () => Navigator.pop(context),
//           child: const Row(
//             children: [
//               Icon(Icons.arrow_back_ios, size: 18, color: Color(0xFF101727)),
//               Text(
//                 'Quay lại',
//                 style: TextStyle(fontSize: 16, color: Color(0xFF101727)),
//               ),
//             ],
//           ),
//         ),
//         Text(
//           formattedDate,
//           style: const TextStyle(color: Color(0xFF697282), fontSize: 14),
//         ),
//       ],
//     );
//   }

//   // Cập nhật Thống kê động
//   Widget _buildTodaySummary(int total, int completed, int missed) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 10,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             'Tổng quan hôm nay',
//             style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//           ),
//           const SizedBox(height: 16),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               _buildSummaryItem(total.toString(), "Tổng lịch", Colors.black87),
//               _buildSummaryItem(
//                 completed.toString(),
//                 "Đã uống",
//                 const Color(0xFF00A63D),
//               ),
//               _buildSummaryItem(
//                 missed.toString(),
//                 "Bỏ lỡ",
//                 const Color(0xFFE7000A),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSummaryItem(String value, String label, Color color) {
//     return Column(
//       children: [
//         Text(
//           value,
//           style: TextStyle(
//             fontSize: 24,
//             fontWeight: FontWeight.bold,
//             color: color,
//           ),
//         ),
//         Text(
//           label,
//           style: const TextStyle(fontSize: 12, color: Color(0xFF697282)),
//         ),
//       ],
//     );
//   }

//   // Danh sách thuốc động
//   Widget _buildMedicineList(List<SchedulePill> pills, String todayStr) {
//     if (pills.isEmpty) {
//       return const Center(
//         child: Padding(
//           padding: EdgeInsets.all(20.0),
//           child: Text("Không có lịch uống thuốc nào."),
//         ),
//       );
//     }

//     return Column(
//       children: pills.map((pill) {
//         // Xác định trạng thái hiển thị dựa trên dữ liệu thực tế
//         String displayStatus = "Chưa đến giờ";
//         Color statusColor = const Color(0xFFD08700);
//         Color statusBg = const Color(0xFFFEFCE8);

//         if (pill.status == "Completed" && pill.lastTakenDate == todayStr) {
//           displayStatus = "Đã uống";
//           statusColor = const Color(0xFF00A63D);
//           statusBg = const Color(0xFFF0FDF4);
//         } else if (pill.status == "Missed") {
//           displayStatus = "Đã lỡ";
//           statusColor = const Color(0xFFE7000A);
//           statusBg = const Color(0xFFFEF2F2);
//         }

//         return Padding(
//           padding: const EdgeInsets.only(bottom: 12.0),
//           child: _buildMedicineCard(
//             name: pill.medicineName,
//             time: pill.time,
//             dosage: pill.dosage,
//             note: pill.frequency, // Hiển thị tần suất làm ghi chú
//             statusText: displayStatus,
//             statusColor: statusColor,
//             statusBg: statusBg,
//           ),
//         );
//       }).toList(),
//     );
//   }

//   Widget _buildMedicineCard({
//     required String name,
//     required String time,
//     required String dosage,
//     required String note,
//     required String statusText,
//     required Color statusColor,
//     required Color statusBg,
//   }) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 4,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 children: [
//                   Container(
//                     width: 40,
//                     height: 40,
//                     decoration: const BoxDecoration(
//                       color: Color(0xFFEFF6FF),
//                       shape: BoxShape.circle,
//                     ),
//                     child: const Icon(
//                       Icons.medication,
//                       color: Color(0xFF2563EB),
//                       size: 20,
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         name,
//                         style: const TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const SizedBox(height: 4),
//                       Text(
//                         '$time • $dosage',
//                         style: const TextStyle(
//                           color: Color(0xFF697282),
//                           fontSize: 14,
//                         ),
//                       ),
//                       Text(
//                         note,
//                         style: const TextStyle(
//                           color: Color(0xFF697282),
//                           fontSize: 12,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//               Container(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 10,
//                   vertical: 4,
//                 ),
//                 decoration: BoxDecoration(
//                   color: statusBg,
//                   borderRadius: BorderRadius.circular(20),
//                   border: Border.all(color: statusColor.withOpacity(0.2)),
//                 ),
//                 child: Text(
//                   statusText,
//                   style: TextStyle(
//                     color: statusColor,
//                     fontSize: 12,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           const Padding(
//             padding: EdgeInsets.symmetric(vertical: 12),
//             child: Divider(height: 1),
//           ),
//           Row(
//             children: [
//               Expanded(
//                 child: _buildActionButton(
//                   Icons.edit,
//                   "Sửa",
//                   const Color(0xFFF3F4F6),
//                   Colors.black87,
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: _buildActionButton(
//                   Icons.delete_outline,
//                   "Xóa",
//                   const Color(0xFFFEF2F2),
//                   const Color(0xFFE7000A),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildActionButton(
//     IconData icon,
//     String label,
//     Color bg,
//     Color textColor,
//   ) {
//     return Container(
//       height: 40,
//       decoration: BoxDecoration(
//         color: bg,
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(icon, size: 16, color: textColor),
//           const SizedBox(width: 4),
//           Text(
//             label,
//             style: TextStyle(color: textColor, fontWeight: FontWeight.w500),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildBottomNav() {
//     return Container(
//       height: 85,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         border: Border(top: BorderSide(color: Colors.grey.shade200)),
//         boxShadow: [
//           BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
//         ],
//       ),
//       child: const Row(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: [
//           _NavItem(
//             icon: Icons.grid_view_rounded,
//             label: "Tổng quan",
//             isActive: true,
//           ),
//           _NavItem(
//             icon: Icons.add_circle_outline,
//             label: "Thêm lịch",
//             isActive: false,
//           ),
//           _NavItem(icon: Icons.history, label: "Lịch sử", isActive: false),
//           _NavItem(
//             icon: Icons.settings_outlined,
//             label: "Cài đặt",
//             isActive: false,
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _NavItem extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   final bool isActive;
//   const _NavItem({
//     required this.icon,
//     required this.label,
//     required this.isActive,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Icon(
//           icon,
//           color: isActive ? const Color(0xFF2563EB) : const Color(0xFF6B7280),
//         ),
//         const SizedBox(height: 4),
//         Text(
//           label,
//           style: TextStyle(
//             fontSize: 11,
//             color: isActive ? const Color(0xFF2563EB) : const Color(0xFF6B7280),
//           ),
//         ),
//       ],
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../models/schedulePill.model.dart';
import '../../viewmodels/schedulePill/schedulePill.viewmodel.dart';

class SeeAllMedicationPage extends StatelessWidget {
  const SeeAllMedicationPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Truy cập ViewModel và xác định ngày hiện tại
    final pillVM = Provider.of<SchedulePillViewModel>(context);
    final String todayStr = DateFormat('yyyy-MM-dd').format(DateTime.now());

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: Stack(
        children: [
          StreamBuilder<List<SchedulePill>>(
            // Lấy luồng dữ liệu thuốc thời gian thực
            stream: pillVM.getSchedulePillsByCurrentChildStream(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              final List<SchedulePill> allPills = snapshot.data ?? [];

              // Tính toán các chỉ số thống kê dựa trên dữ liệu thực tế
              final int total = allPills.length;
              final int completed = allPills
                  .where(
                    (p) =>
                        p.status == "Completed" && p.lastTakenDate == todayStr,
                  )
                  .length;
              final int missed = allPills
                  .where((p) => p.status == "Missed")
                  .length;

              return SingleChildScrollView(
                child: Column(
                  children: [
                    _buildHeader(),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildTopNavigation(context),
                          const SizedBox(height: 16),
                          _buildTodaySummary(total, completed, missed),
                          const SizedBox(height: 16),
                          _buildMedicineList(
                            context,
                            allPills,
                            todayStr,
                            pillVM,
                          ),
                          const SizedBox(height: 100),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          Positioned(bottom: 0, left: 0, right: 0, child: _buildBottomNav()),
        ],
      ),
    );
  }

  // --- WIDGETS GIAO DIỆN ---

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 60, left: 16, right: 16, bottom: 24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)],
        ),
      ),
      child: const Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: Colors.white24,
            child: Icon(Icons.person, color: Colors.white),
          ),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'An Tâm - Con',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Danh sách thuốc của Cha Mẹ',
                style: TextStyle(color: Color(0xFFDBEAFE), fontSize: 13),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTopNavigation(BuildContext context) {
    // Định dạng ngày tháng tiếng Việt
    String formattedDate = DateFormat(
      'EEEE, d MMMM',
      'vi',
    ).format(DateTime.now());
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Row(
            children: [
              Icon(Icons.arrow_back_ios, size: 18, color: Color(0xFF101727)),
              Text(
                'Quay lại',
                style: TextStyle(fontSize: 16, color: Color(0xFF101727)),
              ),
            ],
          ),
        ),
        Text(
          formattedDate,
          style: const TextStyle(color: Color(0xFF697282), fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildTodaySummary(int total, int completed, int missed) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildSummaryItem(total.toString(), "Tổng lịch", Colors.black87),
          _buildSummaryItem(
            completed.toString(),
            "Đã uống",
            const Color(0xFF00A63D),
          ),
          _buildSummaryItem(
            missed.toString(),
            "Bỏ lỡ",
            const Color(0xFFE7000A),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String value, String label, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Color(0xFF697282)),
        ),
      ],
    );
  }

  // --- DANH SÁCH THUỐC ---

  Widget _buildMedicineList(
    BuildContext context,
    List<SchedulePill> pills,
    String todayStr,
    SchedulePillViewModel vm,
  ) {
    if (pills.isEmpty) {
      return const Center(child: Text("Không có lịch uống thuốc nào."));
    }

    return Column(
      children: pills.map((pill) {
        // Logic hiển thị trạng thái động
        String statusText = "Chưa đến giờ";
        Color color = const Color(0xFFD08700);
        Color bg = const Color(0xFFFEFCE8);

        if (pill.status == "Completed" && pill.lastTakenDate == todayStr) {
          statusText = "Đã uống";
          color = const Color(0xFF00A63D);
          bg = const Color(0xFFF0FDF4);
        } else if (pill.status == "Missed") {
          statusText = "Đã lỡ";
          color = const Color(0xFFE7000A);
          bg = const Color(0xFFFEF2F2);
        }

        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: _buildMedicineCard(
            context,
            pill: pill,
            statusText: statusText,
            statusColor: color,
            statusBg: bg,
            onDelete: () =>
                _confirmDelete(context, vm, pill), // Tích hợp hàm xóa
          ),
        );
      }).toList(),
    );
  }

  Widget _buildMedicineCard(
    BuildContext context, {
    required SchedulePill pill,
    required String statusText,
    required Color statusColor,
    required Color statusBg,
    required VoidCallback onDelete,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: Color(0xFFEFF6FF),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.medication,
                      color: Color(0xFF2563EB),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pill.medicineName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${pill.time} • ${pill.dosage}',
                        style: const TextStyle(
                          color: Color(0xFF697282),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: statusBg,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  statusText,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const Divider(height: 24),
          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  Icons.edit,
                  "Sửa",
                  const Color(0xFFF3F4F6),
                  Colors.black87,
                  () {
                    // Logic sửa thuốc (Navigator đến trang Edit)
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildActionButton(
                  Icons.delete_outline,
                  "Xóa",
                  const Color(0xFFFEF2F2),
                  const Color(0xFFE7000A),
                  onDelete,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    IconData icon,
    String label,
    Color bg,
    Color textColor,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16, color: textColor),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(color: textColor, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  // --- LOGIC XÓA THUỐC ---

  void _confirmDelete(
    BuildContext context,
    SchedulePillViewModel vm,
    SchedulePill pill,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Xóa lịch uống thuốc?"),
        content: Text(
          "Bạn có chắc chắn muốn xóa '${pill.medicineName}' không?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Hủy"),
          ),
          TextButton(
            onPressed: () {
              vm.deleteSchedulePill(pill.id); // Gọi ViewModel xóa dữ liệu
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Đã xóa thành công")),
              );
            },
            child: const Text("Xóa", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      height: 85,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavItem(
            icon: Icons.grid_view_rounded,
            label: "Tổng quan",
            isActive: true,
          ),
          _NavItem(
            icon: Icons.add_circle_outline,
            label: "Thêm lịch",
            isActive: false,
          ),
          _NavItem(icon: Icons.history, label: "Lịch sử", isActive: false),
          _NavItem(
            icon: Icons.settings_outlined,
            label: "Cài đặt",
            isActive: false,
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  const _NavItem({
    required this.icon,
    required this.label,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: isActive ? const Color(0xFF2563EB) : const Color(0xFF6B7280),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: isActive ? const Color(0xFF2563EB) : const Color(0xFF6B7280),
          ),
        ),
      ],
    );
  }
}
