import 'package:flutter_riverpod/legacy.dart';
import '../models/admin_user.dart';

class ProfileState {
  final AdminUser? user;
  final bool isLoading;
  final String? error;
  final bool isSuccess;

  ProfileState({
    this.user,
    this.isLoading = false,
    this.error,
    this.isSuccess = false,
  });

  ProfileState copyWith({
    AdminUser? user,
    bool? isLoading,
    String? error,
    bool? isSuccess,
  }) {
    return ProfileState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}

class ProfileNotifier extends StateNotifier<ProfileState> {
  ProfileNotifier() : super(ProfileState());

  void init(AdminUser? loggedInUser) {
    if (state.user == null && loggedInUser != null) {
      state = state.copyWith(
        user: loggedInUser.copyWith(
          companyId: loggedInUser.companyId ?? 'COMP-12345',
          companyName: loggedInUser.companyName ?? 'Naiyo24 Tech',
          cinNo: loggedInUser.cinNo ?? 'L12345MH2024PTC123456',
          gstin: loggedInUser.gstin ?? '22AAAAA0000A1Z5',
          address: loggedInUser.address ?? '123 Tech Park, Mumbai',
          phoneNo: loggedInUser.phoneNo ?? '+91 9876543210',
          alternativePhoneNo:
              loggedInUser.alternativePhoneNo ?? '+91 8765432109',
        ),
      );
    }
  }

  Future<void> updateProfile({
    required String companyId,
    required String address,
    required String phoneNo,
    required String alternativePhoneNo,
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, error: null, isSuccess: false);

    try {
      await Future.delayed(const Duration(seconds: 1)); // Simulate API call

      if (state.user != null) {
        state = state.copyWith(
          user: state.user!.copyWith(
            companyId: companyId,
            address: address,
            phoneNo: phoneNo,
            alternativePhoneNo: alternativePhoneNo,
            email: email,
          ),
          isSuccess: true,
          isLoading: false,
        );
      }
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to update profile',
        isLoading: false,
      );
    }
  }
}
