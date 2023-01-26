import 'package:flutter/material.dart';
import 'package:todo_list/core/errors/failures.dart';
import 'package:todo_list/core/utilities/config.dart';
import 'package:todo_list/features/tasks/presentation/user_task_list_screen.dart';
import 'package:todo_list/features/user_account/domain/usecases/get_user_email_usecase.dart';
import 'package:todo_list/features/user_account/domain/usecases/login_user_usecase.dart';
import 'package:todo_list/injection_container.dart';
import 'package:todo_list/widgets/dialog_widget.dart';
import 'package:todo_list/widgets/input_text.dart';
import 'package:todo_list/widgets/parent_widget.dart';
import 'package:todo_list/widgets/snackbar_widget.dart';

class SignInScreen extends StatelessWidget {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  SignInScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ParentWidget(
      title: 'Sign In',
      appBarColor: appColor,
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.1),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InputWidget(
              hint: 'email',
              controller: _email,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(
              height: 40,
            ),
            InputWidget(
              hint: 'password',
              controller: _password,
              isPasswordField: true,
              textInputAction: TextInputAction.done,
            ),
            const SizedBox(
              height: 40,
            ),
            SizedBox(
              width: double.infinity,
              height: 45,
              child: TextButton(
                onPressed: () {
                  var emailText = _email.text.trim();
                  var passwordText = _password.text.trim();
                  if (emailText.isEmpty || passwordText.isEmpty) {
                    showSnackBar(
                        context: context,
                        message: 'Please fill email and password');
                  } else {
                    showCustomDialog(context: context, text: 'Signing In...');
                    serviceLocator<LoginUserUseCase>()
                        .call(
                            Params(username: emailText, password: passwordText))
                        .then((result) {
                      Navigator.pop(context);
                      result.fold((l) {
                        if (l is InternetFailure) {
                          showSnackBar(
                              context: context,
                              message:
                                  'Please check your internet connection!');
                        } else {
                          showSnackBar(
                              context: context,
                              message: 'Enter Valid Email And Password');
                        }
                      }, (r) {
                        serviceLocator<GetUserEmailUseCase>()
                            .call(NoParams())
                            .then((username) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => UserTaskListScreen(
                                      username: username.getOrElse(() => ''),
                                    )),
                          );
                        });
                      });
                    });
                  }
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  backgroundColor: Colors.white,
                  primary: appColor,
                  onSurface: appColor, // Disable color
                ),
                child: const Text('Sign in'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
