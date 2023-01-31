import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/core/errors/failures.dart';
import 'package:todo_list/core/utilities/config.dart';
import 'package:todo_list/core/utilities/to_do_list_notifier.dart';
import 'package:todo_list/features/tasks/data/models/task_model.dart';
import 'package:todo_list/features/tasks/domain/entities/task.dart';
import 'package:todo_list/features/tasks/domain/usecases/delete_task_usecase.dart'
    as delete_task_usecase;
import 'package:todo_list/features/tasks/domain/usecases/get_tasks_usecase.dart';
import 'package:todo_list/features/tasks/presentation/task_creator_screen.dart';
import 'package:todo_list/features/user_account/presentation/login_screen.dart';
import 'package:todo_list/injection_container.dart';
import 'package:dartz/dartz.dart' as dartz;
import 'package:todo_list/widgets/dialog_widget.dart';
import 'package:todo_list/widgets/snackbar_widget.dart';
import 'package:todo_list/features/user_account/domain/usecases/logout_user_usecase.dart'
    as logout_user_usecase;

class UserTaskListScreen extends StatefulWidget {
  final String? username;
  const UserTaskListScreen({Key? key, required this.username})
      : super(key: key);

  @override
  State<UserTaskListScreen> createState() => _UserTaskListScreenState();
}

class _UserTaskListScreenState extends State<UserTaskListScreen> {
  @override
  Widget build(BuildContext context) {
    var widgetContext = context;
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.35,
            child: Stack(children: [
              Image.asset(
                'lib/assets/mountains_background.jpg',
                height: MediaQuery.of(context).size.height * 0.35,
                fit: BoxFit.cover,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                    // color: Colors.red,
                    width: MediaQuery.of(context).size.width * 0.65,
                    decoration: const BoxDecoration(
                        border: Border(
                            bottom: BorderSide(color: Colors.blue, width: 4))),
                    padding: const EdgeInsets.only(left: 15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        IconButton(
                            onPressed: () {
                              showCustomAlertDialog(
                                  context: context,
                                  text: 'Do you want to logout?',
                                  onYesPressed: () {
                                    serviceLocator<
                                            logout_user_usecase
                                                .LogoutUserUseCase>()
                                        .call(logout_user_usecase.NoParams())
                                        .then((hasLoggedOut) {
                                      hasLoggedOut.fold((l) {
                                        if (l is InternetFailure) {
                                          showSnackBar(
                                              context: context,
                                              message:
                                                  'Please check your internet connection!');
                                        } else {
                                          showSnackBar(
                                              context: context,
                                              message: 'Logout Failed!!');
                                        }
                                      }, (r) {
                                        Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const LoginScreen()),
                                          ModalRoute.withName("/SignUpScreen"),
                                        );
                                      });
                                    });
                                  });
                            },
                            icon: const Icon(
                              Icons.menu,
                              color: Colors.white,
                              size: 40,
                            )),
                        const Text(
                          'Your\nTasks',
                          style: TextStyle(fontSize: 32, color: Colors.white),
                        ),
                        Text(
                          DateFormat.yMMMd().format(DateTime.now()),
                          style:
                              TextStyle(fontSize: 16, color: appColor.shade200),
                        )
                      ],
                    )),
              )
            ]),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.6,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            color: Colors.white,
            child: FutureBuilder<dartz.Either<Failure, List<TaskEntity>>>(
              future: serviceLocator<GetTasksUseCase>().call(
                Params(username: widget.username!),
              ),
              builder: (_, snapshot) {
                if (snapshot.hasData) {
                  var data = snapshot.data!;
                  return data.fold((l) {
                    if (l is InternetFailure) {
                      return const Center(
                        child: Text('Please check your internet connection'),
                      );
                    } else {
                      return const Center(
                        child: Text('Please wait...'),
                      );
                    }
                  }, (taskListOfUser) {
                    Provider.of<ToDoListNotifier>(context, listen: false)
                        .initialise(taskListOfUser as List<TaskModel>);

                    return Consumer<ToDoListNotifier>(
                      builder: (context, taskList, child) {
                        return taskListOfUser.isEmpty
                            ? const Center(
                                child: Text('No Tasks Created Yet'),
                              )
                            : Expanded(
                                child: ListView.builder(
                                  itemCount: taskList.getToDoList().length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    var task = taskList.getToDoList()[index];
                                    return GestureDetector(
                                      onLongPress: () {
                                        showCustomAlertDialog(
                                            context: context,
                                            text:
                                                'Do you want to delete this task?',
                                            onYesPressed: () {
                                              serviceLocator<
                                                      delete_task_usecase
                                                          .DeleteTaskUseCase>()
                                                  .call(delete_task_usecase
                                                      .Params(
                                                          taskId: task.taskId!,
                                                          username:
                                                              widget.username!))
                                                  .then((value) {
                                                value.fold((l) {
                                                  if (l is InternetFailure) {
                                                    showSnackBar(
                                                        context: context,
                                                        message:
                                                            'Please check your internet connection!');
                                                  }
                                                }, (isDeleted) {
                                                  if (isDeleted) {
                                                    Provider.of<ToDoListNotifier>(
                                                            context,
                                                            listen: false)
                                                        .delete(index);
                                                    showSnackBar(
                                                        context: context,
                                                        message:
                                                            'Task Deleted Successfully');
                                                  }
                                                });
                                              });
                                            });
                                      },
                                      onTap: () {
                                        Navigator.push(
                                          widgetContext,
                                          MaterialPageRoute(
                                              builder: (widgetContext) =>
                                                  TaskCreatorScreen(
                                                    model: task,
                                                    editMode: true,
                                                    index: index,
                                                    username: widget.username!,
                                                  )),
                                        );
                                      },
                                      child: Container(
                                        height: 80,
                                        decoration: BoxDecoration(
                                            border: Border(
                                                bottom: BorderSide(
                                                    color: Colors.grey.shade200,
                                                    width: 1))),
                                        child: ListTile(
                                          trailing: Text(
                                              DateFormat.MMMd().format(
                                                  DateTime.parse(
                                                      task.taskDate!)),
                                              maxLines: 1,
                                              style: const TextStyle(
                                                  color: Colors.grey)),
                                          title: Text(
                                            task.taskName!,
                                            maxLines: 1,
                                          ),
                                          subtitle: Text(task.taskDescription!,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                  color: Colors.grey)),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
                      },
                    );
                  });
                } else {
                  return const Center(
                    child: Text('Please wait...'),
                  );
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 20.0, right: 10),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              widgetContext,
              MaterialPageRoute(
                  builder: (widgetContext) => TaskCreatorScreen(
                        username: widget.username!,
                      )),
            );
          },
          tooltip: 'Add New Task',
          child: const Icon(Icons.add, size: 35),
        ),
      ),
    );
  }
}
