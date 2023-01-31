import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_list/core/errors/exceptions.dart';
import 'package:todo_list/core/errors/failures.dart';
import 'package:todo_list/core/utilities/internet_checker.dart';
import 'package:todo_list/features/user_account/domain/repository/user_account_respository.dart';
import '../datasource/user_account_data_source.dart';

class UserAccountRepositoryImpl implements UserAccountRepository {
  final InternetChecker? internetChecker;
  final UserAccountDataSource? dataSource;

  UserAccountRepositoryImpl({
    required this.internetChecker,
    required this.dataSource,
  });

  @override
  Future<Either<Failure, UserCredential>> loginUser() async {
    if (await internetChecker!.checkConnection()) {
      try {
        var user = await dataSource!.loginUser();
        return Right(user);
      } catch (exception) {
        return Left(InvalidCredFailure());
      }
    } else {
      return Left(InternetFailure());
    }
  }

  @override
  Future<Either<Failure, User>> hasUserLoggedIn() async {
    if (await internetChecker!.checkConnection()) {
      try {
        var user = await dataSource!.hasUserLoggedIn();
        return Right(user);
      } catch (exception) {
        return Left(DatabaseFailure());
      }
    } else {
      return Left(InternetFailure());
    }
  }

  @override
  Future<Either<Failure, String>> getUserEmail() async {
    if (await internetChecker!.checkConnection()) {
      try {
        var userEmail = await dataSource!.getUserEmail();
        return Right(userEmail);
      } catch (exception) {
        return Left(DatabaseFailure());
      }
    } else {
      return Left(InternetFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> logoutUser() async {
    if (await internetChecker!.checkConnection()) {
      try {
        var hasLogout = await dataSource!.logoutUser();
        return Right(hasLogout);
      } catch (exception) {
        return Left(DatabaseFailure());
      }
    } else {
      return Left(InternetFailure());
    }
  }
}
