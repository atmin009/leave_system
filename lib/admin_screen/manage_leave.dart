import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:leave_system/models/leave_config.dart';
import 'package:leave_system/models/leave.dart';
import 'package:leave_system/user_screen/manage.dart';

class ManageLeave extends StatefulWidget {
  static const routeName = "/ManageLeave";
  const ManageLeave({Key? key});

  @override
  State<ManageLeave> createState() => _ManageLeaveState();
}

class _ManageLeaveState extends State<ManageLeave> {
  Widget mainBody = Container();
  List<Leave> _leaveList = [];

  Future<void> getLeave() async {
    var url = Uri.http(Configure.server, "leave");
    var resp = await http.get(url);
    setState(() {
      _leaveList = leaveFromJson(resp.body);
      mainBody = showLeave();
    });
    return;
  }

  Future<void> removeLeave(leave) async {
    var url = Uri.http(Configure.server, "leave/${leave.id}");
    var resp = await http.delete(url);
    print(resp.body);
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ManageLeave"),
        backgroundColor: Color.fromARGB(255, 255, 102, 0),
        elevation: 5.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: mainBody,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getLeave();
  }

  Widget showLeave() {
    return ListView.separated(
      itemCount: _leaveList.length,
      separatorBuilder: (BuildContext context, int index) => Divider(),
      itemBuilder: (context, index) {
        Leave leave = _leaveList[index];
        return Dismissible(
          key: UniqueKey(),
          direction: DismissDirection.endToStart,
          onDismissed: (direction) {
            removeLeave(leave);
          },
          background: Container(
            color: Colors.redAccent,
            margin: EdgeInsets.symmetric(horizontal: 15),
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Icon(Icons.delete, color: Colors.white),
            ),
          ),
          child: Card(
            elevation: 3.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: ListTile(
              title: Text("${leave.fullname}", style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text("${leave.date_start}", style: TextStyle(color: Colors.grey[700])),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LeaveForm(),
                    settings: RouteSettings(arguments: leave)
                  )
                );
              },
              trailing: IconButton(
                onPressed: () async {
                  String result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LeaveForm(),
                      settings: RouteSettings(arguments: leave)
                    )
                  );
                  if (result == "refresh") {
                    getLeave();
                  }
                },
                icon: Icon(Icons.edit, color: Color.fromARGB(255, 255, 102, 0)),
              ),
            ),
          ),
        );
      },
    );
  }
}
