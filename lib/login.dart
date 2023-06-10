import 'package:flutter/material.dart';
import 'dashboard.dart';
import 'package:camera/camera.dart';

class LoginPage extends StatelessWidget {
  final List<CameraDescription> cameras;

  LoginPage({required this.cameras});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Column(
        children: [
          // Add your login form implementation here
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
            child: Text('Login'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Dashboard(cameras: cameras),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
