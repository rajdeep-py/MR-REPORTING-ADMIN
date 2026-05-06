// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:iconsax/iconsax.dart';
// import 'package:intl/intl.dart';
// import 'dart:io';
// import '../../theme/app_theme.dart';
// import '../../models/gift.dart';
// import '../../providers/employee_provider.dart';
// import '../../providers/doctor_provider.dart';
// import '../../providers/gift_provider.dart';

// class GiftRequestCard extends ConsumerWidget {
//   final GiftRequest request;
//   const GiftRequestCard({super.key, required this.request});

//   Color _getStatusColor(String status) {
//     switch (status.toLowerCase()) {
//       case 'approved':
//         return Colors.green;
//       case 'pending':
//         return Colors.orange;
//       case 'cancelled':
//         return Colors.red;
//       default:
//         return AppColors.darkGrey;
//     }
//   }

//   void _showStatusChangeDialog(BuildContext context, WidgetRef ref) {
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: AppColors.white,
//       shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
//       builder: (context) {
//         return Padding(
//           padding: const EdgeInsets.all(24),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Text('Update Request Status', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
//               AppGaps.largeV,
//               _buildStatusOption(context, ref, request.id, 'pending', 'Pending', Colors.orange),
//               _buildStatusOption(context, ref, request.id, 'approved', 'Approved', Colors.green),
//               _buildStatusOption(context, ref, request.id, 'cancelled', 'Cancelled', Colors.red),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildStatusOption(BuildContext context, WidgetRef ref, String reqId, String statusValue, String statusLabel, Color color) {
//     return InkWell(
//       onTap: () {
//         ref.read(giftProvider.notifier).updateRequestStatus(reqId, statusValue);
//         Navigator.pop(context);
//       },
//       child: Container(
//         padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
//         margin: const EdgeInsets.only(bottom: 8),
//         decoration: BoxDecoration(
//           color: color.withAlpha(20),
//           borderRadius: BorderRadius.circular(16),
//           border: Border.all(color: color.withAlpha(50)),
//         ),
//         child: Row(
//           children: [
//             Container(width: 16, height: 16, decoration: BoxDecoration(shape: BoxShape.circle, color: color)),
//             const SizedBox(width: 12),
//             Text(statusLabel, style: TextStyle(color: color, fontWeight: FontWeight.w700, fontSize: 16)),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final statusColor = _getStatusColor(request.status);
    
//     final employees = ref.watch(employeeProvider);
//     final employeeMatches = employees.employees.where((e) => e.id == request.employeeId).toList();
//     final employee = employeeMatches.isNotEmpty ? employeeMatches.first : null;

//     final doctors = ref.watch(doctorProvider);
//     final doctorMatches = doctors.doctors.where((d) => d.id == request.doctorId).toList();
//     final doctor = doctorMatches.isNotEmpty ? doctorMatches.first : null;

//     final state = ref.watch(giftProvider);
//     final itemMatches = state.inventory.where((i) => i.id == request.giftItemId).toList();
//     final item = itemMatches.isNotEmpty ? itemMatches.first : null;

//     return Container(
//       margin: const EdgeInsets.only(bottom: 16),
//       padding: const EdgeInsets.all(24),
//       decoration: BoxDecoration(
//         color: AppColors.white,
//         borderRadius: BorderRadius.circular(24),
//         border: Border.all(color: AppColors.lightGrey.withAlpha(128)),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Row(
//                 children: [
//                   const Icon(Iconsax.receipt_2, size: 16, color: AppColors.darkGrey),
//                   const SizedBox(width: 6),
//                   Text(request.id, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
//                 ],
//               ),
//               InkWell(
//                 onTap: () => _showStatusChangeDialog(context, ref),
//                 borderRadius: BorderRadius.circular(20),
//                 child: Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                   decoration: BoxDecoration(
//                     color: statusColor.withAlpha(25),
//                     borderRadius: BorderRadius.circular(20),
//                     border: Border.all(color: statusColor.withAlpha(50)),
//                   ),
//                   child: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Text(
//                         request.status.toUpperCase(),
//                         style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 10),
//                       ),
//                       const SizedBox(width: 4),
//                       Icon(Iconsax.arrow_down_1, size: 12, color: statusColor),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           AppGaps.mediumV,
//           Row(
//             children: [
//               const Icon(Iconsax.calendar_1, size: 14, color: AppColors.darkGrey),
//               const SizedBox(width: 6),
//               Text('Requested on: ${DateFormat('MMM dd, yyyy').format(request.requestedOn)}', style: const TextStyle(color: AppColors.darkGrey, fontSize: 13)),
//             ],
//           ),
//           AppGaps.mediumV,
//           const Divider(color: AppColors.lightGrey),
//           AppGaps.mediumV,
          
//           if (employee != null)
//             Padding(
//               padding: const EdgeInsets.only(bottom: 16),
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Container(
//                     width: 40,
//                     height: 40,
//                     decoration: BoxDecoration(
//                       color: AppColors.surface,
//                       borderRadius: BorderRadius.circular(12),
//                       image: employee.profilePhotoPath != null ? DecorationImage(
//                         image: NetworkImage(employee.profilePhotoPath!),
//                         fit: BoxFit.cover,
//                       ) : null,
//                     ),
//                     child: employee.profilePhotoPath == null ? const Icon(Iconsax.user, color: AppColors.darkGrey) : null,
//                   ),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const Text('Requested By', style: TextStyle(color: AppColors.darkGrey, fontSize: 11, fontWeight: FontWeight.w600)),
//                         const SizedBox(height: 2),
//                         Text(employee.fullName, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
//                         const SizedBox(height: 2),
//                         Text('${employee.headquarter} • ${employee.phoneNo}', style: const TextStyle(color: AppColors.darkGrey, fontSize: 12)),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
          
//           if (doctor != null)
//             Padding(
//               padding: const EdgeInsets.only(bottom: 16),
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Container(
//                     padding: const EdgeInsets.all(10),
//                     decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12)),
//                     child: const Icon(Iconsax.health, color: AppColors.black, size: 20),
//                   ),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const Text('Requested For', style: TextStyle(color: AppColors.darkGrey, fontSize: 11, fontWeight: FontWeight.w600)),
//                         const SizedBox(height: 2),
//                         Text(doctor.name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
//                         const SizedBox(height: 2),
//                         Text('${doctor.specialization} • ${doctor.phoneNo}', style: const TextStyle(color: AppColors.darkGrey, fontSize: 12)),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
            
//           Container(
//             padding: const EdgeInsets.all(12),
//             decoration: BoxDecoration(
//               color: AppColors.background,
//               borderRadius: BorderRadius.circular(16),
//             ),
//             child: Row(
//               children: [
//                 if (item != null)
//                   Container(
//                     width: 48,
//                     height: 48,
//                     margin: const EdgeInsets.only(right: 12),
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(8),
//                       image: DecorationImage(
//                         image: item.imageUrl.startsWith('http')
//                             ? NetworkImage(item.imageUrl) as ImageProvider
//                             : FileImage(File(item.imageUrl)),
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                   ),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(item?.name ?? 'Unknown Item', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
//                       const SizedBox(height: 4),
//                       Text('Occasion: ${request.occasion}', style: const TextStyle(color: AppColors.darkGrey, fontSize: 12, fontWeight: FontWeight.w500)),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
