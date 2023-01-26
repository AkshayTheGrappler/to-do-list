import 'package:dartz/dartz.dart';
import 'package:todo_list/core/errors/failures.dart';
import 'package:todo_list/features/tasks/domain/entities/task.dart';

abstract class TaskRepository {
  Future<Either<Failure, bool>> createTask(
      {required Map<String, dynamic> task});
  Future<Either<Failure, bool>> updateTask(
      {required Map<String, dynamic> task});
  Future<Either<Failure, bool>> deleteTask(
      {required int taskId, required String? username});
  Future<Either<Failure, List<TaskEntity>>> getTasks(
      {required String username});
}
