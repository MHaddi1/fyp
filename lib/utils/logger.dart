import 'package:logger/logger.dart';

class LoggerService {
  final Logger _logger = Logger(
    printer: PrettyPrinter(methodCount: 0),
  );

  static final LoggerService _instance = LoggerService._internal();

  factory LoggerService() {
    return _instance;
  }

  LoggerService._internal();

  void logInfo(String message) {
    _logger.i(message);
  }

  void logError(String message, dynamic error, StackTrace stackTrace) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }

  void logWarning(String message) {
    _logger.w(message);
  }

  void logDebug(String message) {
    _logger.d(message);
  }

  void logVerbose(String message) {
    _logger.t(message);
  }
}
