import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:todo_list/core/errors/failures.dart';
import 'package:todo_list/core/usecase/usecase.dart';
import 'package:todo_list/features/user_account/domain/repository/user_account_respository.dart';

class LogoutUserUseCase implements Usecase<bool, NoParams> {
  final UserAccountRepository? userAccountRepository;

  const LogoutUserUseCase({required this.userAccountRepository});

  @override
  Future<Either<Failure, bool>> call(NoParams params) async {
    return await userAccountRepository!.logoutUser();
  }
}

class NoParams extends Equatable {
  @override
  List<Object?> get props => [];
}
