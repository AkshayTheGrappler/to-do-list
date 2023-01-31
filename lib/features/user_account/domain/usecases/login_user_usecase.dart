import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_list/core/errors/failures.dart';
import 'package:todo_list/core/usecase/usecase.dart';
import 'package:todo_list/features/user_account/domain/repository/user_account_respository.dart';

class LoginUserUseCase implements Usecase<UserCredential, NoParams> {
  final UserAccountRepository? userAccountRepository;

  const LoginUserUseCase({required this.userAccountRepository});

  @override
  Future<Either<Failure, UserCredential>> call(NoParams params) async {
    return await userAccountRepository!.loginUser();
  }
}

class NoParams extends Equatable {
  @override
  List<Object?> get props => [];
}
