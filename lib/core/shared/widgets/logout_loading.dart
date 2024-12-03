import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LogoutLoading extends StatelessWidget {
const LogoutLoading({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(width: 24),
          CircularProgressIndicator(),
          SizedBox(width: 36),
          Text(
            "Logging out...",
            style: Get.textTheme.titleMedium,
          ),
        ],
      );
  }
}