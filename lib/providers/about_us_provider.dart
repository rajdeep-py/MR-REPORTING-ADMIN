import 'package:flutter_riverpod/legacy.dart';
import '../notifiers/about_us_notifier.dart';
import '../models/about_us.dart';

final aboutUsProvider = StateNotifierProvider<AboutUsNotifier, AboutUs>((ref) {
  return AboutUsNotifier();
});
