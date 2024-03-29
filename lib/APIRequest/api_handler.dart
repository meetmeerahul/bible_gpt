import 'dart:convert';

import 'package:bible_gpt/class/book_details.dart';
import 'package:bible_gpt/class/languages_and_transilations.dart';

import 'package:http/http.dart' as http;

import '../chapterScreen/bookDetailScreen.dart';
import '../class/book_chapter.dart';
import '../config/app_config.dart';

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
    String url = "https://bolls.life/get-books/$shortName/";
    final response = await http.get(Uri.parse(url));

    List dataList = [];
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

  static Future<List<BookChapters>> getChaptersContents(
      String shortname, String bookid, String chapter) async {
    print(" book id======$bookid  shortname=$shortname chapter = $chapter");
    String url = "https://bolls.life/get-chapter/$shortname/$bookid/$chapter/";

    print(url);
    final response = await http.get(Uri.parse(url));

    List dataList = [];
    try {
      List decodedList = jsonDecode(response.body);
      for (var item in decodedList) {
        if (item is Map<String, dynamic>) {
          dataList.add(item);
        }
      }
    } catch (e) {
      print('Error decoding JSON data: $e');
    }

    return BookChapters.bookDataFromAPi(dataList);
  }

  static Future<Map<String, dynamic>> textToSpeechAPI(
      {required String getText, required String getLanguageCode}) async {
    Map<String, dynamic> getTextToSpeechResponse = {
      "status": false,
      "message": "",
      "audio": ""
    };
    String textToSpeechAPIUrl =
        "https://api.mybiblegpt.com/api/v1/user/text-to-speach/";
    print(textToSpeechAPIUrl);

    try {
      var getTextToSpeechAPIResponse = await http.post(
          Uri.parse(textToSpeechAPIUrl),
          body: {"text_input": getText, "language_code": getLanguageCode});
      print(getTextToSpeechAPIResponse.body);

      if (getTextToSpeechAPIResponse.statusCode >= 200 &&
          getTextToSpeechAPIResponse.statusCode < 300) {
        getTextToSpeechResponse["status"] = true;

        Map getResponseMap = jsonDecode(getTextToSpeechAPIResponse.body);

        print(getResponseMap);

        String getAudioText = getResponseMap["audio_content"] ?? "";

        getTextToSpeechResponse["audio"] = getAudioText;
      } else {
        getTextToSpeechResponse["status"] = false;
        Map getResponseMap = jsonDecode(getTextToSpeechAPIResponse.body);
        String getErrorMessage = getResponseMap["message"] ?? "";
        getTextToSpeechResponse["message"] = getErrorMessage;
      }
    } catch (e) {
      getTextToSpeechResponse["status"] = false;
      String getErrorMessage = "This voice is not available";
      getTextToSpeechResponse["message"] = getErrorMessage;
    }
    return getTextToSpeechResponse;
  }
}
