import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

class GlobalMethods {
  static Future<void> errorDialog(
      {required String errorMessage, required BuildContext context}) async {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(
              errorMessage,
              style: const TextStyle(fontFamily: 'Nexa Bold'),
            ),
            title: (const Row(
              children: [
                Icon(
                  IconlyBold.danger,
                  color: Colors.red,
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  'Error',
                  style: TextStyle(fontFamily: 'Nexa Bold'),
                ),
              ],
            )),
            actions: [
              TextButton(
                onPressed: () {
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  }
                },
                child: const Text(
                  'Ok',
                  style: TextStyle(fontFamily: 'Nexa Bold'),
                ),
              ),
            ],
          );
        });
  }
}
