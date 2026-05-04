import 'package:flutter_riverpod/legacy.dart';
import '../models/doctor.dart';

class DoctorState {
  final List<Doctor> doctors;
  final String searchDoctorQuery; // Name or Phone
  final String searchEmployeeQuery; // Employee name
  final String
  filterSpecialization; // e.g. "All", "Cardiologist", "Neurologist", etc.

  DoctorState({
    this.doctors = const [],
    this.searchDoctorQuery = '',
    this.searchEmployeeQuery = '',
    this.filterSpecialization = 'All',
  });

  DoctorState copyWith({
    List<Doctor>? doctors,
    String? searchDoctorQuery,
    String? searchEmployeeQuery,
    String? filterSpecialization,
  }) {
    return DoctorState(
      doctors: doctors ?? this.doctors,
      searchDoctorQuery: searchDoctorQuery ?? this.searchDoctorQuery,
      searchEmployeeQuery: searchEmployeeQuery ?? this.searchEmployeeQuery,
      filterSpecialization: filterSpecialization ?? this.filterSpecialization,
    );
  }
}

class DoctorNotifier extends StateNotifier<DoctorState> {
  DoctorNotifier() : super(DoctorState()) {
    _loadMockData();
  }

  void _loadMockData() async {
    await Future.delayed(const Duration(milliseconds: 500));
    state = state.copyWith(
      doctors: [
        const Doctor(
          id: '1',
          name: 'Dr. Sarah Mitchell',
          profilePhotoPath:
              'https://images.unsplash.com/photo-1559839734-2b71ea197ec2?w=400&q=80',
          specialization: 'Cardiologist',
          phoneNo: '+1 234 567 8901',
          email: 'sarah.mitchell@hospital.com',
          address: '123 Medical Center Blvd, Suite 400',
          employeeId: '1',
          education:
              'MD from Harvard Medical School, Residency at Johns Hopkins',
          experience: '12 Years',
          description:
              'Dr. Mitchell is a board-certified cardiologist with a special interest in preventive cardiology and heart failure management. She is known for her compassionate patient care.',
          chambers: [
            DoctorChamber(
              name: 'City Heart Clinic',
              phoneNo: '+1 234 567 8902',
              address: '45 Heart Lane, Cityville',
            ),
            DoctorChamber(
              name: 'Northside General',
              phoneNo: '+1 234 567 8903',
              address: '100 Northside Rd, Cityville',
            ),
          ],
        ),
        const Doctor(
          id: '2',
          name: 'Dr. James Wilson',
          profilePhotoPath:
              'https://images.unsplash.com/photo-1612349317150-e413f6a5b16d?w=400&q=80',
          specialization: 'Neurologist',
          phoneNo: '+1 987 654 3210',
          email: 'j.wilson@neurocare.com',
          address: '88 Brain Ave, Mind City',
          employeeId: '2',
          education: 'MBBS from Oxford University, MD in Neurology',
          experience: '8 Years',
          description:
              'Dr. Wilson specializes in treating complex neurological disorders including epilepsy and multiple sclerosis.',
          chambers: [
            DoctorChamber(
              name: 'NeuroCare Center',
              phoneNo: '+1 987 654 3211',
              address: '88 Brain Ave, Mind City',
            ),
          ],
        ),
      ],
    );
  }

  void setSearchDoctorQuery(String query) {
    state = state.copyWith(searchDoctorQuery: query);
  }

  void setSearchEmployeeQuery(String query) {
    state = state.copyWith(searchEmployeeQuery: query);
  }

  void setFilterSpecialization(String spec) {
    state = state.copyWith(filterSpecialization: spec);
  }
}
