import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LocalFileImageFullScreenDisplay extends StatelessWidget {
  final String imagePath;

  LocalFileImageFullScreenDisplay({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: Image.file(
              File(imagePath),
              fit: BoxFit.contain,
            ),
          ),
          Positioned(
            top: 40, // Adjust as needed
            right: 20,
            child: IconButton(
              icon: Icon(Icons.close, color: Colors.white, size: 30),
              onPressed: () {
                Get.back();

              },
            ),
          ),
        ],
      ),
    );
  }
}
