import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:todo_list/core/errors/failures.dart';
import 'package:todo_list/core/usecase/usecase.dart';
import 'package:todo_list/features/tasks/domain/repository/task_respository.dart';

class UpdateTaskUseCase extends Usecase<bool, Params> {
  final TaskRepository? taskRepository;
  UpdateTaskUseCase({required this.taskRepository});

  @override
  Future<Either<Failure, bool>> call(Params params) async {
    return await taskRepository!.updateTask(task: params.task!);
  }
}

class Params extends Equatable {
  final Map<String, dynamic>? task;
  const Params({
    required this.task,
  });

  @override
  List<Object?> get props => [task];
}
