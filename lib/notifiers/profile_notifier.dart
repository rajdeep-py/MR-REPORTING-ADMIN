import 'dart:typed_data';
import 'package:flutter_riverpod/legacy.dart';
import '../models/admin_user.dart';
import '../services/auth_profile/auth_profile_services.dart';

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
  final AuthProfileServices _services = AuthProfileServices();

  ProfileNotifier() : super(ProfileState());

  void init(AdminUser? loggedInUser) {
    if (state.user == null && loggedInUser != null) {
      state = state.copyWith(user: loggedInUser);
      fetchProfile(loggedInUser.adminId);
    }
  }

  Future<void> fetchProfile(String adminId) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final user = await _services.getAdminById(adminId);
      if (user != null) {
        state = state.copyWith(user: user, isLoading: false);
      }
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  Future<void> updateProfile({
    required String adminId,
    String? organisationName,
    String? phoneNo,
    String? alternativePhnNo,
    String? email,
    String? password,
    String? registeredAddress,
    String? gstinNo,
    Uint8List? imageBytes,
    String? imageName,
  }) async {
    state = state.copyWith(isLoading: true, error: null, isSuccess: false);

    try {
      final updatedUser = await _services.updateAdminProfile(
        adminId: adminId,
        organisationName: organisationName,
        phoneNo: phoneNo,
        alternativePhnNo: alternativePhnNo,
        email: email,
        password: password,
        registeredAddress: registeredAddress,
        gstinNo: gstinNo,
        imageBytes: imageBytes,
        imageName: imageName,
      );

      if (updatedUser != null) {
        state = state.copyWith(
          user: updatedUser,
          isSuccess: true,
          isLoading: false,
        );
      }
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to update profile: $e',
        isLoading: false,
      );
    }
  }
}
