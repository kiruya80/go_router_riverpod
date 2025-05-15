import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

var logger = Logger(
  printer: PrettyPrinter(
      methodCount: 4,
      // number of method calls to be displayed
      errorMethodCount: 8,
      // number of method calls if stacktrace is provided
      lineLength: 120,
      // width of the output
      colors: true,
      // Colorful log messages
      printEmojis: false,
      // Print an emoji for each log message
      printTime: true // Should each log print contain a timestamp
      ),
);

class QcLog {
  static d(msg) {
    if (kDebugMode) logger.d(msg);
  }

  static i(msg) {
    if (kDebugMode) logger.i(msg);
  }

  static w(msg) {
    if (kDebugMode) logger.w(msg);
  }

  static e(msg) {
    if (kDebugMode) logger.e(msg);
  }
}
