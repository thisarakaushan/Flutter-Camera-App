import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MainPage extends StatefulWidget {
  final List<CameraDescription> cameras;
  const MainPage({Key? key, required this.cameras}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late CameraController cameraController;
  late Future<void> cameraValue;

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
          builder: (context) =>
              GalleryPage(imagesList: [File(pickedFile.path)]),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    startCamera(0);
  }

  @override
  void dispose() {
    cameraController.dispose();
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
                const SizedBox(height: 20),
                Image.asset('assets/splash_image.png', height: 100, width: 100),
                const SizedBox(height: 20),
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
                    padding: const EdgeInsets.all(
                        2), // Padding to create the border effect
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
  final List<File> imagesList;

  const GalleryPage({Key? key, required this.imagesList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gallery'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 4.0,
            mainAxisSpacing: 4.0,
          ),
          itemCount: imagesList.length,
          itemBuilder: (context, index) {
            return Image.file(
              imagesList[index],
              fit: BoxFit.cover,
            );
          },
        ),
      ),
    );
  }
}
