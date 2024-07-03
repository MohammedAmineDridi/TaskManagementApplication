import 'package:flutter/material.dart';
import 'package:my_app1/pages/CreateAccount.dart';
import 'pages/Welcome.dart';
import 'package:my_app1/pages/ForgotPassword.dart';
import 'package:my_app1/pages/Tasks_Boards_List.dart';
import 'package:my_app1/pages/AddTask.dart';
import 'package:my_app1/pages/AddBoard.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: WelcomePage(),
      routes: {
        "welcome":(context)=> WelcomePage(),
        "createAccount":(context)=>CreateAccountPage(),
        "forgotPassword":(context)=>ForgotPasswordPage(),
        "tasksboardsList":(context)=>TasksBoardsList(),
        "addtask":(context)=>AddTask(),
        "addboard":(context)=>AddBoard(),
      },
    );
  }
}

