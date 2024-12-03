// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:geogate/core/theme/palette.dart';
import 'package:shimmer/shimmer.dart';



class ShimmerWidget extends StatelessWidget {
   double? width;
   double? height;
   EdgeInsetsGeometry? margin;
   EdgeInsetsGeometry? padding;
   BorderRadiusGeometry? borderRadius;
   Color? baseColor;
   Color? highlightColor;
   ShimmerWidget({
    Key? key,
    this.width,
    this.height,
    this.margin,
    this.padding,
    this.borderRadius,
    this.baseColor,
    this.highlightColor,
  }) : super(key: key);


  
  
 

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      margin: margin,
      width:  width?? double.infinity,
      height: height ?? double.infinity,
      child: Shimmer.fromColors(
      direction: ShimmerDirection.ltr,
        // baseColor: baseColor?? avanteMainBgColor300,
        baseColor: baseColor?? Palette.SHIMMER3,
        highlightColor: highlightColor?? Palette.SHIMMER2,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: borderRadius ?? BorderRadius.circular(2),
            color: Palette.SHIMMER1,
          ),
        ),
      ),
    );
  }
}
