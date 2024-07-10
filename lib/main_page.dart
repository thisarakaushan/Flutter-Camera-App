import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'package:gallery_saver/gallery_saver.dart';

class MainPage extends StatefulWidget {
  final List<CameraDescription> cameras;
  const MainPage({super.key, required this.cameras});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  late CameraController cameraController;
  late Future<void> cameraValue;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    startCamera(0);
    _controller = AnimationController(
      duration: const Duration(
          seconds: 30), // Adjust duration as needed to change rotation speed
      vsync: this,
    )..repeat();
  }

  void startCamera(int camera) {
    cameraController = CameraController(
      widget.cameras[camera],
      ResolutionPreset.high,
      enableAudio: false,
    );
    cameraValue = cameraController.initialize();
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 50, // Optional: to reduce image size
    );

    if (pickedFile != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GalleryPage(image: File(pickedFile.path)),
        ),
      );
    }
  }

  Future<void> _capturePhoto() async {
    try {
      await cameraValue; // Ensure the camera is initialized
      final image = await cameraController.takePicture();

      // Save the captured photo to the system gallery
      await GallerySaver.saveImage(image.path, albumName: 'MyAppPhotos');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Photo saved to gallery')),
      );
    } catch (e) {
      print(e); // Handle error appropriately
    }
  }

  @override
  void dispose() {
    cameraController.dispose();
    _controller.dispose(); // Dispose animation controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          FutureBuilder(
            future: cameraValue,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return SizedBox(
                  width: size.width,
                  height: size.height,
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: 357.5, // Adjusted width
                      height: 336.5, // Adjusted height
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: AspectRatio(
                          aspectRatio: cameraController.value.aspectRatio,
                          child: CameraPreview(cameraController),
                        ),
                      ),
                    ),
                  ),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.menu, color: Colors.white),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.white),
                      onPressed: () {},
                    ),
                  ],
                ),
                const Spacer(),
                Container(
                  width: size.width * 0.8,
                  height: size.height * 0.3,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: CameraPreview(cameraController),
                  ),
                ),
                const SizedBox(height: 5),
                AnimatedBuilder(
                  animation: _controller,
                  child: Image.asset('assets/main_image.png',
                      height: 131, width: 131),
                  builder: (context, child) {
                    return Transform.rotate(
                      angle: _controller.value * 2.0 * 3.141592653589793,
                      child: child,
                    );
                  },
                ),
                const SizedBox(height: 5), // Adjust SizedBox for spacing
                ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [
                      Color(0xff2753cf),
                      Color(0xffc882ff),
                      Color(0xff46edfe)
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ).createShader(bounds),
                  child: const Text(
                    'What are you looking at?',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
                const Text(
                  'Focus your camera on anything around you',
                  style: TextStyle(color: Color(0xff46edfe), fontSize: 16),
                ),
                const Spacer(),
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(35),
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xff2753cf),
                        Color(0xffc882ff),
                        Color(0xff46edfe)
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(2),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: const Color(0xff0e235a),
                        borderRadius: BorderRadius.circular(35),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.camera_alt, color: Colors.white),
                        onPressed: _capturePhoto,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  width: 270,
                  height: 74,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(90),
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xff2753cf),
                        Color(0xffc882ff),
                        Color(0xff46edfe)
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(2),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: const Color(0xff0e235a),
                        borderRadius: BorderRadius.circular(90),
                      ),
                      child: ElevatedButton(
                        onPressed: _pickImage,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(90),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 15),
                          shadowColor: Colors.transparent,
                        ),
                        child: const Text(
                          'Gallery',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class GalleryPage extends StatelessWidget {
  final File image;

  const GalleryPage({Key? key, required this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gallery'),
      ),
      body: Center(
        child: Image.file(image, fit: BoxFit.cover),
      ),
    );
  }
}
