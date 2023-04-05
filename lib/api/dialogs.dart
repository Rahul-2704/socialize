import 'package:flutter/material.dart';

class Dialogs{
  static void showSnackBar(BuildContext context, String msg){
    ScaffoldMessenger
      .of(context)
      .showSnackBar(
      SnackBar(
        content: Center(child: Text(msg)),
        backgroundColor: Colors.green.withOpacity(1),
        behavior: SnackBarBehavior.floating,
      )
    );
  }

  static void snackBarForgotPassword(BuildContext context, String msg){
    ScaffoldMessenger
      .of(context)
      .showSnackBar(
      SnackBar(
        content: Center(child: Text(msg)),
        backgroundColor: Color(0xFF30D5CB),
        behavior: SnackBarBehavior.floating,
      )
    );
  }
}