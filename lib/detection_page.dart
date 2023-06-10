import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as ImageLib;

class DetectionPage extends StatefulWidget {
  final List<CameraDescription> cameras;

  DetectionPage({required this.cameras}) : assert(cameras.isNotEmpty);

  @override
  _DetectionPageState createState() => _DetectionPageState();
}

class _DetectionPageState extends State<DetectionPage> {
  CameraController? cameraController;
  bool isCameraInitialized = false;
  bool isDrowsy = false;
  int framesSinceLastPrediction = 0;
  bool isLoading = false;
  String detectionResult = 'null';

  @override
  void initState() {
    super.initState();
    initializeCamera();
  }

  @override
  void dispose() {
    cameraController?.dispose();
    super.dispose();
  }

  Future<void> initializeCamera() async {
    CameraDescription? frontCamera;
    for (var camera in widget.cameras) {
      if (camera.lensDirection == CameraLensDirection.front) {
        frontCamera = camera;
        break;
      }
    }

    if (frontCamera == null) {
      print('Front camera not found');
      return;
    }

    cameraController = CameraController(frontCamera, ResolutionPreset.medium);
    await cameraController!.initialize();
    if (!mounted) return;
    setState(() {
      isCameraInitialized = true;
    });
    startDrowsinessDetection();
  }

  void startDrowsinessDetection() {
    cameraController!.startImageStream((CameraImage image) {
      if (framesSinceLastPrediction % 5 == 0) {
        classifyImage(image);
      }
      framesSinceLastPrediction++;
    });
  }

  void classifyImage(CameraImage image) async {
    if (isDrowsy) return;

    List<int> jpegData = convertYUV420toJPEG(image);
    await callFlaskAPI(jpegData);
  }

  List<int> convertYUV420toJPEG(CameraImage image) {
    // Get the Y, U, V planes from the image
    Plane yPlane = image.planes[0];
    Plane uPlane = image.planes[1];
    Plane vPlane = image.planes[2];

    // Get the dimensions of the image
    int width = image.width;
    int height = image.height;

    // Create a byte buffer to hold the image data
    List<int> imageData = List<int>.filled(width * height * 3 ~/ 2, 0);

    // Convert YUV420 to RGB
    int uvIndex = 0;
    for (int y = 0; y < height; y++) {
      int uvRowStart = uvIndex;
      int uvRowEnd = uvRowStart + uPlane.bytesPerRow;
      int yRowIndex = y * yPlane.bytesPerRow;

      for (int x = 0; x < width; x++) {
        int uvIndex = uvRowStart + (x >> 1);

        // Get the Y, U, V values for the current pixel
        int yValue = yPlane.bytes[yRowIndex + x];
        int uValue = uPlane.bytes[uvIndex];
        int vValue = vPlane.bytes[uvIndex];

        // Convert YUV to RGB
        int r = (yValue + 1.402 * (vValue - 128)).toInt();
        int g = (yValue - 0.344136 * (uValue - 128) - 0.714136 * (vValue - 128)).toInt();
        int b = (yValue + 1.772 * (uValue - 128)).toInt();

        // Clamp the RGB values to the valid range (0-255)
        r = r.clamp(0, 255);
        g = g.clamp(0, 255);
        b = b.clamp(0, 255);

        // Store the RGB values in the image data buffer
        int index = y * width + x;
        imageData[index] = r;
        imageData[index + width * height] = g;
        imageData[index + width * height + width * height ~/ 4] = b;
      }

      // Increment the UV index for the next row
      uvIndex += uPlane.bytesPerRow;
    }

    // Encode the RGB image data to JPEG
    List<int> jpegData = ImageLib.encodeJpg(ImageLib.Image.fromBytes(width, height, imageData), quality: 100);

    return jpegData.toList();
  }

  Future<void> callFlaskAPI(List<int> imageBytes) async {
    final String url = 'http://localhost:5000/predict'; // Update with your API endpoint URL

    setState(() {
      isLoading = true;
    });

    try {
      // Create a new http.Client instance
      var client = http.Client();

      // Create a multipart request with the image file
      var request = http.MultipartRequest('POST', Uri.parse(url));
      request.files.add(
        http.MultipartFile.fromBytes(
          'image',
          imageBytes,
          filename: 'image.jpg',
        ),
      );

      // Send the request and get the response
      var response = await client.send(request);

      // Get the response body
      var responseBody = await response.stream.bytesToString();

      // Process the response
      Map<String, dynamic> data = json.decode(responseBody);
      print('Response Data: $data');
      bool isDrowsy = data['isDrowsy'];

      setState(() {
        isLoading = false;
        detectionResult = isDrowsy ? 'Drowsy' : 'Not Drowsy';
      });

      // Close the client after use
      client.close();
    } catch (e) {
      // Handle any errors
      print('Error: $e');
      setState(() {
        isLoading = false;
        detectionResult = 'Error occurred';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!isCameraInitialized) {
      return Container();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Drowsiness Detection'),
      ),
      body: Stack(
        children: [
          CameraPreview(cameraController!),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: EdgeInsets.all(16),
              color: Colors.black54,
              child: isLoading
                  ? CircularProgressIndicator()
                  : Text(
                detectionResult,
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
