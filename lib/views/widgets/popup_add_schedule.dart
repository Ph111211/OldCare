// import 'package:flutter/material.dart';

// class PopupAddSchedule extends StatelessWidget {
//   const PopupAddSchedule({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 4,
//             offset: const Offset(0, 1),
//           ),
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 10,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Tên thuốc
//           _buildInputField(
//             label: 'Tên thuốc',
//             value: 'Thuốc Huyết áp',
//           ),
//           const SizedBox(height: 16),

//           // Giờ uống và Liều lượng (Chia 2 cột)
//           Row(
//             children: [
//               Expanded(
//                 child: _buildInputField(
//                   label: 'Giờ uống',
//                   value: '08:00 AM',
//                   suffixIcon: Icons.access_time,
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: _buildInputField(
//                   label: 'Liều lượng',
//                   value: '1 viên',
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 16),

//           // Tần suất
//           _buildInputField(
//             label: 'Tần suất',
//             value: 'Hàng ngày',
//             suffixIcon: Icons.arrow_drop_down,
//           ),
//           const SizedBox(height: 16),

//           // Ghi chú
//           _buildInputField(
//             label: 'Ghi chú (tùy chọn)',
//             value: 'Sau bữa sáng',
//             isHint: true,
//           ),
//           const SizedBox(height: 24),

//           // Nút bấm Lưu / Hủy
//           Row(
//             children: [
//               Expanded(
//                 child: _buildButton(
//                   label: 'Lưu',
//                   onPressed: () {},
//                   color: const Color(0xFF2B7FFF),
//                   textColor: Colors.white,
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: _buildButton(
//                   label: 'Hủy',
//                   onPressed: () {
//                     Navigator.pop(context);
//                   },
//                   color: const Color(0xFFE5E7EB),
//                   textColor: const Color(0xFF354152),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   // Widget dùng chung cho các ô nhập liệu (View-only hoặc Trigger)
//   Widget _buildInputField({
//     required String label,
//     required String value,
//     IconData? suffixIcon,
//     bool isHint = false,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style: const TextStyle(
//             color: Color(0xFF697282),
//             fontSize: 14,
//             fontWeight: FontWeight.w400,
//           ),
//         ),
//         const SizedBox(height: 6),
//         Container(
//           width: double.infinity,
//           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             border: Border.all(color: const Color(0xFFE5E7EB)),
//             borderRadius: BorderRadius.circular(10),
//           ),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 value,
//                 style: TextStyle(
//                   color: isHint ? const Color(0x7F101727) : const Color(0xFF101727),
//                   fontSize: 16,
//                   fontWeight: FontWeight.w400,
//                 ),
//               ),
//               if (suffixIcon != null)
//                 Icon(suffixIcon, size: 18, color: const Color(0xFF697282)),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   // Widget dùng chung cho Nút bấm
//   Widget _buildButton({
//     required String label,
//     required VoidCallback onPressed,
//     required Color color,
//     required Color textColor,
//   }) {
//     return GestureDetector(
//       onTap: onPressed,
//       child: Container(
//         height: 44,
//         alignment: Alignment.center,
//         decoration: BoxDecoration(
//           color: color,
//           borderRadius: BorderRadius.circular(10),
//         ),
//         child: Text(
//           label,
//           style: TextStyle(
//             color: textColor,
//             fontSize: 16,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/schedulePill.model.dart';
import '../../viewmodels/schedulePill/schedulePill.viewmodel.dart';

class PopupAddSchedule extends StatefulWidget {
  final SchedulePill pill;
  const PopupAddSchedule({super.key, required this.pill});

  @override
  State<PopupAddSchedule> createState() => _PopupAddScheduleState();
}

class _PopupAddScheduleState extends State<PopupAddSchedule> {
  late TextEditingController _nameCtrl;
  late TextEditingController _dosageCtrl;
  late String _time;
  late String _freq;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.pill.medicineName);
    _dosageCtrl = TextEditingController(text: widget.pill.dosage);
    _time = widget.pill.time;
    _freq = widget.pill.frequency;
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<SchedulePillViewModel>(context, listen: false);

    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Chỉnh sửa lịch uống",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildTextField("Tên thuốc", _nameCtrl),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildTimePicker()),
              const SizedBox(width: 12),
              Expanded(child: _buildTextField("Liều lượng", _dosageCtrl)),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: _buildBtn("Lưu", Colors.blue, Colors.white, () async {
                  // THỰC HIỆN CẬP NHẬT
                  // final childID
                  // await vm.saveSchedulePill(
                  //   id: widget.pill.id,
                  //   medicineName: _nameCtrl.text,
                  //   time: _time,
                  //   dosage: _dosageCtrl.text,
                  //   frequency: _freq,
                  // );
                  Navigator.pop(context);
                }),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildBtn(
                  "Hủy",
                  Colors.grey.shade200,
                  Colors.black,
                  () => Navigator.pop(context),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController ctrl) {
    return TextField(
      controller: ctrl,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget _buildTimePicker() {
    return InkWell(
      onTap: () async {
        TimeOfDay? picked = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        );
        if (picked != null) setState(() => _time = picked.format(context));
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(_time),
      ),
    );
  }

  Widget _buildBtn(String txt, Color bg, Color tc, VoidCallback fn) {
    return ElevatedButton(
      onPressed: fn,
      style: ElevatedButton.styleFrom(backgroundColor: bg, foregroundColor: tc),
      child: Text(txt),
    );
  }
}
