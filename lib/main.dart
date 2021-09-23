import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:camera/camera.dart';
import 'package:wakelock/wakelock.dart';

List<CameraDescription> cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIOverlays([]);
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  cameras = await availableCameras();
  runApp(CameraApp());
}

class CameraApp extends StatefulWidget {
  @override
  _CameraAppState createState() => _CameraAppState();
}

class _CameraAppState extends State<CameraApp> {
  double scale = 1.0;
  CameraController cameraController;

  @override
  void initState() {
    super.initState();

    cameraController = CameraController(
      cameras[0],
      ResolutionPreset.max,
    );

    cameraController.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {
        Wakelock.enable();
      });
    });
  }

  @override
  void dispose() {
    cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!cameraController.value.isInitialized) {
      return Container();
    }

    return MaterialApp(
      title: 'Mi Cámara',
      theme: ThemeData.dark().copyWith(
        primaryColor: Color.fromRGBO(33, 47, 61, 1.0),
        backgroundColor: Color.fromRGBO(33, 47, 61, 1.0),
      ),
      home: GestureDetector(
        onScaleUpdate: (ScaleUpdateDetails one) {
          scale = one.scale < 1.0 ? 1.0 : one.scale;

          setState(() {});
        },
        child: Transform.scale(
          scale: scale,
          child: CameraPreview(cameraController),
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
