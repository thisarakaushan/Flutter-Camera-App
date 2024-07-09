import 'dart:async';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:camera_app/main_page.dart';

class SplashPage extends StatefulWidget {
  final List<CameraDescription> cameras;
  const SplashPage({super.key, required this.cameras});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => MainPage(cameras: widget.cameras),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Color(0xFF1E477E), // Background color for the splash screen
      body: Center(
        child: Image.asset(
          'assets/splash_image.png', // Replace with your splash image asset
          width: 200, // Adjust width as needed
          height: 200, // Adjust height as needed
          fit: BoxFit.contain, // Maintain aspect ratio
        ),
      ),
    );
  }
}
