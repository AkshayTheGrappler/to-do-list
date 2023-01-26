import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:todo_list/core/errors/failures.dart';
import 'package:todo_list/core/usecase/usecase.dart';
import 'package:todo_list/features/tasks/domain/repository/task_respository.dart';

class DeleteTaskUseCase extends Usecase<bool, Params> {
  final TaskRepository? taskRepository;
  DeleteTaskUseCase({required this.taskRepository});

  @override
  Future<Either<Failure, bool>> call(Params params) async {
    return await taskRepository!
        .deleteTask(taskId: params.taskId!, username: params.username);
  }
}

class Params extends Equatable {
  final int? taskId;
  final String? username;
  const Params({required this.taskId, required this.username});

  @override
  List<Object?> get props => [taskId];
}
