import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/side_nav_bar.dart';
import '../../providers/doctor_provider.dart';
import '../../providers/employee_provider.dart';
import '../../cards/doctor/doctor_search_filter_card.dart';
import '../../cards/doctor/doctor_card.dart';

class DoctorsScreen extends ConsumerWidget {
  const DoctorsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(doctorProvider);
    final employees = ref.watch(employeeProvider);

    final filteredDoctors = state.doctors.where((doc) {
      if (state.searchDoctorQuery.isNotEmpty) {
        final query = state.searchDoctorQuery.toLowerCase();
        if (!doc.name.toLowerCase().contains(query) && !doc.phoneNo.contains(query)) {
          return false;
        }
      }
      if (state.filterSpecialization != 'All' && doc.specialization != state.filterSpecialization) {
        return false;
      }
      if (state.searchEmployeeQuery.isNotEmpty) {
        final empQuery = state.searchEmployeeQuery.toLowerCase();
        bool match = false;
        for (var emp in employees.employees) {
          if (emp.id == doc.employeeId && emp.fullName.toLowerCase().contains(empQuery)) {
            match = true;
            break;
          }
        }
        if (!match) return false;
      }
      return true;
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: PremiumAppBar(
        title: 'Doctor Connections',
        subtitle: 'Manage and search your doctor network',
        actions: [
          PremiumAppbarAction(icon: Iconsax.document_download, onTap: () {}),
        ],
      ),
      drawer: const SideNavBar(),
      body: Padding(
        padding: const EdgeInsets.all(AppGaps.screenPadding),
        child: Column(
          children: [
            const DoctorSearchFilterCard(),
            AppGaps.largeV,
            Expanded(
              child: filteredDoctors.isEmpty
                  ? const Center(child: Text('No doctors found.', style: TextStyle(color: AppColors.darkGrey)))
                  : ListView.builder(
                      itemCount: filteredDoctors.length,
                      itemBuilder: (context, index) {
                        return DoctorCard(doctor: filteredDoctors[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
