import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geogate/features/event/model/event.dart';
import 'package:geogate/core/theme/palette.dart';
import 'package:get/get.dart';
import 'package:gap/gap.dart';
import 'package:heroicons/heroicons.dart';

class EventCard extends StatelessWidget {
  final Event event;

  EventCard({required this.event});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Palette.GREEN3,
      ),
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 24),
      child: Stack(
        children: [
          // Background SVG Image
           Positioned(
            top: 8,
            right: 8,
            child: SizedBox(
              height: 120,
              width: 120,
              child: SvgPicture.asset(
                'assets/images/event.svg',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Event Date Section
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Text(
                          '${event.startDate}',
                          style: Get.textTheme.bodyMedium?.copyWith(
                            color: Palette.GREEN3,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                ],
              ),
              const Gap(16),
              // Event Description Section
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16)
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(width: Get.size.width,),
                    Text(
                      event.eventDescription ?? 'Unknown Event',
                      style: Get.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Palette.DARK_PRIMARY,
                      ),
                    ),
                    const Gap(2),
                    
                    const Gap(16),
                      Container(
                        child: Row(
                          children: [
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('${event.campus?.name}', style: Get.textTheme.bodyMedium!.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Palette.GREEN3
                                  )),
                                  Gap(8),
                                    Text('Coordinates', style: Get.textTheme.bodySmall!.copyWith(
                                    color: Palette.GREEN3
                                  ),),
                                  Gap(6),
                                  Container(width: Get.size.width,),
                                  Text('${event.campus?.latitude}', style: Get.textTheme.bodySmall,),
                                  Gap(2),
                                  Text('${event.campus?.longitude}', style: Get.textTheme.bodySmall,),
                                  Gap(2),
                                ],
                              ),
                            ),
                             Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
         color: Palette.GREEN3,
         boxShadow: [
          BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
         ]
          
        ),
        child: Center(child: ClipRRect(child: HeroIcon(HeroIcons.mapPin,color: Colors.white,size: 28,),)),
        )
                          ],
                        ),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Palette.GREEN1,
                  borderRadius: BorderRadius.circular(10),
                ),),
                  ],
                  
                ),
              ),
              // Location Section
              // Row(
              //   children: [
              //     SvgPicture.asset(
              //       'assets/images/location.svg',
              //       color: Palette.PRIMARY,
              //       height: 24,
              //       width: 24,
              //     ),
              //     const Gap(8),
              //     Expanded(
              //       child: Text(
              //         '${event.campus?.name ?? "Unknown Location"}',
              //         style: Get.textTheme.bodySmall?.copyWith(
              //           color: Palette.TEXT_DARK,
              //         ),
              //       ),
              //     ),
              //     if (event.campus != null) ...[
              //       Text(
              //         '${event.campus?.latitude ?? ""}, ${event.campus?.longitude ?? ""}',
              //         style: Get.textTheme.bodySmall?.copyWith(
              //           color: Palette.TEXT_LIGHT,
              //         ),
              //       ),
              //     ],
              //   ],
              // ),
            ],
          ),
         
        ],
      ),
    );
  }
}
