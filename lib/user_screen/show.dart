import 'package:flutter/material.dart';
import 'package:leave_system/user_screen/login.dart';

class Show extends StatefulWidget {
  static const routeName = "/Show";
  const Show({Key? key});

  @override
  _ShowState createState() => _ShowState(); // สร้าง State ของ Home
}

class _ShowState extends State<Show> {
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  @override
 Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.all(10.0),
        child: Form(
          key: _formkey,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 10.0),
                Image.network(
                  'https://media.tenor.com/BSY1qTH8g-oAAAAC/check.gif',
                  fit: BoxFit.contain,
                  width: 200,
                  height: 200,
                ),
                SizedBox(height: 10.0),
                Text(
                  'บันทึกข้อมูลสำเร็จ',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10.0),
                backLink(context),
              ],
            ),
          ),
        ),
      ),
    );
}

}

Widget backLink(BuildContext context) {
  return ElevatedButton(
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => User_login(), // ใส่หน้าปลายทางที่คุณต้องการไป
        ),
      );
    },
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all(Colors.red), // กำหนดสีพื้นหลังเป็นสีแดง
    ),
    child: Text("Logout"),
  );
}
