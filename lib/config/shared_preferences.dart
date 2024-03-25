import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPreference {
  SharedPreference._privateConstructor();

  static final SharedPreference instance =
      SharedPreference._privateConstructor();

  setOnDarkMode(String key, bool value) async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    myPrefs.setBool(key, value);
  }

  Future<bool> getOnDarkMode(String key) async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    return myPrefs.getBool(key) ?? false;
  }

  setSelectedLanguage(String key, String selectedLanguageCode) async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    myPrefs.setString(key, selectedLanguageCode);
  }

  Future<String> getSelectedLanguage(String key) async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    return myPrefs.getString(key) ?? "en";
  }

  setUserToken(String key, String token) async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    myPrefs.setString(key, token);
  }

  Future<String> getUserToken(String key) async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    return myPrefs.getString(key) ?? "";
  }

  setUserProfileDetail(
      String key, Map<String, dynamic> profileDetailMap) async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    String profileDetail = json.encode(profileDetailMap);
    myPrefs.setString(key, profileDetail);
  }

  Future<Map<String, dynamic>> getUserProfileDetail(String key) async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    String? getProfileDetail = myPrefs.getString(key);
    Map<String, dynamic> getProfileMap = {};
    if (getProfileDetail != null) {
      getProfileMap = json.decode(getProfileDetail);
    }
    return getProfileMap;
  }

  Future<void> setRecentChapter(
      String key, Map<String, dynamic> recentChapterMap) async {
    // print("******************Set recent called++++++++++++++");
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    String recentChapter = json.encode(recentChapterMap);
    await myPrefs.setString(key, recentChapter);
  }

  Future<Map<String, dynamic>> getRecentChapter(String key) async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    String? getRecentChapterString = myPrefs.getString(key);
    Map<String, dynamic> getRecentChapterMap = {};
    // print("getRecent chapter : $getRecentChapterString");
    if (getRecentChapterString != null && getRecentChapterString.length > 2) {
      getRecentChapterMap = json.decode(getRecentChapterString);
    }
    print(getRecentChapterMap);
    return getRecentChapterMap;
  }
}
