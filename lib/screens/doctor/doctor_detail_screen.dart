import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';
import '../../providers/doctor_provider.dart';
import '../../cards/doctor/doctor_header_card.dart';
import '../../cards/doctor/doctor_education_specialization_card.dart';
import '../../cards/doctor/doctor_description_card.dart';
import '../../cards/doctor/doctor_chambers_card.dart';
import '../../cards/doctor/doctor_contact_card.dart';

class DoctorDetailScreen extends ConsumerWidget {
  final String id;
  const DoctorDetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(doctorProvider);
    final doctorMatches = state.doctors.where((d) => d.id == id).toList();
    
    if (doctorMatches.isEmpty) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: PremiumAppBar(title: 'Doctor Not Found', showBackButton: true, onMenuTap: () => context.pop()),
        body: const Center(child: Text('The doctor could not be found.')),
      );
    }
    
    final doctor = doctorMatches.first;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: PremiumAppBar(
        title: doctor.name,
        subtitle: doctor.specialization,
        showBackButton: true,
        onMenuTap: () => context.pop(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppGaps.screenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DoctorHeaderCard(doctor: doctor),
            DoctorEducationSpecializationCard(doctor: doctor),
            DoctorDescriptionCard(doctor: doctor),
            DoctorChambersCard(doctor: doctor),
            DoctorContactCard(doctor: doctor),
          ],
        ),
      ),
    );
  }
}
