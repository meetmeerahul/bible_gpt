// import 'dart:convert';
// import 'dart:io';

// import 'package:http/http.dart' as http;
// import '../Class/ChapterDetailListClass.dart';
// import '../class/ChapterHomeListClass.dart';
// import '../class/ChapterTranslationListClass.dart';
// import '../config/app_config.dart';

// class AllAPIMethod {
//   Future<Map<String, dynamic>> searchGptAPI(
//       {required String getQuestion}) async {
//     /*Map<String, dynamic> getSearchGPTResponse = {"status":false,"message":"","result":""};
//     String searchGPTUrl = AppConfig().gptUrl+AppConfig().searchApiUrl;
//     print(searchGPTUrl);
//     try{
//       var getSearchGPTAPIResponse = await http.post(Uri.parse(searchGPTUrl),body: {"question":getQuestion});
//       print(getSearchGPTAPIResponse.body);
//       if(getSearchGPTAPIResponse.statusCode>=200 && getSearchGPTAPIResponse.statusCode<300){
//         getSearchGPTResponse["status"] = true;
//         Map getResponseMap = jsonDecode(getSearchGPTAPIResponse.body);
//         print(getResponseMap);
//         Map getDataMap = getResponseMap["data"]??{};
//         if(getDataMap.isNotEmpty){
//           String getAnswer = getDataMap["response_gpt"]??"";
//           getSearchGPTResponse["result"] = getAnswer;
//           print("Answer : ${getAnswer}");
//         }
//       }
//       else{
//         getSearchGPTResponse["status"] = false;
//         Map getResponseMap = jsonDecode(getSearchGPTAPIResponse.body);
//         String getErrorMessage = getResponseMap["message"]??"";
//         getSearchGPTResponse["message"] = getErrorMessage;
//       }
//     }
//     catch(e){
//       getSearchGPTResponse["status"] = false;
//       String getErrorMessage = e.toString()??"";
//       getSearchGPTResponse["message"] = getErrorMessage;
//     }
//     return getSearchGPTResponse;*/
//     Map<String, dynamic> getSearchGPTResponse = {
//       "status": false,
//       "message": "",
//       "data": {}
//     };
//     String searchGPTAPIUrl =
//         "https://api.mygitagpt.com/api/v1/gpt/campaign?prompt=$getQuestion";
//     print(searchGPTAPIUrl);
//     try {
//       /*var getSearchGPTAPIResponse = await http.post(Uri.parse(searchGPTAPIUrl),body: {"question": getSearchKeyword});
//       print(getSearchGPTAPIResponse.body);
//       if(getSearchGPTAPIResponse.statusCode>=200 && getSearchGPTAPIResponse.statusCode<300){
//         getSearchGPTResponse["status"] = true;
//         Map getResponseMap = jsonDecode(getSearchGPTAPIResponse.body);
//         print(getResponseMap);
//         Map getDataMap = getResponseMap.isNotEmpty?getResponseMap["data"]:{};
//         if(getDataMap.isNotEmpty){
//           String getAnswer = getDataMap["response_gpt"]??"";
//           getSearchGPTResponse["data"] = getAnswer;
//         }
//       }
//       else{
//         getSearchGPTResponse["status"] = false;
//         Map getResponseMap = jsonDecode(getSearchGPTAPIResponse.body);
//         String getErrorMessage = getResponseMap["message"]??"";
//         getSearchGPTResponse["message"] = getErrorMessage;
//       }*/
//       HttpClientRequest request =
//           await HttpClient().getUrl(Uri.parse(searchGPTAPIUrl));
//       HttpClientResponse response = await request.close();
//       if (response.statusCode >= 200 && response.statusCode < 300) {
//         getSearchGPTResponse["status"] = true;
//         getSearchGPTResponse["data"] = response;
//       } else {
//         getSearchGPTResponse["status"] = false;
//         String getErrorMessage = "Network response was not ok";
//         getSearchGPTResponse["message"] = getErrorMessage;
//       }
//     } catch (e) {
//       getSearchGPTResponse["status"] = false;
//       String getErrorMessage = e.toString() ?? "";
//       getSearchGPTResponse["message"] = getErrorMessage;
//     }
//     return getSearchGPTResponse;
//   }

