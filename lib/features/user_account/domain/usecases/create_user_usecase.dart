import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_list/core/errors/failures.dart';
import 'package:todo_list/core/usecase/usecase.dart';
import 'package:todo_list/features/user_account/domain/repository/user_account_respository.dart';

class CreateUserUseCase implements Usecase<UserCredential, Params> {
  final UserAccountRepository? userAccountRepository;

  const CreateUserUseCase({required this.userAccountRepository});

  @override
  Future<Either<Failure, UserCredential>> call(Params params) async {
    return await userAccountRepository!
        .createUser(username: params.username!, password: params.password!);
  }
}

class Params extends Equatable {
  final String? username;
  final String? password;

  const Params({required this.username, required this.password});

  @override
  List<Object?> get props => [username, password];
}
