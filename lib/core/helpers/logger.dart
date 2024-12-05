import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';

class DLogger {
  static bool isProduction = false; // Set to true in production to disable logs

  static void log(
    String message, {
    String level = 'INFO',
    String? tag,
    StackTrace? stackTrace,
  }) {
    if (isProduction) return;

    final timestamp = DateTime.now().toIso8601String();
    final styledMessage = _styledMessage(level, tag, message, timestamp);

    if (stackTrace != null) {
      debugPrint('$styledMessage\nStack Trace: $stackTrace');
    } else {
      debugPrint(styledMessage);
    }
  }

  static void info(String message, {String? tag, StackTrace? stackTrace}) {
    log(message, level: 'INFO', tag: tag, stackTrace: stackTrace);
  }

  static void debug(String message, {String? tag, StackTrace? stackTrace}) {
    log(message, level: 'DEBUG', tag: tag, stackTrace: stackTrace);
  }

  static void warning(String message, {String? tag, StackTrace? stackTrace}) {
    log(message, level: 'WARNING', tag: tag, stackTrace: stackTrace);
  }

  static void error(String message, {String? tag, StackTrace? stackTrace}) {
    log(message, level: 'ERROR', tag: tag, stackTrace: stackTrace);
  }

  static void success(String message, {String? tag, StackTrace? stackTrace}) {
    log(message, level: 'SUCCESS', tag: tag, stackTrace: stackTrace);
  }

  // Internal helper for styling messages
  static String _styledMessage(
    String level,
    String? tag,
    String message,
    String timestamp,
  ) {
    final Map<String, String> colors = {
      'INFO': '\x1B[34m', // Blue
      'DEBUG': '\x1B[36m', // Cyan
      'WARNING': '\x1B[33m', // Yellow
      'ERROR': '\x1B[31m', // Red
      'SUCCESS': '\x1B[32m', // Green
      'RESET': '\x1B[0m', // Reset
    };

    final color = colors[level] ?? colors['RESET']!;
    final tagPrefix = tag != null ? '[$tag] ' : '';
    return '${color}[$level][$timestamp] $tagPrefix$message${colors['RESET']}';
  }
}
