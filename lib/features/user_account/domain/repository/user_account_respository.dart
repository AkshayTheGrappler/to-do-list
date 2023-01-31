import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_list/core/errors/failures.dart';

abstract class UserAccountRepository {
  Future<Either<Failure, UserCredential>> loginUser();
  Future<Either<Failure, User>> hasUserLoggedIn();
  Future<Either<Failure, String>> getUserEmail();
  Future<Either<Failure, bool>> logoutUser();
}
