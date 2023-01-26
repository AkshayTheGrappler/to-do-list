import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/core/errors/failures.dart';
import 'package:todo_list/core/utilities/to_do_list_notifier.dart';
import 'package:todo_list/features/tasks/presentation/user_task_list_screen.dart';
import 'package:todo_list/features/user_account/domain/repository/user_account_respository.dart';
import 'package:todo_list/features/user_account/presentation/sign_up_screen.dart';
import 'package:todo_list/injection_container.dart';

void main() async {
  await initialiseServiceLocator();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ToDoListNotifier([]),
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Center(
              child: FutureBuilder<Either<Failure, User>>(
                  future:
                      serviceLocator<UserAccountRepository>().hasUserLoggedIn(),
                  builder: (_, snapshot) {
                    if (snapshot.hasData) {
                      return snapshot.data!.fold(
                          (exception) => SignUpScreen(),
                          (user) => UserTaskListScreen(
                                username: user.email!,
                              ));
                    }
                    return const Center(
                      child: Text('Please Wait...'),
                    );
                  }))),
    );
  }
}
