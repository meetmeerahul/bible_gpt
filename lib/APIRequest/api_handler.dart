import 'dart:convert';

import 'package:bible_gpt/class/languages_and_transilations.dart';

import 'package:http/http.dart' as http;

class ApiHandler {
  static Future<List<LanguagesAndTransilations>> getLanguages() async {
    const url = "https://bolls.life/static/bolls/app/views/languages.json";

    final response = await http.get(Uri.parse(url));
    List tempList = [];
    if (response.statusCode == 200) {
      for (var v in jsonDecode(response.body)) {
        tempList.add(v);
      }
    }

    return LanguagesAndTransilations.languagesFromAPi(tempList);
  }
}
