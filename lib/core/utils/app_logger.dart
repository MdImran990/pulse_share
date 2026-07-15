import 'dart:developer' as developer;

class AppLogger {
  static void debug(String message, {String tag = 'PulseShare'}) {
    developer.log('[DEBUG] $message', name: tag);
  }

  static void info(String message, {String tag = 'PulseShare'}) {
    developer.log('[INFO] $message', name: tag);
  }

  static void warning(String message, {String tag = 'PulseShare'}) {
    developer.log('[WARNING] $message', name: tag);
  }

  static void error(String message, {Object? error, StackTrace? stackTrace, String tag = 'PulseShare'}) {
    developer.log(
      '[ERROR] $message',
      name: tag,
      error: error,
      stackTrace: stackTrace,
    );
  }
}
