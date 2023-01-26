import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:todo_list/core/errors/failures.dart';
import 'package:todo_list/core/usecase/usecase.dart';
import 'package:todo_list/features/tasks/domain/entities/task.dart';
import 'package:todo_list/features/tasks/domain/repository/task_respository.dart';

class GetTasksUseCase implements Usecase<List<TaskEntity>, Params> {
  final TaskRepository? taskRepository;
  const GetTasksUseCase({required this.taskRepository});

  @override
  Future<Either<Failure, List<TaskEntity>>> call(Params params) async {
    return await taskRepository!.getTasks(username: params.username!);
  }
}

class Params extends Equatable {
  final String? username;
  const Params({required this.username});

  @override
  List<Object?> get props => [username];
}
