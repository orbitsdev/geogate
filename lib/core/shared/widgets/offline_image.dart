// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class OfflineImage extends StatelessWidget {

  final String path;
   BorderRadiusGeometry? borderRadius;
   BoxFit? fit;

   OfflineImage({
    Key? key,
    required this.path,
    this.borderRadius,
    this.fit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context){
     return Container(
  decoration: BoxDecoration(
    borderRadius: borderRadius,
  ),
  child: ClipRRect(
    borderRadius: borderRadius ?? BorderRadius.circular(0),
    child: Image.asset(
      path,
      fit:fit ?? BoxFit.cover,
      width: MediaQuery.of(context).size.width,
    ),
  ),
);
  }
}
