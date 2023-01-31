import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:todo_list/core/errors/failures.dart';
import 'package:todo_list/core/utilities/config.dart';
import 'package:todo_list/features/tasks/presentation/user_task_list_screen.dart';
import 'package:todo_list/features/user_account/domain/usecases/login_user_usecase.dart';
import 'package:todo_list/injection_container.dart';
import 'package:todo_list/widgets/dialog_widget.dart';
import 'package:todo_list/widgets/parent_widget.dart';
import 'package:todo_list/widgets/snackbar_widget.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ParentWidget(
      title: '',
      appBarColor: appColor,
      elevation: 0,
      child: Center(
        child: TextButton(
          child: Container(
              width: MediaQuery.of(context).size.width / 2,
              height: MediaQuery.of(context).size.height / 18,
              margin: const EdgeInsets.only(top: 25),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20), color: Colors.white),
              child: const Center(
                  child: Text(
                'Sign in with Google',
                style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ))),
          onPressed: () async {
            showCustomDialog(context: context, text: 'Signing with google');
            serviceLocator<LoginUserUseCase>().call(NoParams()).then((user) {
              Navigator.of(context).pop();
              user.fold((l) {
                if (l is InternetFailure) {
                  showSnackBar(
                      context: context,
                      message: 'Please check your internet connection!');
                } else {
                  showSnackBar(context: context, message: 'Sign In Failed!');
                }
              }, (user) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          UserTaskListScreen(username: user.user!.email!)),
                );
              });
            });
          },
        ),
      ),
    );
  }

  Future<String> signInWithGoogle() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final GoogleSignIn _googleSignIn = GoogleSignIn();
    var googleSignInAccount = await _googleSignIn.signIn();
    var googleSignInAuthentication = await googleSignInAccount!.authentication;
    AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );
    var authResult = await _auth.signInWithCredential(credential);
    var user = authResult.user;
    return user!.email!;
  }
}
