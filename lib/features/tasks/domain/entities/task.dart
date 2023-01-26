import 'package:equatable/equatable.dart';

class TaskEntity extends Equatable {
  final int? taskId;
  final String? taskName;
  final String? taskDescription;
  final String? taskDate;

  const TaskEntity({
    required this.taskId,
    required this.taskName,
    required this.taskDescription,
    required this.taskDate,
  });

  @override
  List<Object?> get props => [taskId, taskName, taskDescription, taskDate];
}
