import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:todo_list/core/errors/failures.dart';
import 'package:todo_list/core/usecase/usecase.dart';
import 'package:todo_list/features/user_account/domain/repository/user_account_respository.dart';

class GetUserEmailUseCase implements Usecase<String, NoParams> {
  final UserAccountRepository? userAccountRepository;

  const GetUserEmailUseCase({required this.userAccountRepository});
  @override
  Future<Either<Failure, String>> call(NoParams params) async {
    return await userAccountRepository!.getUserEmail();
  }
}

class NoParams extends Equatable {
  @override
  List<Object?> get props => [];
}
