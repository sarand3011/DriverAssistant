import 'package:flutter/material.dart';
import 'CameraPreview.dart';

void main() {
  runApp(
    MaterialApp(
      home: CameraPreviewScanner(),
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      debugShowCheckedModeBanner: false,
    ),
  );
}

