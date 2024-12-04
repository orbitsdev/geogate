import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:geogate/core/theme/palette.dart';

class SvgImage extends StatelessWidget {
  final String assetPath;
  final BorderRadiusGeometry? borderRadius;
  final double? height;
  final double? width;
  final Color? color;
  final double? noImageIconSize;

  SvgImage({
    Key? key,
    required this.assetPath,
    this.borderRadius,
    this.height,
    this.width,
    this.color,
    this.noImageIconSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return assetPath.isEmpty
        ? Container(
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Icon(
                    Icons.image,
                    size: noImageIconSize ?? 24,
                    color: Palette.LIGHT_PRIMARY,
                  ),
                ),
                Gap(2),
                Text(
                  'No Image',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Palette.LIGHT_PRIMARY,
                      ),
                ),
              ],
            ),
          )
        : ClipRRect(
            borderRadius: borderRadius ?? BorderRadius.circular(8),
            child: SvgPicture.asset(
              assetPath,
              height: height,
              width: width,
              color: color,
              fit: BoxFit.contain,
            ),
          );
  }
}
