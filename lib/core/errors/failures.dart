import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  @override
  List<Object?> get props => [];
}

class DatabaseFailure extends Failure {}

class ServerFailure extends Failure {}

class InvalidCredFailure extends Failure {}

class InternetFailure extends Failure {}

class InvalidEmailFailure extends Failure {}

class InvalidPasswordFailure extends Failure {}

class UserAlreadyExistsFailure extends Failure {}
