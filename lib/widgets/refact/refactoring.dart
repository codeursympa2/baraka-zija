import 'package:flutter/material.dart';

class Refactoring{
  static void toastBottom(BuildContext context,String message){
     ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message,
          textAlign: TextAlign.center,
      ))
    );
 }
}