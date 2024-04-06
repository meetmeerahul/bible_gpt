import 'dart:convert';
import 'dart:io';

import 'package:bible_gpt/class/book_details.dart';
import 'package:bible_gpt/class/languages_and_transilations.dart';

import 'package:http/http.dart' as http;

import '../chapterScreen/bookDetailScreen.dart';
import '../class/book_chapter.dart';
import '../config/app_config.dart';

class ApiHandler {
  static Future<List<LanguagesAndTransilations>> getLanguages() async {
    List tempList = [];

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Basic Og=='
    };
    var request = http.Request('GET',
        Uri.parse('https://bolls.life/static/bolls/app/views/languages.json'));
    request.body = '''{"query":"","variables":{}}''';

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var resposeResult = await response.stream.bytesToString();
      print(" responseResult : $resposeResult");
      var resposeMap = json.decode(resposeResult);

      for (var v in resposeMap) {
        print("Language result : $v");
        tempList.add(v);
      }
    } else {
      print(response.reasonPhrase);
    }

    return LanguagesAndTransilations.languagesFromAPi(tempList);
  }

  static Future<List<BookDetails>> getBookDetails(
      {required String shortName}) async {
    var url = "https://bolls.life/get-books/$shortName/";

    print(url);

    final response = await http.get(
      Uri.parse(url),
      headers: {'Accept-Charset': 'utf-8'},
    );
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
    print("Book detail api call");
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

  Future<Map<String, dynamic>> searchGptAPI(
      {required String getQuestion}) async {
    Map<String, dynamic> getSearchGPTResponse = {
      "status": false,
      "message": "",
      "data": {}
    };
    String searchGPTAPIUrl =
        "http://api.mybiblegpt.com/api/v1/gpt/campaign?prompt={{$getQuestion}}";
    print(searchGPTAPIUrl);
    try {
      HttpClientRequest request =
          await HttpClient().getUrl(Uri.parse(searchGPTAPIUrl));
      HttpClientResponse response = await request.close();
      if (response.statusCode >= 200 && response.statusCode < 300) {
        getSearchGPTResponse["status"] = true;
        getSearchGPTResponse["data"] = response;
      } else {
        getSearchGPTResponse["status"] = false;
        String getErrorMessage = "Network response was not ok";
        getSearchGPTResponse["message"] = getErrorMessage;
      }
    } catch (e) {
      getSearchGPTResponse["status"] = false;
      String getErrorMessage = e.toString() ?? "";
      getSearchGPTResponse["message"] = getErrorMessage;
    }
    return getSearchGPTResponse;
  }

  Future<Map<String, dynamic>> registerAPI(
      {required String getFirstName,
      required String getLastName,
      required String getUserName,
      required String getPassword}) async {
    Map<String, dynamic> registerResponse = {
      "status": false,
      "message": "",
      "token": "",
      "user": {}
    };
    String registerAPIUrl = "https://api.qurangpt.com/api/v1/user/register/";

    try {
      var registerAPIResponse =
          await http.post(Uri.parse(registerAPIUrl), body: {
        "first_name": getFirstName,
        "last_name": getLastName,
        "username": getUserName,
        "password": getPassword
      });
      print(registerAPIResponse.body);
      if (registerAPIResponse.statusCode >= 200 &&
          registerAPIResponse.statusCode < 300 &&
          registerAPIResponse.statusCode != 203) {
        registerResponse["status"] = true;
        Map getResponseMap = jsonDecode(registerAPIResponse.body);
        print(getResponseMap);
        Map getDataMap = getResponseMap["data"] ?? {};
        String getResponseMessage = getResponseMap["message"] ?? "";
        registerResponse["message"] = getResponseMessage;
        if (getDataMap.isNotEmpty) {
          String getToken = getDataMap["token"] ?? "";
          registerResponse["token"] = getToken;
          Map<String, dynamic> getUserMap = getDataMap["user"] ?? {};
          registerResponse["user"] = getUserMap;
          print("Token : $getToken");
          print("User : $getUserMap");
        }
      } else {
        registerResponse["status"] = false;
        Map getResponseMap = jsonDecode(registerAPIResponse.body);
        String getErrorMessage = getResponseMap["message"] ?? "";
        registerResponse["message"] = getErrorMessage;
      }
    } catch (e) {
      registerResponse["status"] = false;
      String getErrorMessage = e.toString() ?? "";
      registerResponse["message"] = getErrorMessage;
    }
    return registerResponse;
  }

  Future<Map<String, dynamic>> logInAPI(
      {required String getUserName, required String getPassword}) async {
    Map<String, dynamic> logInResponse = {
      "status": false,
      "message": "",
      "token": "",
      "user": {}
    };
    String logInAPIUrl = "https://api.qurangpt.com/api/v1/user/login/";
    print(logInAPIUrl);
    try {
      var logInAPIResponse = await http.post(Uri.parse(logInAPIUrl),
          body: {"username": getUserName, "password": getPassword});
      print(logInAPIResponse.body);
      if (logInAPIResponse.statusCode >= 200 &&
          logInAPIResponse.statusCode < 300 &&
          logInAPIResponse.statusCode != 203) {
        logInResponse["status"] = true;
        Map getResponseMap = jsonDecode(logInAPIResponse.body);
        print(getResponseMap);
        Map getDataMap = getResponseMap["data"] ?? {};
        String getResponseMessage = getResponseMap["message"] ?? "";
        logInResponse["message"] = getResponseMessage;
        if (getDataMap.isNotEmpty) {
          String getToken = getDataMap["token"] ?? "";
          logInResponse["token"] = getToken;
          Map<String, dynamic> getUserMap = getDataMap["user"] ?? {};
          logInResponse["user"] = getUserMap;
          print("Token : $getToken");
          print("User : $getUserMap");
        }
      } else {
        logInResponse["status"] = false;
        Map getResponseMap = jsonDecode(logInAPIResponse.body);
        String getErrorMessage = getResponseMap["message"] ?? "";
        logInResponse["message"] = getErrorMessage;
      }
    } catch (e) {
      logInResponse["status"] = false;
      String getErrorMessage = e.toString() ?? "";
      logInResponse["message"] = getErrorMessage;
    }
    return logInResponse;
  }

  Future<Map<String, dynamic>> socialMediaAPI(
      {required String getFullName,
      required String getSocialMediaType,
      required String getSocialId,
      required String getMailId,
      required String getImageUrl}) async {
    Map<String, dynamic> socialMediaResponse = {
      "status": false,
      "message": "",
      "token": "",
      "user": {}
    };
    String socialMediaAPIUrl =
        "https://api.qurangpt.com/api/v1/user/continue-with-social/";
    print(socialMediaAPIUrl);
    try {
      var socialMediaAPIResponse =
          await http.post(Uri.parse(socialMediaAPIUrl), body: {
        "full_name": getFullName,
        "social_platform": getSocialMediaType,
        "social_operator_id": getSocialId,
        "email": getMailId,
        "avatar": getImageUrl
      });
      print(socialMediaAPIResponse.body);
      if (socialMediaAPIResponse.statusCode >= 200 &&
          socialMediaAPIResponse.statusCode < 300 &&
          socialMediaAPIResponse.statusCode != 203) {
        socialMediaResponse["status"] = true;
        Map getResponseMap = jsonDecode(socialMediaAPIResponse.body);
        print(getResponseMap);
        Map getDataMap = getResponseMap["data"] ?? {};
        String getResponseMessage = getResponseMap["message"] ?? "";
        socialMediaResponse["message"] = getResponseMessage;
        if (getDataMap.isNotEmpty) {
          String getToken = getDataMap["token"] ?? "";
          socialMediaResponse["token"] = getToken;
          Map<String, dynamic> getUserMap = getDataMap["user"] ?? {};
          socialMediaResponse["user"] = getUserMap;
          print("Token : $getToken");
          print("User : $getUserMap");
        }
      } else {
        socialMediaResponse["status"] = false;
        Map getResponseMap = jsonDecode(socialMediaAPIResponse.body);
        String getErrorMessage = getResponseMap["message"] ?? "";
        socialMediaResponse["message"] = getErrorMessage;
      }
    } catch (e) {
      socialMediaResponse["status"] = false;
      String getErrorMessage = e.toString() ?? "";
      socialMediaResponse["message"] = getErrorMessage;
    }
    return socialMediaResponse;
  }

  Future<Map<String, dynamic>> socialMediaLogInAPI(
      {required String getSocialMediaType, required String getSocialId}) async {
    Map<String, dynamic> socialLogInMediaResponse = {
      "status": false,
      "message": "",
      "token": "",
      "user": {}
    };
    String socialMediaLogInAPIUrl =
        "https://api.qurangpt.com/api/v1/user/login-with-social/";
    print(socialMediaLogInAPIUrl);
    try {
      var socialMediaLogInAPIResponse =
          await http.post(Uri.parse(socialMediaLogInAPIUrl), body: {
        "social_platform": getSocialMediaType,
        "social_operator_id": getSocialId,
      });
      print(socialMediaLogInAPIResponse.body);
      if (socialMediaLogInAPIResponse.statusCode >= 200 &&
          socialMediaLogInAPIResponse.statusCode < 300 &&
          socialMediaLogInAPIResponse.statusCode != 203) {
        socialLogInMediaResponse["status"] = true;
        Map getResponseMap = jsonDecode(socialMediaLogInAPIResponse.body);
        print(getResponseMap);
        Map getDataMap = getResponseMap["data"] ?? {};
        String getResponseMessage = getResponseMap["message"] ?? "";
        socialLogInMediaResponse["message"] = getResponseMessage;
        if (getDataMap.isNotEmpty) {
          String getToken = getDataMap["token"] ?? "";
          socialLogInMediaResponse["token"] = getToken;
          Map<String, dynamic> getUserMap = getDataMap["user"] ?? {};
          socialLogInMediaResponse["user"] = getUserMap;
          print("Token : $getToken");
          print("User : $getUserMap");
        }
      } else {
        socialLogInMediaResponse["status"] = false;
        Map getResponseMap = jsonDecode(socialMediaLogInAPIResponse.body);
        String getErrorMessage = getResponseMap["message"] ?? "";
        socialLogInMediaResponse["message"] = getErrorMessage;
      }
    } catch (e) {
      socialLogInMediaResponse["status"] = false;
      String getErrorMessage = e.toString() ?? "";
      socialLogInMediaResponse["message"] = getErrorMessage;
    }
    return socialLogInMediaResponse;
  }
}
