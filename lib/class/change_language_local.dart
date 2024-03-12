import 'package:flutter/cupertino.dart';

class ChangeLanguageLocal with ChangeNotifier {
  String? selectedLanguageCode;

  String getLanguage() {
    return selectedLanguageCode ?? "en";
  }

  setLanguage(String changeLanguageCode) async {
    selectedLanguageCode = changeLanguageCode;
    notifyListeners();
  }
}
