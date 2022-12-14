// ignore_for_file: use_build_context_synchronously, non_constant_identifier_names, import_of_legacy_library_into_null_safe, prefer_const_constructors, avoid_unnecessary_containers, file_names

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:linkus/screens/chatscreen%20Files/cameraView.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

List<CameraDescription>? cameras;

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key, required this.onImageSend});
  final Function onImageSend;

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _cameraController;

  late Future<void> cameraValue;
  bool FrontCam = false;

  @override
  void initState() {
    _cameraController = CameraController(cameras![1], ResolutionPreset.high);

    cameraValue = _cameraController.initialize();
    super.initState();
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.close)),
          actions: [
            IconButton(
                onPressed: () {
                  setState(() {
                    FrontCam = !FrontCam;
                    int CameraPos = FrontCam ? 0 : 1;
                    _cameraController = CameraController(
                        cameras![CameraPos], ResolutionPreset.high);
                    cameraValue = _cameraController.initialize();
                  });
                },
                icon: const Icon(
                  Icons.flip_camera_ios,
                  color: Colors.white,
                  size: 28,
                )),
          ]),
      body: Stack(children: [
        FutureBuilder(
          future: cameraValue,
          builder: ((context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return CameraPreview(_cameraController);
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
        ),
        Positioned(
          bottom: 0.0,
          child: Container(
            padding: const EdgeInsets.only(top: 5, bottom: 5),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: Colors.black,
            child: Column(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () {
                        takeSnap(context);
                      },
                      child: Container(
                        child: const Icon(
                          Icons.panorama_fish_eye,
                          color: Colors.white,
                          size: 70,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        )
      ]),
    );
  }

  void takeSnap(BuildContext context) async {
    final path = join((await getTemporaryDirectory()).path,
        "${DateTime.now().millisecondsSinceEpoch}.jpg");
    //await _cameraController.takePicture(path);
    await _cameraController.takePicture(path);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (builder) => CameraViewPage(
                  path: path,
                  OnImagesend: widget.onImageSend,
                )));
  }
}
