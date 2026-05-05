import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../models/admin_user.dart';
import '../services/auth_profile/auth_profile_services.dart';

class AuthNotifier extends StateNotifier<AsyncValue<AdminUser?>> {
  final AuthProfileServices _services = AuthProfileServices();

  AuthNotifier() : super(const AsyncValue.data(null));

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      final user = await _services.login(email, password);
      if (user != null) {
        state = AsyncValue.data(user);
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

  void updateUser(AdminUser user) {
    state = AsyncValue.data(user);
  }
}
