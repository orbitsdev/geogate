import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geogate/core/shared/model/failure.dart';
import 'package:geogate/core/api/dio/response_message.dart';
import 'package:geogate/core/theme/palette.dart';

  class ErrorHandler {
    static Failure handleDio(DioException exception) {
      print('RESPONSE_____________');
      print(exception.response?.data);
      print(exception.response?.statusCode);
      print(exception.response?.statusMessage);
      print(exception.type);
      print('RESPONSE_____________----------');
      switch (exception.type) {
        case DioExceptionType.connectionTimeout:
        return Failure(
            exception: exception,
            message: exception.message,
            icon: FaIcon(
              FontAwesomeIcons.clock,
              size: 40,
              color: Palette.TEXT_LIGHT,
            ));
      case DioExceptionType.sendTimeout:
        return Failure(
            exception: exception,
            message: ResponseMessage.sendTimeout,
            icon: FaIcon(
              FontAwesomeIcons.clock,
              size: 40,
              color: Palette.TEXT_LIGHT,
            ));
      case DioExceptionType.receiveTimeout:
        return Failure(
            exception: exception,
            message: ResponseMessage.receiveTimeout,
            icon: FaIcon(
              FontAwesomeIcons.clock,
              size: 40,
              color: Palette.TEXT_LIGHT,
            ));
      case DioExceptionType.badCertificate:
        return Failure(
            exception: exception,
            message: 'Bad Certificate',
            icon: FaIcon(
              FontAwesomeIcons.ban,
              size: 40,
              color: Palette.TEXT_LIGHT,
            ));
      case DioExceptionType.badResponse:
        return handleStatusCodeError(exception);
      case DioExceptionType.cancel:
        return Failure(
            exception: exception,
            message: ResponseMessage.cancel,
            icon: FaIcon(
              FontAwesomeIcons.xmark,
              size: 40,
              color: Palette.TEXT_LIGHT,
            ));
      case DioExceptionType.connectionError:
        return Failure(
            exception: exception,
            message: ResponseMessage.noInternetConnection,
            icon: FaIcon(
              FontAwesomeIcons.towerCell,
              size: 40,
              color: Palette.TEXT_LIGHT,
            ));
      case DioExceptionType.unknown:
        return Failure(
            exception: exception,
            message: exception.message,
            icon: FaIcon(
              FontAwesomeIcons.question,
              size: 40,
              color: Palette.TEXT_LIGHT,
            ));
      default:
        return Failure(
            exception: exception,
            message: exception.message,
            icon: FaIcon(
              FontAwesomeIcons.triangleExclamation,
              size: 40,
              color: Palette.TEXT_LIGHT,
            ));
    }}
  static Failure handleStatusCodeError(DioException exception){
      if (exception.response != null) {
      switch (exception.response?.statusCode) {
        case 400:
          return Failure(
            exception: exception,
            icon: FaIcon(
              FontAwesomeIcons.triangleExclamation,
              size: 40,
            ),
            message: exception.response!.data['message'],
            statusCode: exception.response?.statusCode?.toInt(),
          );

        case 401:
         
          return Failure(
            exception: exception,
            icon: FaIcon(
              FontAwesomeIcons.triangleExclamation,
              size: 40,
            ),
            message: exception.response!.data['message'],
            statusCode: exception.response?.statusCode?.toInt(),
          );
        case 422:
          // Handle unauthorized access and check if token exists
          return Failure(
            exception: exception,
            icon: FaIcon(
              FontAwesomeIcons.triangleExclamation,
              size: 40,
            ),
            message: exception.response!.data['message'],
            statusCode: exception.response?.statusCode?.toInt(),
          );

        case 403:
          return Failure(
            exception: exception,
            icon: FaIcon(
              FontAwesomeIcons.triangleExclamation,
              size: 40,
            ),
            message: exception.response!.data['message'],
            statusCode: exception.response?.statusCode?.toInt(),
          );

        case 404:
          return Failure(
            exception: exception,
            message: exception.response!.data['message'],
            icon: FaIcon(
              FontAwesomeIcons.exclamationCircle,
              size: 40,
            ),
            statusCode: exception.response?.statusCode?.toInt(),
          );

        case 500:
          return Failure(
            exception: exception,
            icon: FaIcon(
              FontAwesomeIcons.triangleExclamation,
              size: 40,
            ),
            message: exception.response!.data['message'],
            statusCode: exception.response?.statusCode?.toInt(),
          );

        default:
          return Failure(
            exception: exception,
            icon: FaIcon(
              FontAwesomeIcons.triangleExclamation,
              size: 40,
            ),
            message: exception.response!.data['message'],
            statusCode: exception.response?.statusCode?.toInt(),
          );
      }
    } else {
      return Failure(
        exception: exception,
        message: exception.message,
        icon: FaIcon(
          FontAwesomeIcons.triangleExclamation,
          size: 40,
        ),
      );
    }
  }
  }


