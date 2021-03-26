import 'package:camera/camera.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'drawer.dart'; 
import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;
List<CameraDescription> cameras;
String _timestamp() => DateTime.now().millisecondsSinceEpoch.toString();
class CameraApp extends StatefulWidget {
  @override
  _CameraAppState createState() => _CameraAppState();
}

class _CameraAppState extends State<CameraApp> {
  File _imageFile;
  List<Face> _faces;
  bool isLoading = false;
  ui.Image _image;
  CameraController _controller;
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  
  @override
  void initState() {
    super.initState();
    _controller = CameraController(cameras[1], ResolutionPreset.medium);
    _controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  Widget _buildCameraPreview() {
    final size = MediaQuery.of(context).size;
    return ClipRect(
      child: Container( 
        height: size.height,
        width: size.width,
        // scale: _controller.value.aspectRatio / (size.aspectRatio),
        child: Center(
          // child: AspectRatio(
          //aspectRatio: _controller.value.aspectRatio,
          child: CameraPreview(_controller),
          // ),
        ),
      ),
      // ),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.value.isInitialized) {
      return Container();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Driver Assistant"),
      ),
      drawer: MyDrawer(),
      backgroundColor: Theme.of(context).backgroundColor,
       key: _scaffoldKey,
      //extendBody: true,
      body: Stack(
        children: <Widget>[
          _buildCameraPreview(),
           FloatingActionButton(onPressed: (){_captureImage();},),
          FloatingActionButton(
        child: Icon(Icons.camera_alt),
        // Provide an onPressed callback.
        onPressed: () async {
          // Take the Picture in a try / catch block. If anything goes wrong,
          // catch the error.
          try {
            // Ensure that the camera is initialized.
            await _controller.initialize();

            // Attempt to take a picture and get the file `image`
            // where it was saved.
            final image = await _controller.takePicture();

            // If the picture was taken, display it on a new screen.
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DisplayPictureScreen(
                  // Pass the automatically generated path to
                  // the DisplayPictureScreen widget.
                  imagePath: image?.path,
                ),
              ),
            );
          } catch (e) {
            // If an error occurs, log the error to the console.
            print(e);
          }
        },
      ), 
        ],
      ), 
    );
   
  }  
  _loadImage(File file) async {
    final data = await file.readAsBytes();
    await decodeImageFromList(data).then((value) => setState(() {
          _image = value;
          isLoading = false;
        }));
  }
 int c=0;
  void _captureImage() async {
    print('_captureImage.............................................');
    if (_controller.value.isInitialized) {
      SystemSound.play(SystemSoundType.click);
      final Directory extDir = await getApplicationDocumentsDirectory();
      final String dirPath = '${extDir.path}/media';
      await Directory(dirPath).create(recursive: true);
      final String filePath = '$dirPath/${_timestamp()}.jpeg';
      print('path: $filePath'); 
      await _controller.initialize();
      final pic=_controller.takePicture(); 
    // print(pic);
      setState(() {}); 
      final image = FirebaseVisionImage.fromFile(File(filePath));
    final faceDetector = FirebaseVision.instance.faceDetector();
    List<Face> faces = await faceDetector.processImage(image); 
     
    if (mounted) {
      setState(() {
        _imageFile = File(filePath);
        _faces = faces;
        _loadImage(File(filePath));
      });
    }
    }
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

class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({Key key, this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Display the Picture')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body:Row(
  children: <Widget>[ Image.file(File(imagePath)),
      // (Image.file(File(imagePath)) == null)
      //           ? Center(child: Text('no image selected'))
      //           : Center(
      //               child: FittedBox(
      //               child: SizedBox(
      //                 width: Image.file(File(imagePath)).width.toDouble(),
      //                 height: Image.file(File(imagePath)).height.toDouble(),
      //                 child: CustomPaint(
      //                   painter: FacePainter(Image.file(File(imagePath)),),
      //                 ),
      //               ),
      //             ))
      ])
    );
  }
}