// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';


import 'package:flutter_svg/svg.dart';

class LocalImageSvg extends StatelessWidget {
  final String imageUrl;
   BorderRadiusGeometry? borderRadius;
   LocalImageSvg({
    super.key,
    required this.imageUrl,
    this.borderRadius,
  });


  @override
  Widget build(BuildContext context) {
   return Container(
      decoration: BoxDecoration(
        borderRadius: borderRadius,
      ),
      child: ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.circular(0),
        child: SvgPicture.asset(
          imageUrl,
          fit: BoxFit.cover,
          width: MediaQuery.of(context).size.width,
        ),
      ),
    );

  }
}
