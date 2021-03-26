import 'package:flutter/material.dart';
import 'dart:async';
import 'Camera app.dart';
//import 'drawer.dart';
import 'package:camera/camera.dart';

import 'image_pickerapp.dart';



//import 'driverassistant.dart';
//import 'package:image_picker/image_picker.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  cameras = await availableCameras();
  runApp(MaterialApp(
    home: MyApp(),
    theme: ThemeData(primarySwatch: Colors.orange),
    debugShowCheckedModeBanner: false,
  ));
}