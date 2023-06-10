import 'package:flutter/material.dart';
import 'login.dart';
import 'signup.dart';
import 'package:camera/camera.dart';

class LandingPage extends StatelessWidget {
  final List<CameraDescription> cameras; // Add this line

  LandingPage({required this.cameras}); // Add the named parameter
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: Text('Login'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginPage(cameras: cameras),
                  ),
                );
              },
            ),
            SizedBox(height: 10,),
            ElevatedButton(
              child: Text('Sign Up'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SignupPage(cameras: cameras,),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
