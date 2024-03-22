import 'dart:convert';

import 'package:bible_gpt/class/book_details.dart';
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

  static Future<List<BookDetails>> getBookDetails(
      {required String shortName}) async {
    var url = "https://bolls.life/get-books/$shortName/";

    print(url);

    final response = await http.get(Uri.parse(url));
    List tempList = [];
    if (response.statusCode == 200) {
      for (var v in jsonDecode(response.body)) {
        tempList.add(v);
      }
    }

    return BookDetails.bookDetailsFromApi(tempList);
  }

  static getChaptersInBooks(String shortName) async {
    Map<String, dynamic> getChapterHomeResponse = {"data": []};

    String url = "https://bolls.life/get-books/$shortName/";
    final response = await http.get(Uri.parse(url));

    var dataList = [];
    try {
      List<dynamic> decodedList = jsonDecode(response.body);
      for (var item in decodedList) {
        if (item is Map<String, dynamic>) {
          dataList.add(item);
        }
      }
    } catch (e) {
      print('Error decoding JSON data: $e');
    }

    return dataList;
  }
}
