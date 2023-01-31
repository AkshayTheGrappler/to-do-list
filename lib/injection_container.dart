import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:todo_list/core/utilities/internet_checker.dart';
import 'package:todo_list/features/tasks/data/datasources/task_respository_data_source.dart';
import 'package:todo_list/features/tasks/data/repository/task_respository_impl.dart';
import 'package:todo_list/features/tasks/domain/repository/task_respository.dart';
import 'package:todo_list/features/tasks/domain/usecases/create_task_usecase.dart';
import 'package:todo_list/features/tasks/domain/usecases/get_tasks_usecase.dart';
import 'package:todo_list/features/tasks/domain/usecases/update_task_usecase.dart';
import 'package:todo_list/features/user_account/data/datasource/user_account_data_source.dart';
import 'package:todo_list/features/user_account/data/repositories/user_account_respository_impl.dart';
import 'package:todo_list/features/user_account/domain/repository/user_account_respository.dart';
import 'package:todo_list/features/user_account/domain/usecases/get_user_email_usecase.dart';
import 'package:todo_list/features/user_account/domain/usecases/has_user_logged_in_usecase.dart';
import 'package:todo_list/features/user_account/domain/usecases/login_user_usecase.dart';
import 'package:todo_list/features/user_account/domain/usecases/logout_user_usecase.dart';

import 'features/tasks/domain/usecases/delete_task_usecase.dart';

final serviceLocator = GetIt.instance;

Future<void> initialiseServiceLocator() async {
  // UserAccount
  // use-cases
  serviceLocator.registerLazySingleton(
      () => LoginUserUseCase(userAccountRepository: serviceLocator()));
  serviceLocator.registerLazySingleton(
      () => HasUserLoggedInUseCase(userAccountRepository: serviceLocator()));
  serviceLocator.registerLazySingleton(
      () => GetUserEmailUseCase(userAccountRepository: serviceLocator()));
  serviceLocator.registerLazySingleton(
      () => LogoutUserUseCase(userAccountRepository: serviceLocator()));
  // Repository
  serviceLocator.registerLazySingleton<UserAccountRepository>(() =>
      UserAccountRepositoryImpl(
          internetChecker: serviceLocator(), dataSource: serviceLocator()));
  // Data sources
  serviceLocator.registerLazySingleton<UserAccountDataSource>(() =>
      UserAccountDataSourceImpl(
          authInstance: serviceLocator(), googleSignIn: serviceLocator()));
  // services
  serviceLocator.registerLazySingleton(() => InternetChecker.getInstance());
  serviceLocator.registerLazySingleton(() => FirebaseAuth.instance);
  serviceLocator.registerLazySingleton(() => GoogleSignIn());

  // Todo task
  // use-cases
  serviceLocator.registerLazySingleton(
      () => CreateTaskUseCase(taskRepository: serviceLocator()));
  serviceLocator.registerLazySingleton(
      () => DeleteTaskUseCase(taskRepository: serviceLocator()));
  serviceLocator.registerLazySingleton(
      () => GetTasksUseCase(taskRepository: serviceLocator()));
  serviceLocator.registerLazySingleton(
      () => UpdateTaskUseCase(taskRepository: serviceLocator()));
  // Repository
  serviceLocator.registerLazySingleton<TaskRepository>(() => TaskRepositoryImpl(
      internetChecker: serviceLocator(), dataSource: serviceLocator()));
  // Data sources
  serviceLocator.registerLazySingleton<TaskRepositoryDataSource>(
      () => TaskRepositoryDataSourceImpl(instance: serviceLocator()));
  // services
  serviceLocator.registerLazySingleton(() => FirebaseFirestore.instance);
}
