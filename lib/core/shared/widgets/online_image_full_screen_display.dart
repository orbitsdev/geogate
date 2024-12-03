import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class OnlineImageFullScreenDisplay extends StatelessWidget {
  final String imageUrl;

  const OnlineImageFullScreenDisplay({
    Key? key,
    required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white), // Set back button color to white
      ),
      backgroundColor: Colors.black, // Full-screen black background
      body: Center(
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          placeholder: (context, url) => const CircularProgressIndicator(), // Placeholder while loading
          errorWidget: (context, url, error) => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.broken_image,
                size: 60,
                color: Colors.grey,
              ),
              const SizedBox(height: 8),
              Text(
                'Failed to load image',
                style: TextStyle(color: Colors.grey.shade300, fontSize: 16),
              ),
            ],
          ),
          fit: BoxFit.contain, // Ensure the image fits within the screen
        ),
      ),
    );
  }
}
