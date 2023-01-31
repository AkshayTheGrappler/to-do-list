import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_list/core/errors/exceptions.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class UserAccountDataSource {
  Future<UserCredential> loginUser();

  Future<User> hasUserLoggedIn();
  Future<String> getUserEmail();
  Future<bool> logoutUser();
}

class UserAccountDataSourceImpl extends UserAccountDataSource {
  final FirebaseAuth? authInstance;
  final GoogleSignIn? googleSignIn;

  UserAccountDataSourceImpl(
      {required this.authInstance, required this.googleSignIn});

  @override
  Future<UserCredential> loginUser() async {
    try {
      var googleSignInAccount = await googleSignIn!.signIn();
      var googleSignInAuthentication =
          await googleSignInAccount!.authentication;
      AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      var authResult = await authInstance!.signInWithCredential(credential);
      return authResult;
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
      await authInstance!.signOut();
      await googleSignIn!.signOut();
    } catch (e) {
      loggedOut = false;
    }
    return loggedOut;
  }
}
