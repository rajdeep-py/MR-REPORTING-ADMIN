import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../models/admin_user.dart';

class AuthNotifier extends StateNotifier<AsyncValue<AdminUser?>> {
  AuthNotifier() : super(const AsyncValue.data(null));

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      // Simulate network request
      await Future.delayed(const Duration(seconds: 2));

      // Basic dummy validation
      if (email.isNotEmpty && password.length >= 6) {
        state = AsyncValue.data(
          AdminUser(id: '1', email: email, name: 'Organisation Admin'),
        );
      } else {
        throw Exception('Invalid email or password');
      }
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  void logout() {
    state = const AsyncValue.data(null);
  }
}
