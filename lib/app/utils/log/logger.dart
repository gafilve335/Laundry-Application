import 'package:logger/logger.dart';

class TLoggerHelper {
  static final Logger _logger = Logger(
    printer: PrettyPrinter(),
    level: Level.debug,
  );

  static void debug(String message) {
    _logWithColor(message, Level.debug, ConsoleColor.green);
  }

  static void info(String message) {
    _logWithColor(message, Level.info, ConsoleColor.blue);
  }

  static void warning(String message) {
    _logWithColor(message, Level.warning, ConsoleColor.yellow);
  }

  static void error(String message, [dynamic error]) {
    _logWithColor(message, Level.error, ConsoleColor.red);
    if (error != null) {
      _logger.e(error);
    }
  }

  static void _logWithColor(String message, Level level, String color) {
    _logger.log(level, ConsoleColor.apply(color, message));
  }
}

class ConsoleColor {
  static const String reset = '\x1B[0m';
  static const String red = '\x1B[31m';
  static const String green = '\x1B[32m';
  static const String yellow = '\x1B[33m';
  static const String blue = '\x1B[34m';

  static String apply(String color, String text) {
    return '$color$text$reset';
  }
}
