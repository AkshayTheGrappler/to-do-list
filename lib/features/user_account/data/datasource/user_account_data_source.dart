import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_list/core/errors/exceptions.dart';

abstract class UserAccountDataSource {
  Future<UserCredential> createUser({
    required String? username,
    required String? password,
  });
  Future<UserCredential> loginUser(
      {required String? username, required String? password});

  Future<User> hasUserLoggedIn();
  Future<String> getUserEmail();
  Future<bool> logoutUser();
}

class UserAccountDataSourceImpl extends UserAccountDataSource {
  final FirebaseAuth? authInstance;

  UserAccountDataSourceImpl({required this.authInstance});

  @override
  Future<UserCredential> createUser(
      {required String? username, required String? password}) async {
    try {
      return await authInstance!.createUserWithEmailAndPassword(
          email: username!, password: password!);
    } catch (e) {
      if (e.toString().contains('email-already-in-use')) {
        throw UserAlreadyExistsException();
      } else if (e.toString().contains('invalid-email')) {
        throw InvalidEmailException();
      } else if (e.toString().contains('weak-password')) {
        throw InvalidPasswordException();
      } else {
        throw InvalidCredException();
      }
    }
  }

  @override
  Future<UserCredential> loginUser(
      {required String? username, required String? password}) async {
    try {
      return await authInstance!
          .signInWithEmailAndPassword(email: username!, password: password!);
    } catch (e) {
      throw InvalidCredException();
    }
  }

  @override
  Future<User> hasUserLoggedIn() async {
    var user = authInstance!.currentUser;
    if (user == null) {
      throw DatabaseException();
    }
    return user;
  }

  @override
  Future<String> getUserEmail() async {
    var user = authInstance!.currentUser;
    if (user == null) {
      throw DatabaseException();
    }
    return user.email!;
  }

  @override
  Future<bool> logoutUser() async {
    var loggedOut = true;
    try {
      authInstance!.signOut();
    } catch (e) {
      loggedOut = false;
    }
    return loggedOut;
  }
}
