import 'dart:async';
import 'dart:convert';

import 'package:bible_gpt/APIRequest/api_handler.dart';
import 'package:bible_gpt/chapterScreen/bookDetailScreen.dart';
import 'package:bible_gpt/config/changable.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Class/ChapterHomeAllListClass.dart';
import '../Class/ChapterHomeListClass.dart';
import '../class/theme_method.dart';
import '../config/app_config.dart';
import '../config/language_text_file.dart';
import '../config/shared_preferences.dart';
import '../dashBoardScreen/noInternetScreen.dart';
import '../loader/screen/ChapterLoaderScreen.dart';
import '../widgets/AllChapterListviewWidget.dart';
import '../widgets/RecentChapterListviewWidget.dart';
import '../widgets/check_internet_method.dart';
import '../widgets/toast_message.dart';
import 'categoryDetailScreen.dart';

class chapterScreen extends StatefulWidget {
  final BuildContext context;

  //final bool darkMode;
  const chapterScreen({
    super.key,
    required this.context,
  });

  @override
  State<StatefulWidget> createState() {
    return chapterPage(context: context);
  }
}

class chapterPage extends State<chapterScreen> {
  @override
  final BuildContext context;

  //final bool darkMode;
  chapterPage({
    Key? key,
    required this.context,
  });

  double screenWidth = 0;
  double screenHeight = 0;
  double scaleFactor = 0;
  //List<int> getPreviousRecentChapterList = [];
  List<ChapterHomeListClass> recentChapterList = [];
  List<ChapterHomeAllListClass> allChapterList = [];
  //late ChangeThemeLocal theme;
  late bool darkMode;
  //late ChangeLanguageLocal languageLocal;
  //late int getLanguageType;
  late String getLanguageCode = "en";
  String recentChapter = "";
  String clearAll = "";
  String chapterAll = "";
  bool isAPILoading = false;
  bool oldTestNew = false;
  bool newTestNew = false;

  navigateToNoInternetScreen(String? getId, String chapterCount, String name) {
    Navigator.push(context,
            MaterialPageRoute(builder: (context) => const NoInternetScreen()))
        .then((value) {
      if (value) {
        if (getId != null) {
          navigateToCategoryDetailScreen(getId, chapterCount, name);
        }
      }
    });
  }

