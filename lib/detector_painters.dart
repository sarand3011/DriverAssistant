import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';

class FaceDetectorPainter extends CustomPainter {
  FaceDetectorPainter(this.absoluteImageSize, this.faces);
  int colorInt = 1;
  final Size absoluteImageSize;
  final List<Face> faces;
  List<Color> colors = [
    Colors.red,
    Colors.green,
    Colors.indigo,
    Colors.limeAccent,
    Colors.orange
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final double scaleX = size.width / absoluteImageSize.width;
    final double scaleY = size.height / absoluteImageSize.height;

    //for (Face face in faces) {
    try {
      // faces.sort()=>a.;
      Face face = faces[0];

      double averageEyeOpenProb =
          (face.leftEyeOpenProbability + face.rightEyeOpenProbability) / 2.0;
      print("hello");
      print("lefteyeprob${face.leftEyeOpenProbability}");
      print("righteyeprob${face.rightEyeOpenProbability}");

      print(averageEyeOpenProb);
      if (averageEyeOpenProb < 0.6) {
        print("Alert");
        colorInt = 0;
      } else {
        colorInt = 1;
      }

      canvas.drawRect(
          // face.boundingBox,
          Rect.fromLTRB(
            face.boundingBox.left * scaleX,
            face.boundingBox.top * scaleY,
            face.boundingBox.right * scaleX,
            face.boundingBox.bottom * scaleY,
          ),
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 4.0
            ..color = colors[colorInt]);
    } catch (e) {
      print("noFaceDetected");
    }
  }

  @override
  bool shouldRepaint(FaceDetectorPainter oldDelegate) {
    return oldDelegate.absoluteImageSize != absoluteImageSize ||
        oldDelegate.faces != faces;
  }
}
