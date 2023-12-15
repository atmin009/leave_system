import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:leave_system/models/user_config.dart';
import 'package:leave_system/models/user.dart';
import 'package:leave_system/user_screen/editinfo.dart';

class ManageUsers extends StatefulWidget {
  static const routeName = "/ManageUsers";
  const ManageUsers({Key? key});

  @override
  State<ManageUsers> createState() => _ManageUsersState();
}

class _ManageUsersState extends State<ManageUsers> {
  Widget mainBody = Container();
  List<Users> _usersList = [];

  Future<void> getUsers() async {
    var url = Uri.http(Configure.server, "users");
    var resp = await http.get(url);
    setState(() {
      _usersList = usersFromJson(resp.body);
      mainBody = showUsers();
    });
    return;
  }

  Future<void> removeUsers(users) async {
    var url = Uri.http(Configure.server, "users/${users.id}");
    var resp = await http.delete(url);
    print(resp.body);
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ManageUsers"),
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
              builder: (context) => UsersForm(),
            ),
          ).then((result) {
            if (result == "refresh") {
              getUsers();
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
    getUsers();
  }

  Widget showUsers() {
    return ListView.separated(
      itemCount: _usersList.length,
      separatorBuilder: (BuildContext context, int index) => Divider(),
      itemBuilder: (context, index) {
        Users users = _usersList[index];
        return Dismissible(
          key: UniqueKey(),
          direction: DismissDirection.endToStart,
          onDismissed: (direction) {
            removeUsers(users);
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
              title: Text("${users.fullname}", style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text("${users.email}", style: TextStyle(color: Colors.grey[700])),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UsersForm(),
                    settings: RouteSettings(arguments: users)
                  )
                );
              },
              trailing: IconButton(
                onPressed: () async {
                  String result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UsersForm(),
                      settings: RouteSettings(arguments: users)
                    )
                  );
                  if(result == "refresh") {
                    getUsers();
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
