import 'package:flutter/material.dart';
import 'package:todo_list/core/errors/failures.dart';
import 'package:todo_list/core/utilities/config.dart';
import 'package:todo_list/features/user_account/domain/usecases/create_user_usecase.dart';
import 'package:todo_list/features/user_account/presentation/sign_in_screen.dart';
import 'package:todo_list/injection_container.dart';
import 'package:todo_list/widgets/dialog_widget.dart';
import 'package:todo_list/widgets/input_text.dart';
import 'package:todo_list/widgets/parent_widget.dart';
import 'package:todo_list/widgets/snackbar_widget.dart';

class SignUpScreen extends StatelessWidget {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  SignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ParentWidget(
      title: 'Sign Up',
      appBarColor: appColor,
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.1),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            InputWidget(
              hint: 'email',
              controller: _email,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(
              height: 30,
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
                  if (emailText.isEmpty || _password.text.isEmpty) {
                    showSnackBar(
                        context: context,
                        message: 'Please fill email and password');
                  } else {
                    showCustomDialog(
                        context: context, text: 'Creating Account...');
                    serviceLocator<CreateUserUseCase>()
                        .call(
                            Params(username: emailText, password: passwordText))
                        .then((result) {
                      Navigator.pop(context);
                      result.fold((l) {
                        if (l is InvalidEmailFailure) {
                          showSnackBar(
                              context: context,
                              message: 'Please Enter Valid Email');
                        } else if (l is InvalidPasswordFailure) {
                          showSnackBar(
                              context: context,
                              message: 'Please Enter Valid Password');
                        } else if (l is UserAlreadyExistsFailure) {
                          showSnackBar(
                              context: context,
                              message: 'This User Already Exits');
                        } else if (l is InternetFailure) {
                          showSnackBar(
                              context: context,
                              message:
                                  'Please check your internet connection!');
                        }
                      }, (r) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignInScreen()),
                        );
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
                child: const Text('Sign Up'),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text('Already have a account ?',
                style: TextStyle(color: Colors.white, fontSize: 14)),
            const SizedBox(
              height: 5,
            ),
            InkWell(
              child: const Text(
                'Sign In',
                style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: Colors.white,
                    fontSize: 14),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignInScreen()),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