//   Future<Map<String, dynamic>> getAllChapterDataAPI() async {
//     Map<String, dynamic> getChapterHomeResponse = {
//       "status": false,
//       "message": "",
//       "data": []
//     };
//     String chapterHomeAPIUrl =
//         AppConfig().baseUrl + AppConfig().homeChapterEndPoint;
//     print(chapterHomeAPIUrl);
//     try {
//       var getChapterHomeAPIResponse =
//           await http.get(Uri.parse(chapterHomeAPIUrl));
//       print(getChapterHomeAPIResponse.body);
//       if (getChapterHomeAPIResponse.statusCode == 200) {
//         getChapterHomeResponse["status"] = true;
//         Map getResponseMap = jsonDecode(getChapterHomeAPIResponse.body);
//         print(getResponseMap);
//         List getDataList = getResponseMap["data"] ?? [];
//         List<ChapterHomeListClass> getChapterHomeList = [];
//         for (int i = 0; i < getDataList.length; i++) {
//           Map getChapterMap = getDataList[i];
//           int getChapterId = getChapterMap["id"] ?? 0;
//           String getChapterName = getChapterMap["name"] ?? "";
//           int getChapterNumber = getChapterMap["chapter_number"] ?? 0;
//           String getChapterNameMeaning = getChapterMap["name_meaning"] ?? "";
//           int getSlockCount = getChapterMap["verses_count"] ?? 0;
//           getChapterHomeList.add(ChapterHomeListClass(
//               id: getChapterId,
//               chapterName: getChapterName,
//               chapterNumber: getChapterNumber,
//               chapterNameMeaning: getChapterNameMeaning,
//               slockCount: getSlockCount,
//               isSelected: false,
//               isRecentSelected: false));
//         }
//         getChapterHomeResponse["data"] = getChapterHomeList;
//       } else {
//         getChapterHomeResponse["status"] = false;
//         Map getResponseMap = jsonDecode(getChapterHomeAPIResponse.body);
//         String getErrorMessage = getResponseMap["message"] ?? "";
//         getChapterHomeResponse["message"] = getErrorMessage;
//       }
//     } catch (e) {
//       getChapterHomeResponse["status"] = false;
//       String getErrorMessage = e.toString() ?? "";
//       getChapterHomeResponse["message"] = getErrorMessage;
//     }
//     return getChapterHomeResponse;
//   }

//   Future<Map<String, dynamic>> getSummaryChapterAPI(
//       {required int chapterNumber}) async {
//     Map<String, dynamic> getChapterSummaryResponse = {
//       "status": false,
//       "message": "",
//       "chapter_name": "",
//       "summary_english": "",
//       "summary_hindi": ""
//     };
//     String chapterSummaryAPIUrl = AppConfig().baseUrl +
//         AppConfig().summaryChapterEndPoint +
//         "$chapterNumber/";
//     print(chapterSummaryAPIUrl);
//     try {
//       var getChapterSummaryAPIResponse =
//           await http.get(Uri.parse(chapterSummaryAPIUrl));
//       print(getChapterSummaryAPIResponse.body);
//       if (getChapterSummaryAPIResponse.statusCode == 200) {
//         getChapterSummaryResponse["status"] = true;
//         Map getResponseMap = jsonDecode(getChapterSummaryAPIResponse.body);
//         print(getResponseMap);
//         Map getDataMap = getResponseMap["data"] ?? {};
//         if (getDataMap.isNotEmpty) {
//           String getChapterName = getDataMap["name"] ?? "";
//           String getSummaryEnglish = getDataMap["chapter_summary"] ?? "";
//           String getSummaryHindi = getDataMap["chapter_summary_hindi"] ?? "";
//           getChapterSummaryResponse["chapter_name"] = getChapterName;
//           getChapterSummaryResponse["summary_english"] = getSummaryEnglish;
//           getChapterSummaryResponse["summary_hindi"] = getSummaryHindi;
//         }
//       } else {
//         getChapterSummaryResponse["status"] = false;
//         Map getResponseMap = jsonDecode(getChapterSummaryAPIResponse.body);
//         String getErrorMessage = getResponseMap["message"] ?? "";
//         getChapterSummaryResponse["message"] = getErrorMessage;
//       }
//     } catch (e) {
//       getChapterSummaryResponse["status"] = false;
//       String getErrorMessage = e.toString() ?? "";
//       getChapterSummaryResponse["message"] = getErrorMessage;
//     }
//     return getChapterSummaryResponse;
//   }

