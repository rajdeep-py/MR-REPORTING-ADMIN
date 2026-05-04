import 'package:flutter_riverpod/legacy.dart' show StateNotifierProvider;
import '../notifiers/team_notifier.dart';

final teamProvider = StateNotifierProvider<TeamNotifier, TeamState>((ref) {
  return TeamNotifier();
});
