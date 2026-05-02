import 'package:flutter_riverpod/legacy.dart';
import '../models/team.dart';

class TeamState {
  final List<Team> teams;
  final bool isLoading;
  final String? error;
  final String searchQuery;

  const TeamState({
    this.teams = const [],
    this.isLoading = false,
    this.error,
    this.searchQuery = '',
  });

  TeamState copyWith({
    List<Team>? teams,
    bool? isLoading,
    String? error,
    String? searchQuery,
  }) {
    return TeamState(
      teams: teams ?? this.teams,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class TeamNotifier extends StateNotifier<TeamState> {
  TeamNotifier() : super(const TeamState()) {
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    state = state.copyWith(isLoading: true);
    await Future.delayed(const Duration(seconds: 1)); // Mock network delay
    state = state.copyWith(
      isLoading: false,
      teams: [
        const Team(
          id: 'T001',
          name: 'Alpha Squad',
          description: 'Primary medical representative team covering north sector hospitals and clinics.',
          memberIds: ['EMP001', 'EMP002'],
        ),
      ],
    );
  }

  Future<void> addTeam(Team team) async {
    state = state.copyWith(isLoading: true);
    await Future.delayed(const Duration(milliseconds: 500));
    state = state.copyWith(
      isLoading: false,
      teams: [...state.teams, team],
    );
  }

  Future<void> updateTeam(Team updatedTeam) async {
    state = state.copyWith(isLoading: true);
    await Future.delayed(const Duration(milliseconds: 500));
    final newTeams = state.teams.map((t) => t.id == updatedTeam.id ? updatedTeam : t).toList();
    state = state.copyWith(
      isLoading: false,
      teams: newTeams,
    );
  }

  Future<void> deleteTeam(String id) async {
    state = state.copyWith(isLoading: true);
    await Future.delayed(const Duration(milliseconds: 500));
    final newTeams = state.teams.where((t) => t.id != id).toList();
    state = state.copyWith(
      isLoading: false,
      teams: newTeams,
    );
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }
}
