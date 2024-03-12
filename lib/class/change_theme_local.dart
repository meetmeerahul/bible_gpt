import 'package:flutter/cupertino.dart';

class ChangeThemeLocal with ChangeNotifier {
  bool? darkMode;

  bool getTheme() {
    return darkMode ?? false;
  }

  setTheme(bool changeMode) async {
    darkMode = changeMode;
    notifyListeners();
  }
}
