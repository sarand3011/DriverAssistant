import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: const EdgeInsets.all(0),
        children: <Widget>[
          UserAccountsDrawerHeader(
              accountName: Text("SARAN D"),
              accountEmail: Text("saran@gmail.com"),
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage(
                    "https://images.unsplash.com/photo-1493863641943-9b68992a8d07?ixid=MXwxMjA3fDB8MHxzZWFyY2h8MjN8fHBlcnNvbnxlbnwwfHwwfA%3D%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60"),
              )),
          ListTile(
            leading: Icon(Icons.person),
            title: Text("SARAN D"),
            subtitle: Text("Developer"),
            trailing: Icon(Icons.edit),
            hoverColor: Colors.black12,
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text("Contact"),
            subtitle: Text("123456790"),
            trailing: Icon(Icons.edit),
            hoverColor: Colors.black12,
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