//   Future<Map<String, dynamic>> getPageChapterDetailAPI(
//       {required int chapterNumber}) async {
//     Map<String, dynamic> getChapterDetailResponse = {
//       "status": false,
//       "message": "",
//       "chapterListData": [],
//       "translatorListData": []
//     };
//     String chapterDetailAPIUrl = AppConfig().baseUrl +
//         AppConfig().summaryChapterEndPoint +
//         "$chapterNumber/${AppConfig().versesChapterEndPoint}";
//     print(chapterDetailAPIUrl);
//     try {
//       var getChapterDetailAPIResponse =
//           await http.get(Uri.parse(chapterDetailAPIUrl));
//       print(getChapterDetailAPIResponse.body);
//       if (getChapterDetailAPIResponse.statusCode >= 200) {
//         getChapterDetailResponse["status"] = true;
//         Map getResponseMap = jsonDecode(getChapterDetailAPIResponse.body);
//         print("language : $getResponseMap");
//         List<ChapterDetailListClass> getChapterList = [];
//         List<ChapterTranslationListClass> getTranslationResultList = [];
//         List getDataList = getResponseMap["data"] ?? [];
//         if (getDataList.isNotEmpty) {
//           Map getChapterDataMap = getDataList[0];
//           List getTranslationsList = getChapterDataMap["translations"] ?? [];
//           for (int a = 0; a < getTranslationsList.length; a++) {
//             Map getTranslationMap = getTranslationsList[a];
//             int getTranslationId = getTranslationMap["id"] ?? 0;
//             String getTranslationDescription =
//                 getTranslationMap["description"] ?? "";
//             String getTranslationAuthor =
//                 getTranslationMap["author_name"] ?? "";
//             String getTranslationLanguage = getTranslationMap["language"] ?? "";
//             getTranslationResultList.add(ChapterTranslationListClass(
//                 translationId: getTranslationId,
//                 translationDescription: getTranslationDescription,
//                 translationAuthor: getTranslationAuthor,
//                 translationLanguage: getTranslationLanguage.capitalize()));
//           }
//         }
//         for (int i = 0; i < getDataList.length; i++) {
//           Map getChapterDataMap = getDataList[i];
//           int getChapterId = getChapterDataMap["id"] ?? 0;
//           int getVerseNumber = getChapterDataMap["verse_number"] ?? 0;
//           String getChapterMeaning = getChapterDataMap["text"]
//                   .toString()
//                   .replaceAll("\n", "")
//                   .replaceAll(RegExp(r'[|।:0-9.]'), '') ??
//               "";
//           String getChapterTranslator = "";
//           List<ChapterTranslationListClass> translationList = [];
//           List getTranslationsList = getChapterDataMap["translations"] ?? [];
//           for (int a = 0; a < getTranslationsList.length; a++) {
//             Map getTranslationMap = getTranslationsList[a];
//             int getTranslationId = getTranslationMap["id"] ?? 0;
//             String getTranslationDescription = getTranslationMap["description"]
//                     .toString()
//                     .replaceAll("\n", "")
//                     .replaceAll(RegExp(r'[|।:0-9.]'), '') ??
//                 "";
//             String getTranslationAuthor =
//                 getTranslationMap["author_name"] ?? "";
//             String getTranslationLanguage = getTranslationMap["language"] ?? "";
//             translationList.add(ChapterTranslationListClass(
//                 translationId: getTranslationId,
//                 translationDescription: getTranslationDescription,
//                 translationAuthor: getTranslationAuthor,
//                 translationLanguage: getTranslationLanguage));
//           }
//           getChapterList.add(ChapterDetailListClass(
//               chapterId: getChapterId,
//               verseNumber: getVerseNumber,
//               chapterMeaningText: getChapterMeaning,
//               chapterTranslatorText: getChapterTranslator,
//               meaningPlaying: false,
//               translatePlaying: false,
//               translationListClass: translationList));
//         }
//         getChapterDetailResponse["chapterListData"] = getChapterList;
//         getChapterDetailResponse["translatorListData"] =
//             getTranslationResultList;
//       } else {
//         getChapterDetailResponse["status"] = false;
//         Map getResponseMap = jsonDecode(getChapterDetailAPIResponse.body);
//         String getErrorMessage = getResponseMap["message"] ?? "";
//         getChapterDetailResponse["message"] = getErrorMessage;
//       }
//     } catch (e) {
//       getChapterDetailResponse["status"] = false;
//       String getErrorMessage = e.toString() ?? "";
//       getChapterDetailResponse["message"] = getErrorMessage;
//     }
//     return getChapterDetailResponse;
//   }

