import 'package:flutter/material.dart';


void showAlertDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Theme(
        data: Theme.of(context).copyWith(
          primaryColor: Colors.green, // Set primary color
          // accentColor: Colors.yellow, // Set accent color
        ),
        child: AlertDialog(
          title: Row(
            children: [
              Icon(
                Icons.error_outline,
                color: Colors.yellow, // Set icon color
              ),
              SizedBox(width: 8.0),
              Text('Alert'),
            ],
          ),
          content: Text(message),
          actions: [
            TextButton(
              child: Text('Okay'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        ),
      );
    },
  );
}
