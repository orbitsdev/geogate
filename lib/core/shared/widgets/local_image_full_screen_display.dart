import 'package:flutter/material.dart';

class LocalImageFullScreenDisplay extends StatelessWidget {
  final String imageUrl;

  LocalImageFullScreenDisplay({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Add an AppBar for navigation and aesthetics
        leading: IconButton(icon: Icon(Icons.close, color: Colors.white,), onPressed: () => Navigator.pop(context),),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: Colors.black, // Set background color to black for full-screen effect
      body: Center(
        child: Hero(
          tag: imageUrl,
          child: Image.asset(
            imageUrl,
            fit: BoxFit.contain, // Adjust the fit as needed
          ),
        ),
      ),
    );
  }
}
