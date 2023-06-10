import 'package:flutter/material.dart';
import 'detection_page.dart';
import 'package:camera/camera.dart';

class Dashboard extends StatelessWidget {
  final List<CameraDescription> cameras;

  Dashboard({required this.cameras});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      body: Center(
        child: ElevatedButton(
          child: Text('Start Detection'),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetectionPage(cameras: cameras),
              ),
            );
          },
        ),
      ),
    );
  }
}
