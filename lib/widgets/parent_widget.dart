import 'package:flutter/material.dart';
import 'package:todo_list/core/utilities/config.dart';

class ParentWidget extends StatelessWidget {
  final Widget child;
  final String? title;
  final Color? appBarColor;
  double? elevation;
  ParentWidget(
      {Key? key,
      required this.child,
      required this.title,
      this.elevation = 5,
      required this.appBarColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColor,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: elevation,
        backgroundColor: appBarColor,
        title: Center(child: Text(title!)),
        leading: Visibility(
          visible: Navigator.canPop(context),
          child: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.arrow_back_outlined)),
        ),
        actions: const [
          SizedBox(
            width: 35,
          )
        ],
      ),
      body: SafeArea(child: child),
    );
  }
}
