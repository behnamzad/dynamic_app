import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class KeyboardHelper {
  static void closeKeyboard(BuildContext context) => FocusScope.of(context).requestFocus(FocusNode());
  static void openKeyboard(BuildContext context) => SystemChannels.textInput.invokeMethod('TextInput.show');
}
