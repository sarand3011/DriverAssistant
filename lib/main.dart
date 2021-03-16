import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async'; 
import 'dart:io';
import 'dart:ui' as ui;
import 'drawer.dart';
import 'driverassistant.dart';
//import 'package:image_picker/image_picker.dart';
Future<void> main() async {
  runApp(MaterialApp(home:MyApp(),theme: ThemeData(primarySwatch: Colors.purple), 
debugShowCheckedModeBanner: false,
    ));
} 
class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

// class _MyAppState extends State<MyApp> {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//     home:DriverAssistant(),
//     theme: ThemeData(primarySwatch: Colors.blueGrey), 
//     debugShowCheckedModeBanner: false,
//     );
//   }
// } 
class _MyAppState extends State<MyApp> {
  File _imageFile;
  List<Face> _faces;
  bool isLoading = false;
  ui.Image _image;
  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold( appBar: AppBar(
         title: Text("Driver Assistant"),
      ),
            drawer: MyDrawer(), 

        floatingActionButton: FloatingActionButton(
          onPressed: _getImage,
          child: Icon(Icons.add_a_photo),
        ),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : (_imageFile == null)
                ? Center(child: Text('no image selected'))
                : Center(
                    child: FittedBox(
                    child: SizedBox(
                      width: _image.width.toDouble(),
                      height: _image.height.toDouble(),
                      child: CustomPaint(
                        painter: FacePainter(_image, _faces),
                      ),
                    ),
                  )));
  }

  _getImage() async {
    final imageFile = await picker.getImage(source: ImageSource.camera);
    setState(() {
      isLoading = true;
    });

    final image = FirebaseVisionImage.fromFile(File(imageFile.path));
    final faceDetector = FirebaseVision.instance.faceDetector();
    List<Face> faces = await faceDetector.processImage(image);

    if (mounted) {
      setState(() {
        _imageFile = File(imageFile.path);
        _faces = faces;
        _loadImage(File(imageFile.path));
      });
    }
  }

  _loadImage(File file) async {
    final data = await file.readAsBytes();
    await decodeImageFromList(data).then((value) => setState(() {
          _image = value;
          isLoading = false;
        }));
  }
}

class FacePainter extends CustomPainter {
  final ui.Image image;
  final List<Face> faces;
  final List<Rect> rects = [];

  FacePainter(this.image, this.faces) {
    for (var i = 0; i < faces.length; i++) {
      rects.add(faces[i].boundingBox);
    }
  }

  @override
  void paint(ui.Canvas canvas, ui.Size size) {
    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0
      ..color = Colors.yellow;

    canvas.drawImage(image, Offset.zero, Paint());
    for (var i = 0; i < faces.length; i++) {
      canvas.drawRect(rects[i], paint);
    }
  }

  @override
  bool shouldRepaint(FacePainter old) {
    return image != old.image || faces != old.faces;
  }
}