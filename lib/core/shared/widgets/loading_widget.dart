// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoadingWidget extends StatelessWidget {
  String? message = 'message';
   LoadingWidget({
    Key? key,
    this.message,
  }) : super(key: key);
  @override
  Widget build(BuildContext context){
    return  Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(width: 24),
            CircularProgressIndicator(),
            SizedBox(width: 36),
            Text(
              '${message}',
              style: Get.textTheme.titleMedium,
            ),
          ],
        );
  }
}
