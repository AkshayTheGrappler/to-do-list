import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/core/errors/failures.dart';
import 'package:todo_list/core/utilities/to_do_list_notifier.dart';
import 'package:todo_list/features/tasks/presentation/user_task_list_screen.dart';
import 'package:todo_list/features/user_account/domain/repository/user_account_respository.dart';
import 'package:todo_list/features/user_account/presentation/login_screen.dart';
import 'package:todo_list/injection_container.dart';

void main() async {
  await initialiseServiceLocator();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ToDoListNotifier(),
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            body: Center(
                child: FutureBuilder<Either<Failure, User>>(
                    future: serviceLocator<UserAccountRepository>()
                        .hasUserLoggedIn(),
                    builder: (_, snapshot) {
                      if (snapshot.hasData) {
                        return snapshot.data!.fold(
                            (exception) => const LoginScreen(),
                            (user) => UserTaskListScreen(
                                  username: user.email!,
                                ));
                      }
                      return const Center(
                        child: Text('Please Wait...'),
                      );
                    })),
          )),
    );
  }
}
