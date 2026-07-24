class LimitedPrettyLogPrinter {
  final int maxBodyCharacters;
  final void Function(Object? object) logPrint;

  bool _isPrintingResponseBody = false;
  bool _truncatedMessagePrinted = false;
  int _printedBodyCharacters = 0;

  LimitedPrettyLogPrinter({required this.maxBodyCharacters, required this.logPrint}) : assert(maxBodyCharacters > 0);

  void call(Object object) {
    final message = object.toString();

    if (_isResponseBodyStart(message)) {
      _startResponseBody();
      logPrint(object);
      return;
    }

    if (!_isPrintingResponseBody) {
      logPrint(object);
      return;
    }

    if (message.startsWith('╚')) {
      logPrint(object);
      _finishResponseBody();
      return;
    }

    // خطوط خالی ابتدایی و انتهایی کادر Body همیشه چاپ می‌شوند.
    if (message == '║') {
      logPrint(object);
      return;
    }

    final remainingCharacters = maxBodyCharacters - _printedBodyCharacters;

    if (remainingCharacters <= 0) {
      _printTruncatedMessage();
      return;
    }

    if (message.length <= remainingCharacters) {
      logPrint(object);
      _printedBodyCharacters += message.length;
      return;
    }

    logPrint(message.substring(0, remainingCharacters));
    _printedBodyCharacters = maxBodyCharacters;
    _printTruncatedMessage();
  }

  bool _isResponseBodyStart(String message) {
    return message == '╔ Body' || message.startsWith('╔ DioExceptionType.');
  }

  void _startResponseBody() {
    _isPrintingResponseBody = true;
    _truncatedMessagePrinted = false;
    _printedBodyCharacters = 0;
  }

  void _printTruncatedMessage() {
    if (_truncatedMessagePrinted) {
      return;
    }

    logPrint(
      '║ ... response body truncated after '
      '$maxBodyCharacters characters',
    );
    _truncatedMessagePrinted = true;
  }

  void _finishResponseBody() {
    _isPrintingResponseBody = false;
    _truncatedMessagePrinted = false;
    _printedBodyCharacters = 0;
  }
}
