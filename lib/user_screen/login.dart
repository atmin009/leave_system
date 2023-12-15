import 'package:flutter/material.dart';
import 'package:leave_system/models/user.dart';
import 'package:email_validator/email_validator.dart';
import 'package:leave_system/models/user_config.dart';
import 'package:http/http.dart' as http;
import 'package:leave_system/user_screen/manage.dart';
import 'package:leave_system/admin_screen/login.dart';

class User_login extends StatefulWidget {
  static const routeName = "/User_login";
  const User_login({super.key});

  @override
  State<User_login> createState() => _User_loginState();
}

class _User_loginState extends State<User_login> {
  final _formkey = GlobalKey<FormState>();
  Users user = Users();

  @override
  Widget build(BuildContext context) {
  return Scaffold(
    body: Container(
      margin: EdgeInsets.all(10.0),
      child: Form(
        key: _formkey,
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10.0),
              Center(
                child: Image.network(
                  'https://www.fuseworkforce.com/hs-fs/hubfs/Product%20Icons/Leave-and-absence-management.png?width=600&height=600&name=Leave-and-absence-management.png',
                  fit: BoxFit.contain,
                  width: 200,
                  height: 200,
                ),
              ),
              SizedBox(height: 10.0),
              textHeader(),
              SizedBox(height: 10.0),
              emailInputField(),
              passwordInputField(),
              SizedBox(height: 10.0),
              Center(child: submitButton()),
              SizedBox(height: 10.0),
              Center(child: adminLink()),
            ],
          ),
        ),
      ),
    ),
  );
}



  Widget textHeader() {
  return Center(
    child: Text(
      "Employee",
      style: TextStyle(
        fontSize: 30,
        color: Color.fromARGB(255, 255, 102, 0), // สีของตัวอักษร
        fontWeight: FontWeight.bold, // ตัวอักษรหนา
      ),
    ),
  );
}


  Widget emailInputField() {
  return TextFormField(
    decoration: InputDecoration(
      labelText: "Email:",
      prefixIcon: Icon(
        Icons.email,
        color: Color.fromARGB(255, 255, 102, 0)
      ),
    ),
    validator: (value) {
      if (value!.isEmpty) {
        return "This field is required";
      }
      if (!EmailValidator.validate(value)) {
        return "It is not email format";
      }
      return null;
    },
    onSaved: (newValue) => user.email = newValue,
  );
}

Widget passwordInputField() {
  return TextFormField(
    obscureText: true,
    decoration: InputDecoration(
      labelText: "Password:",
      prefixIcon: Icon(
        Icons.lock,
        color: Color.fromARGB(255, 255, 102, 0),
      ),
    ),
    validator: (value) {
      if (value!.isEmpty) {
        return "This field is required";
      }
      return null;
    },
    onSaved: (newValue) => user.password = newValue,
  );
}


  Widget submitButton() {
    return ElevatedButton(
      onPressed: () {
        if (_formkey.currentState!.validate()) {
          _formkey.currentState!.save();
          print(user.toJson().toString());
          login(user);
        }
      },
      style: ButtonStyle(
        padding: MaterialStateProperty.all<EdgeInsets>(
          EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        ),
        backgroundColor: MaterialStateProperty.all<Color>(
          Colors.blueAccent,
        ),
        foregroundColor: MaterialStateProperty.all<Color>(
          Colors.white,
        ),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
            side: BorderSide(color: Colors.blueAccent),
          ),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(Icons.login, color: Colors.white),
          SizedBox(width: 8),
          Text(
            "Login",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget adminLink() {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Admin_login(),
          ),
        );
      },
      style: ButtonStyle(
        padding: MaterialStateProperty.all<EdgeInsets>(
          EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        ),
        backgroundColor: MaterialStateProperty.all<Color>(
          Colors.redAccent,
        ),
        foregroundColor: MaterialStateProperty.all<Color>(
          Colors.white,
        ),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
            side: BorderSide(color: Colors.redAccent),
          ),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(Icons.admin_panel_settings, color: Colors.white),
          SizedBox(width: 8),
          Text(
            "Admin",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }


  Future<void> login(Users user) async {
    var params = {"email": user.email, "password": user.password};

    var url = Uri.http(Configure.server, "users", params);
    var resp = await http.get(url);
    // print(resp.body);
    List<Users> login_result = usersFromJson(resp.body);
    // print(login_result.length);
    if (login_result.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("username or password invalid")));
    } else {
      Configure.login = login_result[0];
      Navigator.pushNamed(context, LeaveForm.routeName);
    }
    return;
  }
}