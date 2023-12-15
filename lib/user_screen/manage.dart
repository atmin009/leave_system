import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:leave_system/models/user.dart';
import 'package:leave_system/models/leave_config.dart';
import 'package:http/http.dart' as http;
import 'package:leave_system/models/leave.dart';
import 'package:leave_system/user_screen/show.dart';

class LeaveForm extends StatefulWidget {
  static const routeName = "/LeaveForm";
  const LeaveForm({super.key});

  @override
  _LeaveFormState createState() => _LeaveFormState();
}

class _LeaveFormState extends State<LeaveForm> {
  final _formkey = GlobalKey<FormState>();
  late Leave leave;

  TextEditingController _dateStartController = TextEditingController();
  TextEditingController _dateEndController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    try {
      leave = ModalRoute.of(context)!.settings.arguments as Leave;
      print(leave.fullname);
      _dateStartController.text = leave.date_start ?? "";
      _dateEndController.text = leave.date_end ?? "";
    } catch (e) {
      leave = Leave();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("User Form"),
        backgroundColor: Color.fromARGB(255, 255, 102, 0),
      ),
      body: Container(
        margin: EdgeInsets.all(10),
        child: Form(
          key: _formkey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              fnameInputField(),
              genderFormInput(),
              causeInputField(),
              date_startInputField(),
              date_endInputField(),
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
      initialValue: leave.fullname,
      decoration:
          InputDecoration(labelText: "ชื่อ-นามสกุล:", icon: Icon(Icons.person, color: Color.fromARGB(255, 255, 102, 0))),
      validator: (value) {
        if (value!.isEmpty) {
          return "This field is required";
        }
        return null;
      },
      onSaved: (newValue) => leave.fullname = newValue,
    );
  }

  Widget genderFormInput() {
    var initGen = "None";
    try {
      if (leave.gender != null) {
        initGen = leave.gender!;
      }
    } catch (e) {
      initGen = "None";
    }

    return DropdownButtonFormField(
      decoration:
          InputDecoration(labelText: "ประเภทการลา", icon: Icon(Icons.man, color: Color.fromARGB(255, 255, 102, 0))),
      value: initGen,
      items: Configure.gender.map((String val) {
        return DropdownMenuItem(
          value: val,
          child: Text(val),
        );
      }).toList(),
      onChanged: (value) {
        leave.gender = value;
      },
      onSaved: (newValue) => leave.gender = newValue as String?,
    );
  }

  Widget causeInputField() {
    return TextFormField(
      initialValue: leave.cause,
      decoration:
          InputDecoration(labelText: "สาเหตุการลา:", icon: Icon(Icons.email, color: Color.fromARGB(255, 255, 102, 0))),
      validator: (value) {
        if (value!.isEmpty) {
          return "This field is required";
        }
        return null;
      },
      onSaved: (newValue) => leave.cause = newValue,
    );
  }

  Widget date_startInputField() {
    return TextFormField(
      controller: _dateStartController,
      decoration: InputDecoration(
        labelText: "วันที่และเวลาเริ่มลา:",
        icon: Icon(Icons.calendar_today, color: Color.fromARGB(255, 255, 102, 0)),
        suffixIcon: IconButton(
          icon: Icon(Icons.calendar_today),
          onPressed: () async {
            await _selectDateTime(context, _dateStartController);
          },
        ),
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return "This field is required";
        }
        return null;
      },
      onSaved: (newValue) => leave.date_start = newValue,
    );
  }

  Widget date_endInputField() {
    return TextFormField(
      controller: _dateEndController,
      decoration: InputDecoration(
        labelText: "วันที่และเวลาสิ้นสุดลา:",
        icon: Icon(Icons.calendar_today, color: Color.fromARGB(255, 255, 102, 0)),
        suffixIcon: IconButton(
          icon: Icon(Icons.calendar_today),
          onPressed: () async {
            await _selectDateTime(context, _dateEndController);
          },
        ),
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return "This field is required";
        }
        return null;
      },
      onSaved: (newValue) => leave.date_end = newValue,
    );
  }

  Future<void> _selectDateTime(
      BuildContext context, TextEditingController controller) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (selectedDate != null) {
      TimeOfDay? selectedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (selectedTime != null) {
        DateTime fullDate = DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
          selectedTime.hour,
          selectedTime.minute,
        );
        controller.text = fullDate.toString();
      }
    }
  }

  Widget submitButton() {
    return ElevatedButton(
        onPressed: () {
          if (_formkey.currentState!.validate()) {
            _formkey.currentState!.save();
            print(leave.toJson().toString());
            if (leave.id == null) {
              addNewLeave(leave);
            } else {
              updateLeave(leave);
            }
          }
        },
        child: Text("บันทึกข้อมูล"),style: ElevatedButton.styleFrom(
          primary: Color.fromARGB(255, 255, 102, 0)),);
  }

  Future<void> updateLeave(Leave leave) async {
    var url = Uri.http(Configure.server, "leave/${leave.id}");
    var resp = await http.put(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(leave.toJson()));
    var rs = usersFromJson("[${resp.body}]");
    if (rs.length == 1) {
      Navigator.pop(context, "refresh");
    }
    return;
  }

  Future<void> addNewLeave(Leave leave) async {
    var url = Uri.http(Configure.server, "leave/");
    var resp = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(leave.toJson()));
    var rs = usersFromJson("[${resp.body}]");
    if (rs.length == 1) {
      Navigator.pushNamed(context, Show.routeName);
    }
    return;
  }
}
