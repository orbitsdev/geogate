import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:geogate/core/shared/widgets/shimmer.dart';
import 'package:get/get.dart';


class OnlineImage extends StatelessWidget {
  final String imageUrl;

  final BorderRadiusGeometry? borderRadius;
  final BorderRadiusGeometry? borderRadiusClipRect;
  final Widget? shimmer;
  bool? isCover;
  BoxFit? fit;
  double? noImageIconSize;

  OnlineImage({
    Key? key,
    required this.imageUrl,
    this.borderRadius,
    this.borderRadiusClipRect,
    this.shimmer,
    this.isCover,
    this.noImageIconSize,
 this.fit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return 
    imageUrl.isEmpty
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
                    color: Colors.grey,
                  ),
                ),
                // Gap(2),
                // Text(
                //   'No Image',
                //   style: Get.textTheme.bodyLarge!.copyWith(
                //         color: AVANTE_LIGHT_TEXT_COLOR,
                //       ),
                // ),
              ],
            ),
          )
        : CachedNetworkImage(
            imageUrl: imageUrl,
            placeholder: (context, url) => shimmer ?? ShimmerWidget(borderRadius:  borderRadius??  BorderRadius.circular(2),),
            errorWidget: (context, url, error) => Container(
              decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: borderRadius??  BorderRadius.circular(2),

              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Icon(
                      Icons.image,
                      size: noImageIconSize ?? 24,
                      color: Colors.grey,
                    ),
                  ),
                  Gap(2),
                  Text(
                    'No Image',
                    style: Get.textTheme.bodySmall!.copyWith(
                          color: Colors.grey,
                        ),
                  ),
                ],
              ),
            ),
            fit: BoxFit.contain,
            width: Get.size.width,
            imageBuilder: (context, imageProvider) => Container(
              decoration: BoxDecoration(
                borderRadius: borderRadius ?? BorderRadius.circular(2),
                image: DecorationImage(
                  image: imageProvider,
                  fit: fit ?? BoxFit.cover,
                ),
              ),
            ),
          );
  }
}
