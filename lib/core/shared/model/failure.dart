

import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';



class Failure {
  DioException? exception;
  String? header;
  String? message;
  int? statusCode;
  Widget? icon;
  Failure({
    this.exception,
    this.header,
    this.message,
    this.statusCode,
    this.icon,
  });
  // Failure(
  //   {
  //   this.exception,
  //   this.header = 'An error occurred',
  //   this.message = 'Something went wrong. Please try again.',
  //   this.statusCode = 500,
  //   this.icon =  const FaIcon(FontAwesomeIcons.triangleExclamation,size: 40, color: grayTextV2,) 
  // });


 void printError() {
    if (message != null) {
      print('-----------------------------');
      print('MESSAGE:  ${message}');
      print('-----------------------------');
    } else {
      print('-----------------------------');
      print('NO MESSAGE');
      print('-----------------------------');
    }

    if (header != null) {
      print('-----------------------------');
      print('ERROR ');
      print('-----------------------------');
     
    } else {
      print('-----------------------------');
      print('NO ERROR ');
      print('-----------------------------');
    }

    if (statusCode != null) {
      print('-----------------------------');
      print('STATUS CODE ${statusCode}');
      print('-----------------------------');
    } else {
      print('-----------------------------');
      print('NO STATUS CODE');
      print('-----------------------------');
    }
  }


  Failure copyWith({
    DioException? exception,
    String? header,
    String? message,
    int? statusCode,
    Widget? icon,
  }) {
    return Failure(
      exception: exception ?? this.exception,
      header: header ?? this.header,
      message: message ?? this.message,
      statusCode: statusCode ?? this.statusCode,
      icon: icon ?? this.icon,
    );
  }

}