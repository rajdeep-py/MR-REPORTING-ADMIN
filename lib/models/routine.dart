class RoutineTask {
  final String id;
  final String title;
  final String description;
  final String time;

  const RoutineTask({
    required this.id,
    required this.title,
    required this.description,
    required this.time,
  });

  RoutineTask copyWith({
    String? id,
    String? title,
    String? description,
    String? time,
  }) {
    return RoutineTask(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      time: time ?? this.time,
    );
  }
}

class Routine {
  final String id;
  final String employeeId;
  final DateTime date;
  final List<RoutineTask> tasks;

  const Routine({
    required this.id,
    required this.employeeId,
    required this.date,
    required this.tasks,
  });

  Routine copyWith({
    String? id,
    String? employeeId,
    DateTime? date,
    List<RoutineTask>? tasks,
  }) {
    return Routine(
      id: id ?? this.id,
      employeeId: employeeId ?? this.employeeId,
      date: date ?? this.date,
      tasks: tasks ?? this.tasks,
    );
  }
}
