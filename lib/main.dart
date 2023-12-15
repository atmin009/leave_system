import 'package:flutter/material.dart';
import 'package:leave_system/user_screen/login.dart';
import 'package:leave_system/user_screen/manage.dart';
import 'package:leave_system/admin_screen/home.dart';
import 'package:leave_system/user_screen/show.dart';
import 'package:leave_system/admin_screen/manage_user.dart';
import 'package:leave_system/admin_screen/manage_admin.dart';
import 'package:leave_system/admin_screen/manage_leave.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Leave-system',
      initialRoute: '/UserLogin',
      routes: {
        '/UserLogin': (context) => const User_login(),
        '/LeaveForm': (context) => const LeaveForm(),
        '/Home': (context) => const Home(),
        '/Show': (context) => const Show(),
        '/ManageUser' :(context) => const ManageUsers(),
        '/ManageAdmin' :(context) => const ManageAdmin(),
        '/ManageLeave' :(context) => const ManageLeave(),
        
      },
    );
  }
}