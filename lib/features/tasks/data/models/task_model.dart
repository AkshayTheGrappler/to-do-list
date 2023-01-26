import 'package:todo_list/features/tasks/domain/entities/task.dart';

class TaskModel extends TaskEntity {
  const TaskModel({
    required super.taskId,
    required super.taskName,
    required super.taskDescription,
    required super.taskDate,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      taskId: json['taskId'],
      taskName: json['taskName'],
      taskDescription: json['taskDescription'],
      taskDate: json['taskDate'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'taskId': taskId,
      'taskName': taskName,
      'taskDescription': taskDescription,
      'taskDate': taskDate,
    };
  }
}