  navigateToCategoryDetailScreen(
      String getId, String chaptersCOunt, String chapterName) async {
    bool checkInternet = await CheckInternetConnectionMethod();

    print(getId);
    if (checkInternet) {
      // ignore: use_build_context_synchronously
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  // categoryDetailScreen(
                  //   screenType: 0,
                  //   getValue: getId,
                  //   languageCode: null,
                  // ),
                  BookDetailScreen(
                    bookid: getId,
                    chapterCOunt: chaptersCOunt,
                    chapterName: chapterName,
                  ))).then((value) {
        setState(() {});
      });
    } else {
      navigateToNoInternetScreen(getId, chaptersCOunt, chapterName);
    }
  }

  Future<void> getSharedPreferenceData(ChapterHomeListClass getResult) async {
    print("Setting recent data^^^^^^^^^^^^^**********");
    Map<String, dynamic> getChapterPreference =
        await SharedPreference.instance.getRecentChapter("chapter");
    if (getChapterPreference.isNotEmpty) {
      List<dynamic> getChapterRecentList =
          List<dynamic>.from(getChapterPreference["data"]) ?? [];
      bool itemAlreadyAdded = false;
      for (int a = 0; a < getChapterRecentList.length; a++) {
        Map<String, dynamic> getChapterItem =
            Map<String, dynamic>.from(getChapterRecentList[a]);
        if (getChapterItem["bookid"] == getResult.bookid) {
          itemAlreadyAdded = true;
          getChapterRecentList.remove(getChapterItem);
          getChapterRecentList.insert(0, getResult.toJson());
        }
      }
      if (!itemAlreadyAdded) {
        getChapterRecentList.insert(0, getResult.toJson());
      }
      Map<String, dynamic> updatedRecentChapterResponse = {
        "data": getChapterRecentList,
      };
      await SharedPreference.instance
          .setRecentChapter("chapter", updatedRecentChapterResponse);
      recentData();
    } else {
      List<Map<String, dynamic>> getChapterRecentList = [];
      Map<String, dynamic> getChapterItem = getResult.toJson();
      getChapterRecentList.insert(0, getChapterItem);
      Map<String, dynamic> updatedRecentChapterResponse = {
        "data": getChapterRecentList,
      };
      await SharedPreference.instance
          .setRecentChapter("chapter", updatedRecentChapterResponse);
      recentData();
    }
  }

  Future<void> recentData() async {
    recentChapterList.clear();
    Map<String, dynamic> getChapterPreference =
        await SharedPreference.instance.getRecentChapter("chapter");
    print(getChapterPreference);
    if (getChapterPreference.isNotEmpty) {
      List<dynamic> getChapterList =
          List<dynamic>.from(getChapterPreference["data"]) ?? [];
      for (int i = 0; i < getChapterList.length; i++) {
        Map<String, dynamic> getRecentItem =
            Map<String, dynamic>.from(getChapterList[i]);
        ChapterHomeListClass getChapterHomeItem =
            ChapterHomeListClass.fromJson(getRecentItem);
        setState(() {
          recentChapterList.add(getChapterHomeItem);
        });
      }
    }
  }

  callChapterAPI() async {
    setState(() {
      isAPILoading = true;
    });

    bool internetConnectCheck = await CheckInternetConnectionMethod();
    if (internetConnectCheck) {
      var getHomeChapterAPIResponse =
          await ApiHandler.getChaptersInBooks(changableShortName);

      // print(getHomeChapterAPIResponse);

      if (getHomeChapterAPIResponse.isNotEmpty) {
        setState(() {
          allChapterList.clear();

          List<ChapterHomeListClass> getResponseData = [];

          for (var item in getHomeChapterAPIResponse) {
            // Convert each map in the response to a ChapterHomeListClass object
            getResponseData.add(ChapterHomeListClass.fromJson(item));
          }

          List<ChapterHomeListClass> getChapterHomeList = [];

          if (oldTestNew == false && newTestNew == false) {
            for (int i = 0; i < getResponseData.length; i++) {
              getChapterHomeList.add(getResponseData[i]);
              if ((i == (getResponseData.length - 1)) || ((i + 1) % 3 == 0)) {
                allChapterList.add(ChapterHomeAllListClass(
                    getAllChapterList: List.from(getChapterHomeList)));
                getChapterHomeList.clear();
              }
            }
          } else if (oldTestNew == true && newTestNew == false) {
            for (int i = 39; i < getResponseData.length; i++) {
              getChapterHomeList.add(getResponseData[i]);
              if ((i == (getResponseData.length - 1)) || ((i + 1) % 3 == 0)) {
                allChapterList.add(ChapterHomeAllListClass(
                    getAllChapterList: List.from(getChapterHomeList)));
                getChapterHomeList.clear();
              }
            }
          } else if (oldTestNew == false && newTestNew == true) {
            int count = 0;
            for (int i = 0; i <= 38; i++) {
              count++;
              getChapterHomeList.add(getResponseData[i]);
              if ((i == (getResponseData.length - 1)) || ((i + 1) % 3 == 0)) {
                allChapterList.add(ChapterHomeAllListClass(
                    getAllChapterList: List.from(getChapterHomeList)));
                getChapterHomeList.clear();
              }
            }

            if (count == 0) {}
            count = 0;
          }
        });
      } else {
        ToastMessage(screenHeight, "Error", false);
      }
    } else {
      navigateToNoInternetScreen(null, "", "");
    }

    setState(() {
      isAPILoading = false;
    });

    recentData();
  }

  /*localData(){
    allChapterList.clear();
    setState(() {
      for(int i = 0 ; i < 10 ; i++){
        List<ChapterHomeListClass> getChapterHomeAllListClass = [];
        for (int j = 0 ; j < 3 ; j++){
          int getValue = (i*3)+(j+1);
          ChapterHomeListClass getChapterItem = ChapterHomeListClass(id: getValue, isSelected: false, isRecentSelected: false);
          getChapterHomeAllListClass.add(getChapterItem);
        }
        allChapterList.add(ChapterHomeAllListClass(getAllChapterList: getChapterHomeAllListClass.toList()));
      }
    });

  }*/

  callReBuildWidget(bool getDakMode, String getLanguageChange, bool newTest,
      bool oldTest, bool callApi) {
    print("rebuild widget");
    //getSpString();
    setState(() {
      darkMode = getDakMode;
      getLanguageCode = getLanguageChange;
      oldTestNew = oldTest;
      newTestNew = newTest;
      futureFunctionMethod();
      if (callApi) {
        callChapterAPI();
      }
    });
  }

  futureFunctionMethod() {
    // recentChapterFutureMethod = languageTranslatorMethod(
    //     getText: LanguageTextFile().getChapterScreenRecentChapterText(),
    //     getLanguageCode: getLanguageCode);
    // clearAllFutureMethod = languageTranslatorMethod(
    //     getText: LanguageTextFile().getChapterScreenClearAllText(),
    //     getLanguageCode: getLanguageCode);
    // chapterAllFutureMethod = languageTranslatorMethod(
    //     getText: LanguageTextFile().getChapterScreenAllChapterText(),
    //     getLanguageCode: getLanguageCode);
    setState(() {});
  }

  // localData() {
  //   allChapterList.clear();
  //   setState(() {
  //     for (int i = 0; i < 10; i++) {
  //       List<ChapterHomeListClass> getChapterHomeAllListClass = [];
  //       for (int j = 0; j < 3; j++) {
  //         int getValue = (i * 3) + (j + 1);
  //         ChapterHomeListClass getChapterItem = ChapterHomeListClass(
  //             id: getValue,
  //             isSelected: false,
  //             isRecentSelected: false,
  //             chapterName: '',
  //             chapterNumber: 0,
  //             chapterNameMeaning: '',
  //             slockCount: 1);
  //         getChapterHomeAllListClass.add(getChapterItem);
  //       }
  //       allChapterList.add(ChapterHomeAllListClass(
  //           getAllChapterList: getChapterHomeAllListClass.toList()));
  //     }
  //   });

  //   print("Clapter Lenght : ${allChapterList.length}");
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setState(() {
      // theme = Provider.of<ChangeThemeLocal>(context);
      // languageLocal = Provider.of<ChangeLanguageLocal>(context);
      // darkMode = theme.getTheme();
      // getLanguageCode = languageLocal.getLanguage();
      callChapterAPI();
      // localData();
    });
  }

  @override
  Widget build(BuildContext cxt) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    scaleFactor = MediaQuery.of(context).textScaleFactor;
    darkMode = themeMethod(context);

    print(" chapter length : ${allChapterList.length}");
    return
        //  (clearAllFutureMethod == null)
        //     ? const SizedBox()
        //     :
        Container(
      decoration: BoxDecoration(
          color: darkMode ? const Color(0xFF000000) : const Color(0xFFFFF7D8)),
      child: isAPILoading
          ? ChapterLoaderScreen(
              screenWidth: screenWidth,
              screenHeight: screenHeight,
              darkMode: darkMode)
          : Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: screenHeight *
                      (AppConfig().chapterScreenTopCategoryTextPadding /
                          AppConfig().screenHeight),
                ),
                recentChapterList.isEmpty
                    ? const SizedBox()
                    : Container(
                        width: screenWidth,
                        padding: EdgeInsets.symmetric(
                            horizontal: screenWidth *
                                (AppConfig().chapterScreenLeftPadding /
                                    AppConfig().screenWidth)),
                        // child: languageFutureWidget(
                        //     screenWidth: screenWidth,
                        //     screenHeight: screenHeight,
                        //     selectedLanguage: getLanguageCode,
                        //     getLanguageTranslatorMethod:
                        //         recentChapterFutureMethod,
                        //     getFontSize: AppConfig()
                        //         .chapterScreenRecentChapterTextSize,
                        //     getDarkMode: darkMode,
                        //     getTextAlign: TextAlign.start,
                        //     getTextColor: darkMode
                        //         ? AppConfig()
                        //             .chapterScreenRecentChapterTextDarkColor
                        //         : AppConfig()
                        //             .chapterScreenRecentChapterTextLightColor,
                        //     getFontFamily: AppConfig().outfitFontRegular,
                        //     getTextDirection: LanguageTextFile()
                        //         .getTextDirection(getLanguageCode),
                        //     getSoftWrap: true),
                        child: Text(
                          LanguageTextFile().getChapterScreenRecentChapterText(
                              getLanguageCode),
                          textScaler: const TextScaler.linear(1.0),
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: screenHeight *
                                  (AppConfig()
                                          .chapterScreenRecentChapterTextSize /
                                      AppConfig().screenHeight),
                              color: darkMode
                                  ? AppConfig()
                                      .chapterScreenRecentChapterTextDarkColor
                                  : AppConfig()
                                      .chapterScreenRecentChapterTextLightColor,
                              fontFamily: AppConfig().outfitFontRegular),
                          textDirection: LanguageTextFile()
                              .getTextDirection(getLanguageCode),
                        ),
                      ),
                recentChapterList.isEmpty
                    ? const SizedBox()
                    : SizedBox(
                        height: screenHeight *
                            (AppConfig().chapterScreenTopClearAllTextPadding /
                                AppConfig().screenHeight),
                      ),
                recentChapterList.isEmpty
                    ? const SizedBox()
                    : Container(
                        width: screenWidth,
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.symmetric(
                            horizontal: screenWidth *
                                (AppConfig().chapterScreenLeftPadding /
                                    AppConfig().screenWidth)),
                        child: TextButton(
                          onPressed: () {
                            setState(() {
                              recentChapterList.clear();
                              Map<String, dynamic> deleteChapterMap = {
                                "data": []
                              };
                              SharedPreference.instance.setRecentChapter(
                                  "chapter", deleteChapterMap);
                              ToastMessage(
                                  screenHeight,
                                  getLanguageCode == 'en'
                                      ? "Recent Chapter cleared successfully"
                                      : "हालिया अध्याय सफलतापूर्वक साफ़ हो गया",
                                  true);
                            });
                          },
                          style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(
                                  screenWidth * (0 / AppConfig().screenWidth))),
                            ),
                            minimumSize: Size.zero,
                            padding: EdgeInsets.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: SizedBox(
                            width: screenWidth,
                            // child: languageFutureWidget(
                            //     screenWidth: screenWidth,
                            //     screenHeight: screenHeight,
                            //     getLanguageTranslatorMethod:
                            //         clearAllFutureMethod,
                            //     selectedLanguage: getLanguageCode,
                            //     getFontSize: AppConfig()
                            //         .chapterScreenClearAllTextSize,
                            //     getDarkMode: darkMode,
                            //     getTextAlign: TextAlign.start,
                            //     getTextColor: darkMode
                            //         ? AppConfig()
                            //             .chapterScreenChapterClearAllTextDarkColor
                            //         : AppConfig()
                            //             .chapterScreenChapterClearAllTextLightColor,
                            //     getFontFamily:
                            //         AppConfig().outfitFontRegular,
                            //     getTextDirection: LanguageTextFile()
                            //         .getTextDirection(getLanguageCode),
                            //     getSoftWrap: true),
                            child: Text(
                              LanguageTextFile().getChapterScreenClearAllText(
                                  getLanguageCode),
                              textScaler: const TextScaler.linear(1.0),
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontSize: screenHeight *
                                      (AppConfig()
                                              .chapterScreenClearAllTextSize /
                                          AppConfig().screenHeight),
                                  color: darkMode
                                      ? AppConfig()
                                          .chapterScreenChapterClearAllTextDarkColor
                                      : AppConfig()
                                          .chapterScreenChapterClearAllTextLightColor,
                                  fontFamily: AppConfig().outfitFontRegular),
                              textDirection: LanguageTextFile()
                                  .getTextDirection(getLanguageCode),
                            ),
                          ),
                        ),
                      ),
                recentChapterList.isEmpty
                    ? const SizedBox()
                    : SizedBox(
                        height: screenHeight *
                            (AppConfig()
                                    .chapterScreenBottomClearAllTextPadding /
                                AppConfig().screenHeight),
                      ),
                recentChapterList.isEmpty
                    ? const SizedBox()
                    : SizedBox(
                        width: screenWidth,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          reverse: LanguageTextFile()
                                      .getTextDirection(getLanguageCode) ==
                                  TextDirection.rtl
                              ? true
                              : false,
                          child: Row(
                            textDirection: LanguageTextFile()
                                .getTextDirection(getLanguageCode),
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              for (int rc = 0;
                                  rc < recentChapterList.length;
                                  rc++)
                                RecentChapterListview(recentChapterList[rc], rc)
                            ],
                          ),
                        ),
                      ),
                Container(
                  width: screenWidth,
                  padding: EdgeInsets.symmetric(
                      horizontal: screenWidth *
                          (AppConfig().chapterScreenLeftPadding /
                              AppConfig().screenWidth)),
                  // child: languageFutureWidget(
                  //     screenWidth: screenWidth,
                  //     screenHeight: screenHeight,
                  //     selectedLanguage: getLanguageCode,
                  //     getLanguageTranslatorMethod: chapterAllFutureMethod,
                  //     getFontSize:
                  //         AppConfig().chapterScreenAllChapterTextSize,
                  //     getDarkMode: darkMode,
                  //     getTextAlign: TextAlign.start,
                  //     getTextColor: darkMode
                  //         ? AppConfig()
                  //             .chapterScreenAllChapterTextDarkColor
                  //         : AppConfig()
                  //             .chapterScreenAllChapterTextLightColor,
                  //     getFontFamily: AppConfig().outfitFontRegular,
                  //     getTextDirection: LanguageTextFile()
                  //         .getTextDirection(getLanguageCode),
                  //     getSoftWrap: true),
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: (screenHeight * (10 / AppConfig().screenHeight)),
                    ),
                    child: Text(
                      LanguageTextFile()
                          .getChapterScreenAllChapterText(getLanguageCode),
                      textScaler: const TextScaler.linear(1.0),
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontSize: screenHeight *
                              (AppConfig().chapterScreenAllChapterTextSize /
                                  AppConfig().screenHeight),
                          color: darkMode
                              ? AppConfig().chapterScreenAllChapterTextDarkColor
                              : AppConfig()
                                  .chapterScreenAllChapterTextLightColor,
                          fontFamily: AppConfig().outfitFontRegular),
                      textDirection:
                          LanguageTextFile().getTextDirection(getLanguageCode),
                    ),
                  ),
                ),
                SizedBox(
                  height: screenHeight *
                      (AppConfig().chapterScreenBottomAllChapterTextPadding /
                          AppConfig().screenHeight),
                ),
                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      for (int al = 0; al < allChapterList.length; al++)
                        AllChapterListview(allChapterList[al].getAllChapterList)
                    ],
                  ),
                ),
                SizedBox(
                  height: screenHeight *
                      (AppConfig().bottomNavigationBarHeight /
                          AppConfig().screenHeight),
                ),
              ],
            ),
    );
  }

  Widget RecentChapterListview(
      ChapterHomeListClass getChapterHomeClass, int getIndex) {
    return RecentChapterListviewWidget(
        screenWidth: screenWidth,
        screenHeight: screenHeight,
        getChapterClass: getChapterHomeClass,
        currentIndex: getIndex,
        darkMode: darkMode,
        getLanguageCode: getLanguageCode,
        recent: true,
        getCallBackFunction: (getResult) {
          for (int i = 0; i < recentChapterList.length; i++) {
            if (recentChapterList[i].bookid == getResult.bookid) {
              setState(() {
                recentChapterList[i].isRecentSelected = true;
              });
              navigateToCategoryDetailScreen(getResult.bookid.toString(),
                  getResult.chapters.toString(), getResult.name!);
            } else {
              setState(() {
                recentChapterList[i].isRecentSelected = false;
              });
            }
          }
        });
  }

  Widget AllChapterListview(List<ChapterHomeListClass> getAllChapterList) {
    return AllChapterListviewWidget(
      screenWidth: screenWidth,
      screenHeight: screenHeight,
      getChapterList: getAllChapterList,
      darkMode: darkMode,
      getLanguageCode: getLanguageCode,
      recent: false,
      getCallBackFunction: (getResult) {
        print(getResult);

        navigateToCategoryDetailScreen(getResult.bookid.toString(),
            getResult.chapters.toString(), getResult.name!);
        // for (int i = 0; i < allChapterList.length; i++) {
        //   for (int j = 0; j < allChapterList[i].getAllChapterList.length; j++) {
        //     if (allChapterList[i].getAllChapterList[j].bookid ==
        //         getResult.bookid) {
        //       setState(() {
        //         allChapterList[i].getAllChapterList[j].isSelected = true;

        //         /*if(getPreviousRecentChapterList.contains(getResult.id)){

        //       }
        //       else{
        //         getPreviousRecentChapterList.insert(0,getResult.id);
        //         recentChapterList.insert(0,getResult);
        //       }*/
        //       });
        //     } else {
        //       setState(() {
        //         allChapterList[i].getAllChapterList[j].isSelected = false;
        //       });
        //     }
        //   }
        // }
        //  getSharedPreferenceData(getResult);
      },
    );
  }
}
