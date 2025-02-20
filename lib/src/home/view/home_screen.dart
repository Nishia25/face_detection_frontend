// import 'package:camera/camera.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
//
// class HomeScreen extends StatefulWidget {
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   CameraController? _cameraController;
//   late List<CameraDescription> _cameras;
//   bool _isFaceDetected = false;
//   late FaceDetector _faceDetector;
//   bool _isProcessing = false;
//   late Face? _detectedFace;
//
//   @override
//   void initState() {
//     super.initState();
//     _initializeCamera();
//     _faceDetector = FaceDetector(options: FaceDetectorOptions());
//   }
//
//   Future<void> _initializeCamera() async {
//     _cameras = await availableCameras();
//     if (_cameras.isEmpty) {
//       print("No cameras available.");
//       return;
//     }
//
//     _cameraController = CameraController(_cameras[0], ResolutionPreset.medium);
//     await _cameraController!.initialize();
//     if (mounted) {
//       setState(() {});
//       _startFaceDetection();
//     }
//   }
//
//   void _startFaceDetection() {
//     _cameraController!.startImageStream((CameraImage image) async {
//       if (_isProcessing) return;
//       _isProcessing = true;
//
//       final WriteBuffer allBytes = WriteBuffer();
//       for (final Plane plane in image.planes) {
//         allBytes.putUint8List(plane.bytes);
//       }
//       final bytes = allBytes.done().buffer.asUint8List();
//
//       final inputImage = InputImage.fromBytes(
//         bytes: bytes,
//         metadata: InputImageMetadata(
//           size: Size(image.width.toDouble(), image.height.toDouble()),
//           rotation: InputImageRotation.rotation0deg,
//           format: InputImageFormat.nv21,
//           bytesPerRow: image.planes[0].bytesPerRow,
//         ),
//       );
//
//       final List<Face> faces = await _faceDetector.processImage(inputImage);
//       if (faces.isNotEmpty) {
//         _detectedFace = faces.first;
//       } else {
//         _detectedFace = null;
//       }
//       setState(() {
//         _isFaceDetected = _detectedFace != null;
//       });
//       _isProcessing = false;
//     });
//   }
//
//   @override
//   void dispose() {
//     _cameraController?.dispose();
//     _faceDetector.close();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Face Detection'),
//         backgroundColor: Colors.blueAccent,
//         centerTitle: true,
//       ),
//       body: Stack(
//         children: [
//           // Camera Preview
//           _cameraController == null || !_cameraController!.value.isInitialized
//               ? Center(child: CircularProgressIndicator())
//               : CameraPreview(_cameraController!),
//
//           // Circular Mask to Show Only Face Area
//           Center(
//             child: ClipOval(
//               child: Container(
//                 width: 250,
//                 height: 250,
//                 decoration: BoxDecoration(
//                   border: Border.all(color: Colors.red, width: 3),
//                   gradient: LinearGradient(
//                     colors: [Colors.blueAccent.withOpacity(0.5), Colors.greenAccent.withOpacity(0.5)],
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                   ),
//                   boxShadow: [
//                     BoxShadow(color: Colors.black26, blurRadius: 10, spreadRadius: 2)
//                   ],
//                 ),
//                 child: _isFaceDetected
//                     ? ClipRect(
//                   child: Align(
//                     alignment: Alignment.center,
//                     widthFactor: 1.0,
//                     heightFactor: 1.0,
//                     child: CustomPaint(
//                       painter: FacePainter(_detectedFace!),
//                     ),
//                   ),
//                 )
//                     : Center(child: Text("No Face Detected", style: TextStyle(color: Colors.white, fontSize: 18))),
//               ),
//             ),
//           ),
//
//           // Status text at the bottom
//           Align(
//             alignment: Alignment.bottomCenter,
//             child: Padding(
//               padding: const EdgeInsets.all(20.0),
//               child: Text(
//                 _isFaceDetected ? "Face Detected" : "Place Face Inside the Circle",
//                 style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class FacePainter extends CustomPainter {
//   final Face face;
//   FacePainter(this.face);
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     Paint paint = Paint()
//       ..color = Colors.red.withOpacity(0.5)
//       ..style = PaintingStyle.fill;
//
//     // Get the bounding box of the face
//     final faceRect = face.boundingBox;
//
//     // Calculate the scale factor to fit the face inside the circular mask
//     double scaleX = size.width / faceRect.width;
//     double scaleY = size.height / faceRect.height;
//     double scale = scaleX < scaleY ? scaleX : scaleY;
//
//     // Create a transformation matrix to scale and position the face inside the circle
//     canvas.translate(size.width / 2 - (faceRect.center.dx * scale), size.height / 2 - (faceRect.center.dy * scale));
//     canvas.scale(scale);
//
//     // Draw the face inside the circular region
//     canvas.drawOval(faceRect, paint);
//   }
//
//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) {
//     return false;
//   }
// }
