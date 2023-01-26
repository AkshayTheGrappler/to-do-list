import 'package:dartz/dartz.dart';
import 'package:todo_list/core/errors/failures.dart';
import 'package:todo_list/core/utilities/internet_checker.dart';
import 'package:todo_list/features/tasks/data/datasources/task_respository_data_source.dart';
import 'package:todo_list/features/tasks/domain/entities/task.dart';
import 'package:todo_list/features/tasks/domain/repository/task_respository.dart';

class TaskRepositoryImpl implements TaskRepository {
  final InternetChecker? internetChecker;
  final TaskRepositoryDataSource? dataSource;

  const TaskRepositoryImpl({
    required this.dataSource,
    required this.internetChecker,
  });

  @override
  Future<Either<Failure, bool>> createTask(
      {required Map<String, dynamic> task}) async {
    if (await internetChecker!.checkConnection()) {
      try {
        var createdTask = await dataSource!.createTask(task: task);
        return Right(createdTask);
      } catch (exception) {
        return Left(InvalidCredFailure());
      }
    } else {
      return Left(InternetFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> deleteTask(
      {required int taskId, required String? username}) async {
    if (await internetChecker!.checkConnection()) {
      try {
        var deletedTask =
            await dataSource!.deleteTask(taskId: taskId, username: username);
        return Right(deletedTask);
      } catch (exception) {
        return Left(InvalidCredFailure());
      }
    } else {
      return Left(InternetFailure());
    }
  }

  @override
  Future<Either<Failure, List<TaskEntity>>> getTasks(
      {required String username}) async {
    if (await internetChecker!.checkConnection()) {
      try {
        var taskList = await dataSource!.getTasks(username: username);
        return Right(taskList);
      } catch (exception) {
        return Left(InvalidCredFailure());
      }
    } else {
      return Left(InternetFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> updateTask(
      {required Map<String, dynamic> task}) async {
    if (await internetChecker!.checkConnection()) {
      try {
        var updatedTask = await dataSource!.updateTask(task: task);
        return Right(updatedTask);
      } catch (exception) {
        return Left(InvalidCredFailure());
      }
    } else {
      return Left(InternetFailure());
    }
  }
}
