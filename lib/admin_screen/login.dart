import 'package:flutter/material.dart';
import 'package:leave_system/models/admin.dart';
import 'package:email_validator/email_validator.dart';
import 'package:leave_system/models/admin_config.dart';
import 'package:http/http.dart' as http;
import 'package:leave_system/user_screen/login.dart';
import 'package:leave_system/admin_screen/home.dart';

class Admin_login extends StatefulWidget {
  static const routeName = "/Admin_login";
  const Admin_login({super.key});

  @override
  State<Admin_login> createState() => _Admin_loginState();
}

class _Admin_loginState extends State<Admin_login> {
  final _formkey = GlobalKey<FormState>();
  Admin admin = Admin();

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
                Center(child: userLink()),
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
        "Admin",
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
          color: Color.fromARGB(255, 255, 102, 0), // สีของไอคอน
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
      onSaved: (newValue) => admin.email = newValue,
    );
  }

  Widget passwordInputField() {
    return TextFormField(
      obscureText: true,
      decoration: InputDecoration(
        labelText: "Password:",
        prefixIcon: Icon(
          Icons.lock,
          color: Color.fromARGB(255, 255, 102, 0) // สีของไอคอน
        ),
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return "This field is required";
        }
        return null;
      },
      onSaved: (newValue) => admin.password = newValue,
    );
  }
double buttonWidth = 200;

Widget submitButton() {
    return Container(
      width: buttonWidth,
      child: ElevatedButton(
        onPressed: () {
          if (_formkey.currentState!.validate()) {
            _formkey.currentState!.save();
            print(admin.toJson().toString());
            login(admin);
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
              side: BorderSide(color: Colors.blue),
            ),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(Icons.login, color: Colors.white),
            SizedBox(width: 10),
            Text(
              "Login",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
}

Widget userLink() {
    return Container(
      width: buttonWidth,
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
          padding: MaterialStateProperty.all<EdgeInsets>(
            EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          ),
          backgroundColor: MaterialStateProperty.all<Color>(
            const Color.fromARGB(255, 0, 120, 62),
          ),
          foregroundColor: MaterialStateProperty.all<Color>(
            Colors.white,
          ),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
              side: BorderSide(color: const Color.fromARGB(255, 1, 124, 6)),
            ),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(Icons.person, color: Colors.white),
            SizedBox(width: 10),
            Text(
              "Employee",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
}


  

  Future<void> login(Admin admin) async {
    var params = {"email": admin.email, "password": admin.password};

    var url = Uri.http(Configure.server, "admin", params);
    var resp = await http.get(url);
    // print(resp.body);
    List<Admin> login_result = adminFromJson(resp.body);
    // print(login_result.length);
    if (login_result.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("username or password invalid")));
    } else {
      Configure.login = login_result[0];
      Navigator.pushNamed(context, Home.routeName);
    }
    return;
  }
}
