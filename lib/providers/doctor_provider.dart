import 'package:flutter_riverpod/legacy.dart';
import '../notifiers/doctor_notifier.dart';

final doctorProvider = StateNotifierProvider<DoctorNotifier, DoctorState>((
  ref,
) {
  return DoctorNotifier();
});
