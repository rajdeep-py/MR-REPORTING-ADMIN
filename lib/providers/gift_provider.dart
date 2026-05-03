import 'package:flutter_riverpod/legacy.dart';
import '../notifiers/gift_notifier.dart';

final giftProvider = StateNotifierProvider<GiftNotifier, GiftState>((ref) {
  return GiftNotifier();
});
