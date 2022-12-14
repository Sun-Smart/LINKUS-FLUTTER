// ignore_for_file: avoid_print, file_names, non_constant_identifier_names

import 'dart:io';
import 'package:flutter/material.dart';

class CameraViewPage extends StatelessWidget {
  CameraViewPage({super.key, required this.path, required this.OnImagesend});
  final String path;
  final Function OnImagesend;
  final TextEditingController _caption = TextEditingController();

  @override
  Widget build(BuildContext context) {
    print(">??>?>?>?>?>?>?>?>?>?>?>?>?>?>?>printing?>?>?>?>?>?>?>?>?>?$path");
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.black,
          automaticallyImplyLeading: false,
          actions: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.crop_rotate)),
            IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.emoji_emotions_outlined,
                ))
          ]),
      body: Container(
        color: Colors.black,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height - 150,
              child: Image.file(
                File(path),
                fit: BoxFit.contain,
              ),
            ),
            Positioned(
              bottom: 0,
              child: Container(
                color: Colors.black38,
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                child: TextFormField(
                  controller: _caption,
                  maxLines: 6,
                  minLines: 1,
                  style: const TextStyle(color: Colors.white, fontSize: 17),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Add a caption",
                    contentPadding: const EdgeInsets.symmetric(vertical: 15),
                    hintStyle:
                        const TextStyle(color: Colors.white, fontSize: 17),
                    prefixIcon: const Icon(
                      Icons.add_photo_alternate,
                      color: Colors.white,
                      size: 27,
                    ),
                    suffixIcon: InkWell(
                      onTap: () {
                        print("cccccccccc-----------$path");
                        OnImagesend(path, _caption.text.trim());
                        print("cccccccccssssss-----------${_caption.text}");
                        Navigator.pop(context);
                        Navigator.pop(context);
                        // Navigator.pop(context);
                      },
                      child: const CircleAvatar(
                        child: Icon(Icons.send),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
