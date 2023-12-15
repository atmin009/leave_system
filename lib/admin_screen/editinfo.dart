import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:leave_system/models/admin_config.dart';
import 'package:leave_system/models/admin.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AdminForm extends StatefulWidget {
  @override
  _AdminFormState createState() => _AdminFormState();
}

class _AdminFormState extends State<AdminForm> {
  final _formkey = GlobalKey<FormState>();
  // Users user = Users();
  late Admin admin;

  @override
  Widget build(BuildContext context) {
    try {
      admin = ModalRoute.of(context)!.settings.arguments as Admin;
      print(admin.fullname);
    } catch (e) {
      admin = Admin();
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("admin Form"),
        backgroundColor: Color.fromARGB(255, 255, 102, 0),
      ),
      body: Container(
        margin: EdgeInsets.all(10),
        child: Form(
          key: _formkey,
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
              fnameInputField(),
              emailInputField(),
              passwordInputField(),
              genderFormInput(),
              SizedBox(height: 10),
              submitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget fnameInputField() {
    return TextFormField(
      initialValue: admin.fullname,
      decoration: InputDecoration(
          labelText: "Full Name:",
          icon: Icon(Icons.person,
              color: Color.fromARGB(255, 255, 102, 0))
          ),
      validator: (value) {
        if (value!.isEmpty) {
          return "This field is required";
        }
        return null;
      },
      onSaved: (newValue) => admin.fullname = newValue,
    );
  }

  Widget emailInputField() {
    return TextFormField(
      initialValue: admin.email,
      decoration: InputDecoration(
          labelText: "Email:",
          icon: Icon(Icons.email,
              color: Color.fromARGB(255, 255, 102, 0))
          ),
      validator: (value) {
        if (value!.isEmpty) {
          return "This field is required";
        }
        if (!EmailValidator.validate(value)) {
          return "It is not an email format";
        }
        return null;
      },
      onSaved: (newValue) => admin.email = newValue,
    );
  }

  Widget passwordInputField() {
    return TextFormField(
      initialValue: admin.password,
      obscureText: true,
      decoration: InputDecoration(
          labelText: "Password:",
          icon: Icon(Icons.lock,
              color: Color.fromARGB(255, 255, 102, 0)) 
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

  Widget genderFormInput() {
    var initGen = "None";
    try {
      if (admin.gender != null) {
        initGen = admin.gender!;
      }
    } catch (e) {
      initGen = "None";
    }

    return DropdownButtonFormField(
        decoration: InputDecoration(
            labelText: "Gender",
            icon: Icon(Icons.man,
                color: Color.fromARGB(255, 255, 102, 0))), 
        value: initGen,
        items: Configure.gender.map((String val) {
          return DropdownMenuItem(
            value: val,
            child: Text(val),
          );
        }).toList(),
        onChanged: (value) {
          admin.gender = value;
        },
        onSaved: (newValue) => admin.gender);
  }

  Widget submitButton() {
    return ElevatedButton(
      onPressed: () {
        if (_formkey.currentState!.validate()) {
          _formkey.currentState!.save();
          print(admin.toJson().toString());
          if (admin.id == null) {
            addNewUser(admin);
          } else {
            updateData(admin);
          }
        }
      },
      child: Text("Save"),
      style: ElevatedButton.styleFrom(
          primary: Color.fromARGB(255, 255, 102, 0)),
    );
  }

  Future<void> updateData(admin) async {
    var url = Uri.http(Configure.server, "admin/${admin.id}");
    var resp = await http.put(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(admin.toJson()));
    var rs = adminFromJson("[${resp.body}]");
    if (rs.length == 1) {
      Navigator.pop(context, "refresh");
    }
    return;
  }

  Future<void> addNewUser(admin) async {
    var url = Uri.http(Configure.server, "admin/");
    var resp = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(admin.toJson()));
    var rs = adminFromJson("[${resp.body}]");
    if (rs.length == 1) {
      Navigator.pop(context, "refresh");
    }
    return;
  }
}
