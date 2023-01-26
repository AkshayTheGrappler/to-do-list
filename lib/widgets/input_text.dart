import 'package:flutter/material.dart';

class InputWidget extends StatefulWidget {
  final String? hint;
  final TextEditingController? controller;
  final TextInputAction? textInputAction;
  GestureTapCallback? onTap;
  bool? isPasswordField;

  InputWidget({
    Key? key,
    required this.hint,
    required this.controller,
    required this.textInputAction,
    this.onTap,
    this.isPasswordField = false,
  }) : super(key: key);

  @override
  State<InputWidget> createState() => _InputWidgetState();
}

class _InputWidgetState extends State<InputWidget> {
  var isTextHidden = true;

  @override
  void initState() {
    super.initState();
    if (!widget.isPasswordField!) {
      isTextHidden = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      TextField(
        textInputAction: widget.textInputAction!,
        obscureText: widget.isPasswordField! && isTextHidden,
        controller: widget.controller,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
          hintText: widget.hint!,
          hintStyle: TextStyle(color: Colors.grey.shade400),
        ),
        onTap: widget.onTap,
        cursorColor: Colors.white,
      ),
      Align(
        alignment: Alignment.centerRight,
        child: Visibility(
          visible: widget.isPasswordField!,
          child: TextButton(
              child: Text(isTextHidden ? 'Show' : 'Hide',
                  style: TextStyle(color: Colors.white)),
              onPressed: () {
                setState(() {
                  isTextHidden = !isTextHidden;
                });
              }),
        ),
      )
    ]);
  }
}

Widget getInputWidget(
    {required String? hint,
    required TextEditingController? controller,
    GestureTapCallback? onTap}) {
  return TextField(
    controller: controller,
    style: const TextStyle(color: Colors.white),
    decoration: InputDecoration(
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.grey.shade400),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.grey.shade400),
      ),
      hintText: hint!,
      hintStyle: TextStyle(color: Colors.grey.shade400),
    ),
    onTap: onTap,
  );
}