//   Future<Map<String, dynamic>> textToSpeechAPI(
//       {required String getText, required String getLanguageCode}) async {
//     Map<String, dynamic> getTextToSpeechResponse = {
//       "status": false,
//       "message": "",
//       "audio": ""
//     };
//     String textToSpeechAPIUrl =
//         AppConfig().gptUrl + AppConfig().textToSpeechEndPoint;
//     print(textToSpeechAPIUrl);
//     try {
//       var getTextToSpeechAPIResponse = await http.post(
//           Uri.parse(textToSpeechAPIUrl),
//           body: {"text_input": getText, "language_code": getLanguageCode});
//       print(getTextToSpeechAPIResponse.body);
//       if (getTextToSpeechAPIResponse.statusCode >= 200 &&
//           getTextToSpeechAPIResponse.statusCode < 300) {
//         getTextToSpeechResponse["status"] = true;
//         Map getResponseMap = jsonDecode(getTextToSpeechAPIResponse.body);
//         print(getResponseMap);
//         String getAudioText = getResponseMap["audio_content"] ?? "";
//         getTextToSpeechResponse["audio"] = getAudioText;
//       } else {
//         getTextToSpeechResponse["status"] = false;
//         Map getResponseMap = jsonDecode(getTextToSpeechAPIResponse.body);
//         String getErrorMessage = getResponseMap["message"] ?? "";
//         getTextToSpeechResponse["message"] = getErrorMessage;
//       }
//     } catch (e) {
//       getTextToSpeechResponse["status"] = false;
//       String getErrorMessage = "This voice is not available";
//       getTextToSpeechResponse["message"] = getErrorMessage;
//     }
//     return getTextToSpeechResponse;
//   }

