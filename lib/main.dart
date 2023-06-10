
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:safe_drive/SplashScreen.dart';
import 'package:safe_drive/landingpage.dart';

import 'detection_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Obtain a list of available cameras
  List<CameraDescription> cameras = await availableCameras();

  runApp(MyApp(cameras: cameras));
}

class MyApp extends StatelessWidget {
  final List<CameraDescription> cameras;

  const MyApp({Key? key, required this.cameras}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: SplashScreen(cameras: cameras,),
    );
  }
}class MyHomePage extends StatefulWidget {
  final String title;
  final List<CameraDescription> cameras;

  const MyHomePage({Key? key, required this.title, required this.cameras}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return LandingPage(cameras: widget.cameras);
  }
}
