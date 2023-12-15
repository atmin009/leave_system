import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:leave_system/models/admin_config.dart';
import 'package:leave_system/models/admin.dart';
import 'package:leave_system/admin_screen/editinfo.dart';

class ManageAdmin extends StatefulWidget {
  static const routeName = "/ManageUser";
  const ManageAdmin({Key? key});

  @override
  State<ManageAdmin> createState() => _ManageAdminState();
}

class _ManageAdminState extends State<ManageAdmin> {
  Widget mainBody = Container();
  List<Admin> _adminList = [];

  Future<void> getAdmin() async {
    var url = Uri.http(Configure.server, "admin");
    var resp = await http.get(url);
    setState(() {
      _adminList = adminFromJson(resp.body);
      mainBody = showAdmin();
    });
    return;
  }

  Future<void> removeAdmin(admin) async {
    var url = Uri.http(Configure.server, "admin/${admin.id}");
    var resp = await http.delete(url);
    print(resp.body);
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ManageAdmin"),
        backgroundColor: Color.fromARGB(255, 255, 102, 0),
        elevation: 5.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: mainBody,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AdminForm(),
            ),
          ).then((result) {
            if (result == "refresh") {
              getAdmin();
            }
          });
        },
        child: const Icon(Icons.person_add_alt_1, color: Colors.white),
        backgroundColor: Color.fromARGB(255, 255, 102, 0),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getAdmin();
  }

  Widget showAdmin() {
    return ListView.separated(
      itemCount: _adminList.length,
      separatorBuilder: (BuildContext context, int index) => Divider(),
      itemBuilder: (context, index) {
        Admin admin = _adminList[index];
        return Dismissible(
          key: UniqueKey(),
          direction: DismissDirection.endToStart,
          onDismissed: (direction) {
            removeAdmin(admin);
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
              title: Text("${admin.fullname}", style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text("${admin.email}", style: TextStyle(color: Colors.grey[700])),
              onTap: () {
                Navigator.push(context,
                  MaterialPageRoute(
                    builder: (context) => AdminForm(),
                    settings: RouteSettings(
                      arguments: admin
                    )
                  )
                );
              },
              trailing: IconButton(
                onPressed: () async {
                  String result = await Navigator.push(context,
                    MaterialPageRoute(
                      builder: (context) => AdminForm(),
                      settings: RouteSettings(
                        arguments: admin
                      )));
                  if(result == "refresh") {
                    getAdmin();
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
