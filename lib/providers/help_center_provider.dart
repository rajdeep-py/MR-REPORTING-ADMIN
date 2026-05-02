import 'package:flutter_riverpod/legacy.dart';
import '../notifiers/help_center_notifier.dart';
import '../models/help_center.dart';

final helpCenterProvider = StateNotifierProvider<HelpCenterNotifier, HelpCenter>((ref) {
  return HelpCenterNotifier();
});