//   Future<Map<String, dynamic>> registerAPI(
//       {required String getFirstName,
//       required String getLastName,
//       required String getUserName,
//       required String getPassword}) async {
//     Map<String, dynamic> registerResponse = {
//       "status": false,
//       "message": "",
//       "token": "",
//       "user": {}
//     };
//     String registerAPIUrl =
//         AppConfig().gptUrl + AppConfig().registerAPIEndPoint;
//     print(registerAPIUrl);
//     try {
//       var registerAPIResponse =
//           await http.post(Uri.parse(registerAPIUrl), body: {
//         "first_name": getFirstName,
//         "last_name": getLastName,
//         "username": getUserName,
//         "password": getPassword
//       });
//       print(registerAPIResponse.body);
//       if (registerAPIResponse.statusCode >= 200 &&
//           registerAPIResponse.statusCode < 300 &&
//           registerAPIResponse.statusCode != 203) {
//         registerResponse["status"] = true;
//         Map getResponseMap = jsonDecode(registerAPIResponse.body);
//         print(getResponseMap);
//         Map getDataMap = getResponseMap["data"] ?? {};
//         String getResponseMessage = getResponseMap["message"] ?? "";
//         registerResponse["message"] = getResponseMessage;
//         if (getDataMap.isNotEmpty) {
//           String getToken = getDataMap["token"] ?? "";
//           registerResponse["token"] = getToken;
//           Map<String, dynamic> getUserMap = getDataMap["user"] ?? {};
//           registerResponse["user"] = getUserMap;
//           print("Token : $getToken");
//           print("User : $getUserMap");
//         }
//       } else {
//         registerResponse["status"] = false;
//         Map getResponseMap = jsonDecode(registerAPIResponse.body);
//         String getErrorMessage = getResponseMap["message"] ?? "";
//         registerResponse["message"] = getErrorMessage;
//       }
//     } catch (e) {
//       registerResponse["status"] = false;
//       String getErrorMessage = e.toString() ?? "";
//       registerResponse["message"] = getErrorMessage;
//     }
//     return registerResponse;
//   }

//   Future<Map<String, dynamic>> logInAPI(
//       {required String getUserName, required String getPassword}) async {
//     Map<String, dynamic> logInResponse = {
//       "status": false,
//       "message": "",
//       "token": "",
//       "user": {}
//     };
//     String logInAPIUrl = AppConfig().gptUrl + AppConfig().logInAPIEndPoint;
//     print(logInAPIUrl);
//     try {
//       var logInAPIResponse = await http.post(Uri.parse(logInAPIUrl),
//           body: {"username": getUserName, "password": getPassword});
//       print(logInAPIResponse.body);
//       if (logInAPIResponse.statusCode >= 200 &&
//           logInAPIResponse.statusCode < 300 &&
//           logInAPIResponse.statusCode != 203) {
//         logInResponse["status"] = true;
//         Map getResponseMap = jsonDecode(logInAPIResponse.body);
//         print(getResponseMap);
//         Map getDataMap = getResponseMap["data"] ?? {};
//         String getResponseMessage = getResponseMap["message"] ?? "";
//         logInResponse["message"] = getResponseMessage;
//         if (getDataMap.isNotEmpty) {
//           String getToken = getDataMap["token"] ?? "";
//           logInResponse["token"] = getToken;
//           Map<String, dynamic> getUserMap = getDataMap["user"] ?? {};
//           logInResponse["user"] = getUserMap;
//           print("Token : $getToken");
//           print("User : $getUserMap");
//         }
//       } else {
//         logInResponse["status"] = false;
//         Map getResponseMap = jsonDecode(logInAPIResponse.body);
//         String getErrorMessage = getResponseMap["message"] ?? "";
//         logInResponse["message"] = getErrorMessage;
//       }
//     } catch (e) {
//       logInResponse["status"] = false;
//       String getErrorMessage = e.toString() ?? "";
//       logInResponse["message"] = getErrorMessage;
//     }
//     return logInResponse;
//   }

