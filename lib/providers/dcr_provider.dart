import 'package:flutter_riverpod/legacy.dart';
import '../notifiers/dcr_notifier.dart';

final dcrProvider = StateNotifierProvider<DcrNotifier, DcrState>((ref) {
  return DcrNotifier();
});
