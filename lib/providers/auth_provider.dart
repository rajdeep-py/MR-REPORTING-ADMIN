import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../models/admin_user.dart';
import '../notifiers/auth_notifier.dart';

final authProvider =
    StateNotifierProvider<AuthNotifier, AsyncValue<AdminUser?>>((ref) {
      return AuthNotifier();
    });