//   Future<Map<String, dynamic>> socialMediaAPI(
//       {required String getFullName,
//       required String getSocialMediaType,
//       required String getSocialId,
//       required String getMailId,
//       required String getImageUrl}) async {
//     Map<String, dynamic> socialMediaResponse = {
//       "status": false,
//       "message": "",
//       "token": "",
//       "user": {}
//     };
//     String socialMediaAPIUrl =
//         AppConfig().gptUrl + AppConfig().socialMediaAPIEndPoint;
//     print(socialMediaAPIUrl);
//     try {
//       var socialMediaAPIResponse =
//           await http.post(Uri.parse(socialMediaAPIUrl), body: {
//         "full_name": getFullName,
//         "social_platform": getSocialMediaType,
//         "social_operator_id": getSocialId,
//         "email": getMailId,
//         "avatar": getImageUrl
//       });
//       print(socialMediaAPIResponse.body);
//       if (socialMediaAPIResponse.statusCode >= 200 &&
//           socialMediaAPIResponse.statusCode < 300 &&
//           socialMediaAPIResponse.statusCode != 203) {
//         socialMediaResponse["status"] = true;
//         Map getResponseMap = jsonDecode(socialMediaAPIResponse.body);
//         print(getResponseMap);
//         Map getDataMap = getResponseMap["data"] ?? {};
//         String getResponseMessage = getResponseMap["message"] ?? "";
//         socialMediaResponse["message"] = getResponseMessage;
//         if (getDataMap.isNotEmpty) {
//           String getToken = getDataMap["token"] ?? "";
//           socialMediaResponse["token"] = getToken;
//           Map<String, dynamic> getUserMap = getDataMap["user"] ?? {};
//           socialMediaResponse["user"] = getUserMap;
//           print("Token : $getToken");
//           print("User : $getUserMap");
//         }
//       } else {
//         socialMediaResponse["status"] = false;
//         Map getResponseMap = jsonDecode(socialMediaAPIResponse.body);
//         String getErrorMessage = getResponseMap["message"] ?? "";
//         socialMediaResponse["message"] = getErrorMessage;
//       }
//     } catch (e) {
//       socialMediaResponse["status"] = false;
//       String getErrorMessage = e.toString() ?? "";
//       socialMediaResponse["message"] = getErrorMessage;
//     }
//     return socialMediaResponse;
//   }

//   Future<Map<String, dynamic>> socialMediaLogInAPI(
//       {required String getSocialMediaType, required String getSocialId}) async {
//     Map<String, dynamic> socialLogInMediaResponse = {
//       "status": false,
//       "message": "",
//       "token": "",
//       "user": {}
//     };
//     String socialMediaLogInAPIUrl =
//         AppConfig().gptUrl + AppConfig().socialMediaLogInAPIEndPoint;
//     print(socialMediaLogInAPIUrl);
//     try {
//       var socialMediaLogInAPIResponse =
//           await http.post(Uri.parse(socialMediaLogInAPIUrl), body: {
//         "social_platform": getSocialMediaType,
//         "social_operator_id": getSocialId,
//       });
//       print(socialMediaLogInAPIResponse.body);
//       if (socialMediaLogInAPIResponse.statusCode >= 200 &&
//           socialMediaLogInAPIResponse.statusCode < 300 &&
//           socialMediaLogInAPIResponse.statusCode != 203) {
//         socialLogInMediaResponse["status"] = true;
//         Map getResponseMap = jsonDecode(socialMediaLogInAPIResponse.body);
//         print(getResponseMap);
//         Map getDataMap = getResponseMap["data"] ?? {};
//         String getResponseMessage = getResponseMap["message"] ?? "";
//         socialLogInMediaResponse["message"] = getResponseMessage;
//         if (getDataMap.isNotEmpty) {
//           String getToken = getDataMap["token"] ?? "";
//           socialLogInMediaResponse["token"] = getToken;
//           Map<String, dynamic> getUserMap = getDataMap["user"] ?? {};
//           socialLogInMediaResponse["user"] = getUserMap;
//           print("Token : $getToken");
//           print("User : $getUserMap");
//         }
//       } else {
//         socialLogInMediaResponse["status"] = false;
//         Map getResponseMap = jsonDecode(socialMediaLogInAPIResponse.body);
//         String getErrorMessage = getResponseMap["message"] ?? "";
//         socialLogInMediaResponse["message"] = getErrorMessage;
//       }
//     } catch (e) {
//       socialLogInMediaResponse["status"] = false;
//       String getErrorMessage = e.toString() ?? "";
//       socialLogInMediaResponse["message"] = getErrorMessage;
//     }
//     return socialLogInMediaResponse;
//   }

