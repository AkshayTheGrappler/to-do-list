import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:todo_list/core/errors/exceptions.dart';
import 'package:todo_list/features/tasks/data/models/task_model.dart';
import 'package:todo_list/features/user_account/domain/usecases/get_user_email_usecase.dart';
import 'package:todo_list/injection_container.dart';

abstract class TaskRepositoryDataSource {
  Future<bool> createTask({required Map<String, dynamic> task});
  Future<bool> deleteTask({required int taskId, required String? username});
  Future<List<TaskModel>> getTasks({required String username});
  Future<bool> updateTask({required Map<String, dynamic> task});
}

class TaskRepositoryDataSourceImpl implements TaskRepositoryDataSource {
  final FirebaseFirestore? instance;

  const TaskRepositoryDataSourceImpl({required this.instance});

  @override
  Future<bool> createTask({required Map<String, dynamic> task}) async {
    List<dynamic> tasksList = [];
    var email = (await serviceLocator<GetUserEmailUseCase>().call(NoParams()))
        .getOrElse(() => '');
    try {
      //get list of tasks
      var snapshots = (await instance!
              .collection('users')
              .doc(email)
              .collection('tasks')
              .get())
          .docs;
      for (var snap in snapshots) {
        tasksList.add(snap.data());
      }
    } catch (e) {
      //there is not a single task present yet
      print(e);
    }

    tasksList
        .sort((a, b) => (a['taskId'] as int).compareTo(b['taskId'] as int));
    var taskTodo = TaskModel.fromJson(task);
    tasksList.add(task);

    try {
      await instance!
          .collection('users')
          .doc(email)
          .collection('tasks')
          .doc('task${taskTodo.taskId!}')
          .set(taskTodo.toJson());
    } catch (e) {
      return false;
    }

    return true;
  }

  @override
  Future<bool> deleteTask(
      {required int taskId, required String? username}) async {
    try {
      await instance!
          .collection('users')
          .doc(username)
          .collection('tasks')
          .doc('task$taskId')
          .delete();
    } catch (e) {
      return false;
    }
    return true;
  }

  @override
  Future<List<TaskModel>> getTasks({required String username}) async {
    var taskList = <TaskModel>[];
    try {
      var snapshot = await instance!
          .collection('users')
          .doc(username)
          .collection('tasks')
          .get();
      for (var doc in snapshot.docs) {
        taskList.add(TaskModel.fromJson(doc.data()));
      }
    } catch (e) {
      throw DatabaseException();
    }
    return taskList;
  }

  @override
  Future<bool> updateTask({required Map<String, dynamic> task}) async {
    var email = (await serviceLocator<GetUserEmailUseCase>().call(NoParams()))
        .getOrElse(() => '');
    var taskTodo = TaskModel.fromJson(task);
    try {
      await instance!
          .collection('users')
          .doc(email)
          .collection('tasks')
          .doc('task${taskTodo.taskId!}')
          .set(taskTodo.toJson());
    } catch (e) {
      return false;
    }
    return true;
  }
}
