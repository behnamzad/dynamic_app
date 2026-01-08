import 'package:flutter/material.dart';

class AppLogger {
  static debugLog(msg) {
    debugPrint('(===========================>>>  $msg )');
  }
  static debugLogWithTag(String tag,msg) {
    debugPrint('$tag ===========================>>>  $msg )');
  }

  static debugLog1(msg) {
    debugPrint(msg);
  }
}