//   Future<Map<String, dynamic>> deleteAccountAPI(
//       {required String getToken}) async {
//     Map<String, dynamic> deleteAccountResponse = {
//       "status": false,
//       "message": ""
//     };
//     String deleteAccountAPIUrl =
//         AppConfig().gptUrl + AppConfig().deleteAccountAPIEndPoint;
//     print(deleteAccountAPIUrl);
//     try {
//       var deleteAccountAPIResponse = await http.delete(
//           Uri.parse(deleteAccountAPIUrl),
//           headers: {'Authorization': 'Bearer $getToken'});
//       /*var deleteAPIResponse = http.Request('DELETE', Uri.parse(deleteAccountAPIUrl));
//       var headers= {'Authorization': 'Bearer ${getToken}'};
//       deleteAPIResponse.headers.addAll(headers);
//       http.StreamedResponse response = await deleteAPIResponse.send();*/
//       print(deleteAccountAPIResponse.body);
//       if (deleteAccountAPIResponse.statusCode >= 200 &&
//           deleteAccountAPIResponse.statusCode < 300) {
//         deleteAccountResponse["status"] = true;
//         Map getResponseMap = jsonDecode(deleteAccountAPIResponse.body);
//         print(getResponseMap);
//         String getResponseMessage = getResponseMap["message"] ?? "";
//         deleteAccountResponse["message"] = getResponseMessage;
//       } else {
//         deleteAccountResponse["status"] = false;
//         Map getResponseMap = jsonDecode(deleteAccountAPIResponse.body);
//         String getErrorMessage = getResponseMap["message"] ?? "";
//         deleteAccountResponse["message"] = getErrorMessage;
//       }
//     } catch (e) {
//       deleteAccountResponse["status"] = false;
//       String getErrorMessage = e.toString() ?? "";
//       deleteAccountResponse["message"] = getErrorMessage;
//     }
//     return deleteAccountResponse;
//   }

//   Future<Map<String, dynamic>> getForgetPasswordAPI(
//       {required String getMailId}) async {
//     Map<String, dynamic> forgetPasswordResponse = {
//       "status": false,
//       "message": ""
//     };
//     String forgetPasswordAPIUrl =
//         AppConfig().baseUrl + AppConfig().forgetPasswordEndPoint;
//     print(forgetPasswordAPIUrl);
//     try {
//       var forgetPasswordAPIResponse = await http
//           .post(Uri.parse(forgetPasswordAPIUrl), body: {"email": getMailId});
//       print(forgetPasswordAPIResponse.body);
//       if (forgetPasswordAPIResponse.statusCode >= 200 &&
//           forgetPasswordAPIResponse.statusCode < 300 &&
//           forgetPasswordAPIResponse.statusCode != 203) {
//         forgetPasswordResponse["status"] = true;
//         Map getResponseMap = jsonDecode(forgetPasswordAPIResponse.body);
//         print(getResponseMap);
//         String getResponseMessage = getResponseMap["message"] ?? "";
//         forgetPasswordResponse["message"] = getResponseMessage;
//       } else {
//         forgetPasswordResponse["status"] = false;
//         Map getResponseMap = jsonDecode(forgetPasswordAPIResponse.body);
//         String getErrorMessage = getResponseMap["message"] ?? "";
//         forgetPasswordResponse["message"] = getErrorMessage;
//       }
//     } catch (e) {
//       forgetPasswordResponse["status"] = false;
//       String getErrorMessage = e.toString() ?? "";
//       forgetPasswordResponse["message"] = getErrorMessage;
//     }
//     return forgetPasswordResponse;
//   }
// }

// extension StringExtension on String {
//   String capitalize() {
//     return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
//   }
// }
