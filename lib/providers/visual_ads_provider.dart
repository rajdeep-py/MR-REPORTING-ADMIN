import 'package:flutter_riverpod/legacy.dart';
import '../notifiers/visual_ads_notifier.dart';

final visualAdsProvider = StateNotifierProvider<VisualAdsNotifier, VisualAdsState>((ref) {
  return VisualAdsNotifier();
});
