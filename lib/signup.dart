// pages/signup_page.dart

import 'package:flutter/material.dart';
import 'package:safe_drive/landingpage.dart';
import 'package:camera/camera.dart';

class SignupPage extends StatelessWidget {
  final List<CameraDescription> cameras;

  SignupPage({required this.cameras});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: Column(
        children: [
          // Add your sign up form implementation here
          // Example:
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Email',
            ),
          ),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Password',
            ),
            obscureText: true,
          ),
          ElevatedButton(
            child: Text('Sign Up'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LandingPage(cameras:cameras),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
