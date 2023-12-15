import 'package:flutter/material.dart';
import 'package:leave_system/admin_screen/manage_admin.dart';
import 'package:leave_system/admin_screen/manage_leave.dart';
import 'package:leave_system/admin_screen/manage_user.dart';
import 'package:leave_system/user_screen/login.dart';

class Home extends StatefulWidget {
  static const routeName = "/Home";
  const Home({Key? key});

  @override
  _HomeState createState() => _HomeState(); // สร้าง State ของ Home
}

class _HomeState extends State<Home> {
  // เพิ่ม GlobalKey<FormState> ที่นี่
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.all(10.0),
        child: Form(
          key: _formkey, // กำหนด GlobalKey<FormState> ให้กับฟอร์ม
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10.0),
                Center(
                  child: Image.network(
                    'https://www.fuseworkforce.com/hs-fs/hubfs/Product%20Icons/Time-and-labor-management.png?width=600&height=600&name=Time-and-labor-management.png',
                    fit: BoxFit.contain,
                    width: 200,
                    height: 200,
                  ),
                ),
                Center(child: adminLink(context)),
                SizedBox(height: 10.0),
                Center(child: userLink(context)),
                SizedBox(height: 10.0),
                Center(child: leaveLink(context)),
                SizedBox(height: 10.0),
                Center(child: backLink(context))

              ],
            ),
          ),
        ),
      ),
    );
  }
}
const double buttonWidth = 200.0;
const double buttonHeight = 50.0;

Widget adminLink(BuildContext context) {
  return Container(
    width: buttonWidth,
    height: buttonHeight,
    child: ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ManageAdmin(),
          ),
        );
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.purpleAccent),
        foregroundColor: MaterialStateProperty.all(Colors.white),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
            side: BorderSide(color: Colors.purpleAccent),
          ),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(Icons.admin_panel_settings, color: Colors.white),
          SizedBox(width: 10),
          Text("Admin"),
        ],
      ),
    ),
  );
}

Widget userLink(BuildContext context) {
  return Container(
    width: buttonWidth,
    height: buttonHeight,
    child: ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ManageUsers(),
          ),
        );
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.blueAccent),
        foregroundColor: MaterialStateProperty.all(Colors.white),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
            side: BorderSide(color: Colors.blueAccent),
          ),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(Icons.people, color: Colors.white),
          SizedBox(width: 10),
          Text("User"),
        ],
      ),
    ),
  );
}

Widget leaveLink(BuildContext context) {
  return Container(
    width: buttonWidth,
    height: buttonHeight,
    child: ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ManageLeave(),
          ),
        );
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.green),
        foregroundColor: MaterialStateProperty.all(Colors.white),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
            side: BorderSide(color: Colors.green),
          ),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(Icons.calendar_today, color: Colors.white),
          SizedBox(width: 10),
          Text("Leave"),
        ],
      ),
    ),
  );
}

Widget backLink(BuildContext context) {
  return Container(
    width: buttonWidth,
    height: buttonHeight,
    child: ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => User_login(),
          ),
        );
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.red),
        foregroundColor: MaterialStateProperty.all(Colors.white),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
            side: BorderSide(color: Colors.red),
          ),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(Icons.exit_to_app, color: Colors.white),
          SizedBox(width: 10),
          Text("Logout"),
        ],
      ),
    ),
  );
}
