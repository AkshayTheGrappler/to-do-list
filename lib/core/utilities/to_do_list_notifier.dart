import 'dart:collection';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:todo_list/features/tasks/data/models/task_model.dart';

class ToDoListNotifier with ChangeNotifier {
  var _taskList = <TaskModel>[];

  List<TaskModel> getToDoList() => UnmodifiableListView(_taskList);

  void initialise(List<TaskModel> tasks) {
    _taskList = tasks;
    notifyListeners();
  }

  void add(TaskModel task) {
    _taskList.add(task);
    notifyListeners();
  }

  void delete(int index) {
    _taskList.removeAt(index);
    notifyListeners();
  }

  void modify(int index, TaskModel task) {
    _taskList[index] = task;
    notifyListeners();
  }
}
