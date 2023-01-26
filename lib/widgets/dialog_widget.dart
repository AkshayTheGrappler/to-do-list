import 'package:flutter/material.dart';

void showCustomDialog({required BuildContext? context, required String? text}) {
  showDialog(
      context: context!,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
                height: 150,
                width: 100,
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(color: Colors.white),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      text!,
                      style: const TextStyle(color: Colors.white),
                    )
                  ],
                )));
      });
}

void showCustomAlertDialog(
    {required BuildContext? context,
    required String? text,
    required VoidCallback? onYesPressed}) {
  showDialog(
      context: context!,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(text!),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                onYesPressed!();
                if (Navigator.canPop(context)) {
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('No'),
            ),
          ],
        );
      });
}
