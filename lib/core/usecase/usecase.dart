import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:todo_list/core/errors/failures.dart';

abstract class Usecase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

class NoParams extends Equatable {
  @override
  List<Object?> get props => [];
}
