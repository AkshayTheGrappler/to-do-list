import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/core/errors/failures.dart';
import 'package:todo_list/core/utilities/config.dart';
import 'package:todo_list/core/utilities/to_do_list_notifier.dart';
import 'package:todo_list/features/tasks/data/models/task_model.dart';
import 'package:todo_list/features/tasks/domain/usecases/create_task_usecase.dart';
import 'package:todo_list/features/tasks/domain/usecases/get_tasks_usecase.dart'
    as getTask;
import 'package:todo_list/injection_container.dart';
import 'package:todo_list/widgets/dialog_widget.dart';
import 'package:todo_list/widgets/input_text.dart';
import 'package:todo_list/widgets/parent_widget.dart';
import 'package:todo_list/widgets/snackbar_widget.dart';

class TaskCreatorScreen extends StatefulWidget {
  final TaskModel? model;
  final bool? editMode;
  final int? index;

  const TaskCreatorScreen(
      {Key? key,
      this.index = 1,
      this.editMode = false,
      this.model = const TaskModel(
          taskId: 0, taskName: '', taskDescription: '', taskDate: '')})
      : super(key: key);

  @override
  State<TaskCreatorScreen> createState() => _TaskCreatorScreenState();
}

class _TaskCreatorScreenState extends State<TaskCreatorScreen> {
  final TextEditingController _title = TextEditingController();
  final TextEditingController _description = TextEditingController();
  final TextEditingController _date = TextEditingController();

  @override
  void initState() {
    super.initState();
    _title.text = widget.model!.taskName!;
    _description.text = widget.model!.taskDescription!;
    _date.text = widget.model!.taskDate!;
  }

  @override
  Widget build(BuildContext context) {
    return ParentWidget(
      title: widget.editMode! ? 'Modify task' : 'Add new thing',
      appBarColor: appColor,
      elevation: 0,
      child: Container(
        color: appColor,
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.1),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 30,
            ),
            Container(
              width: 60,
              height: 60,
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.blueAccent)),
              child: IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.edit,
                    size: 30,
                    color: Colors.blue,
                  )),
            ),
            const SizedBox(
              height: 50,
            ),
            InputWidget(
              hint: 'Task title',
              controller: _title,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(
              height: 10,
            ),
            InputWidget(
              hint: 'Task Description',
              controller: _description,
              textInputAction: TextInputAction.done,
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: _date,
              style: const TextStyle(color: Colors.white),
              //editing controller of this TextField
              decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade400),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade400),
                  ),
                  hintStyle: TextStyle(color: Colors.grey.shade400),
                  icon: const Icon(
                    Icons.calendar_today,
                    color: Colors.white,
                  ), //icon of text field
                  hintText: 'Enter Date' //label text of field
                  ),
              readOnly: true,
              //set it true, so that user will not able to edit text
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1950),
                    //DateTime.now() - not to allow to choose before today.
                    lastDate: DateTime(2100));

                if (pickedDate != null) {
                  _date.text = pickedDate.toString();
                }
              },
            ),
            const SizedBox(
              height: 40,
            ),
            SizedBox(
              width: double.infinity,
              height: 45,
              child: TextButton(
                onPressed: () {
                  var titleText = _title.text.trim();
                  var descriptionText = _description.text.trim();
                  var dateText = _date.text.trim();
                  if (titleText.isEmpty ||
                      descriptionText.isEmpty ||
                      dateText.isEmpty) {
                    showSnackBar(
                        context: context,
                        message: 'Please fill all the fields');
                  } else {
                    serviceLocator<getTask.GetTasksUseCase>()
                        .call(const getTask.Params(
                            username: 'yadavakshay300@gmail.com'))
                        .then((value) {
                      value.fold((l) {
                        if (l is InternetFailure) {
                          showSnackBar(
                              context: context,
                              message:
                                  'Please check your internet connection!');
                        }
                      }, (tasks) {
                        showCustomDialog(
                            context: context,
                            text: widget.editMode!
                                ? 'Modifying Task....'
                                : 'Creating Task....');
                        var taskId = 1;
                        if (widget.editMode!) {
                          taskId = widget.model!.taskId!;
                        } else {
                          if (tasks.isNotEmpty) {
                            tasks
                                .sort((a, b) => a.taskId!.compareTo(b.taskId!));
                            taskId = tasks.last.taskId! + 1;
                          }
                        }
                        var task = TaskModel(
                            taskId: taskId,
                            taskName: titleText,
                            taskDescription: descriptionText,
                            taskDate: dateText);
                        serviceLocator<CreateTaskUseCase>()
                            .call(Params(
                          task: task.toJson(),
                        ))
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
                                  message: 'Task Creation Failed');
                            }
                          }, (r) {
                            if (widget.editMode!) {
                              Provider.of<ToDoListNotifier>(context,
                                      listen: false)
                                  .delete(widget.index!);
                              Provider.of<ToDoListNotifier>(context,
                                      listen: false)
                                  .add(task);
                            } else {
                              Provider.of<ToDoListNotifier>(context,
                                      listen: false)
                                  .add(task);
                            }
                            if (!widget.editMode!) {
                              _title.text = '';
                              _description.text = '';
                              _date.text = '';
                            }
                            showSnackBar(
                                context: context,
                                message: widget.editMode!
                                    ? 'Task Modified Successfully'
                                    : 'Task Created Successfully');
                          });
                        });
                      });
                    });
                  }
                },
                style: TextButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  backgroundColor: const Color(0xff70b8ec),
                  primary: Colors.white,
                  onSurface: appColor, // Disable color
                ),
                child: Text(
                    widget.editMode! ? 'MODIFY YOUR THING' : 'ADD YOUR THING'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
