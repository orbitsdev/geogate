import 'package:flutter/material.dart';

class LocalImage extends StatelessWidget {
  final String imageUrl;
  final BorderRadiusGeometry? borderRadius;
  final BoxFit? fit;
  final double? width;
  final double? height;
  final Widget? placeholder;

  LocalImage({
    Key? key,
    required this.imageUrl,
    this.borderRadius,
    this.fit,
    this.width,
    this.height,
    this.placeholder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: borderRadius ?? BorderRadius.circular(0),
      ),
      child: ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.circular(0),
        child: Image.asset(
          imageUrl,
          fit: fit ?? BoxFit.cover,
          width: width ?? MediaQuery.of(context).size.width,
          height: height,
          errorBuilder: (context, error, stackTrace) {
            return placeholder ?? 
              Container(
                width: width ?? 100,
                height: height ?? 100,
                color: Colors.grey.shade300,
                child: Center(
                  child: Icon(
                    Icons.image,
                    size: 40,
                    color: Colors.grey.shade600,
                  ),
                ),
              );
          },
        ),
      ),
    );
  }
}
