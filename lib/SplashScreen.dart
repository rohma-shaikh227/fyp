
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:safe_drive/landingpage.dart';
import 'package:safe_drive/main.dart';
import 'package:camera/camera.dart';
class SplashScreen extends StatefulWidget
{  final List<CameraDescription> cameras;

  SplashScreen({required this.cameras});

@override
  State<SplashScreen> createState() => _SplashScreenState();
}
class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 2), () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder:
          (context) => LandingPage(cameras: widget.cameras))); // Pass the 'cameras' parameter to LandingPage
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.green,
      ),
    );
  }
}
