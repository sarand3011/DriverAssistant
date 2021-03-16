import 'package:driverassistant/drawer.dart';
import 'package:flutter/material.dart';

class DriverAssistant extends StatefulWidget {
  DriverAssistant({Key key}) : super(key: key);

  @override
  _DriverAssistantState createState() => _DriverAssistantState();
}

class _DriverAssistantState extends State<DriverAssistant> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
         title: Text("Driver Assistant"),
      ),
      body: Container(), 
      drawer: MyDrawer(), 
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        tooltip: 'Pick Image',
        child: Icon(Icons.videocam)
        
      ),
    );
  }
}
