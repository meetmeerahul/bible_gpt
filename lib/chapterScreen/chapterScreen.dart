import 'dart:async';

import 'package:bible_gpt/chapterScreen/bookDetailScreen.dart';
import 'package:flutter/material.dart';

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
  chapterPage({Key? key, required this.context});
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
  String getLanguageCode = "en";
  String recentChapter = "";
  String clearAll = "";
  String chapterAll = "";
  bool isAPILoading = false;

  navigateToNoInternetScreen(String? getId) {
    Navigator.push(context,
            MaterialPageRoute(builder: (context) => const NoInternetScreen()))
        .then((value) {
      if (value) {
        if (getId != null) {
          navigateToCategoryDetailScreen(getId);
        }
      }
    });
  }

  navigateToCategoryDetailScreen(String getId) async {
    bool checkInternet = await CheckInternetConnectionMethod();
    if (checkInternet) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  // categoryDetailScreen(
                  //   screenType: 0,
                  //   getValue: getId,
                  //   languageCode: null,
                  // ),
                  const BookDetailScreen())).then((value) {
        setState(() {});
      });
    } else {
      navigateToNoInternetScreen(getId);
    }
  }

  getSharedPreferenceData(ChapterHomeListClass getResult) async {
    Map<String, dynamic> getChapterPreference =
        await SharedPreference.instance.getRecentChapter("chapter");
    if (getChapterPreference.isNotEmpty) {
      List getChapterRecentList = getChapterPreference["data"] ?? [];
      bool itemAlreadyAdded = false;
      for (int a = 0; a < getChapterRecentList.length; a++) {
        Map<String, dynamic> getChapterItem = getChapterRecentList[a];
        if (getChapterItem["id"] == getResult.id) {
          itemAlreadyAdded = true;
          getChapterRecentList.remove(getChapterItem);
          getChapterRecentList.insert(0, getChapterItem);
        }
      }
      if (itemAlreadyAdded) {
      } else {
        Map<String, dynamic> getChapterItem = getResult.toJson();
        getChapterRecentList.insert(0, getChapterItem);
      }
      Map<String, dynamic> updatedRecentChapterResponse = {};
      updatedRecentChapterResponse["data"] = getChapterRecentList;
      SharedPreference.instance
          .setRecentChapter("chapter", updatedRecentChapterResponse);
      recentData();
    } else {
      List<Map<String, dynamic>> getChapterRecentList =
          getChapterPreference["data"] ?? [];
      Map<String, dynamic> getChapterItem = getResult.toJson();
      getChapterRecentList.insert(0, getChapterItem);
      Map<String, dynamic> updatedRecentChapterResponse = {};
      updatedRecentChapterResponse["data"] = getChapterRecentList;
      SharedPreference.instance
          .setRecentChapter("chapter", updatedRecentChapterResponse);
      recentData();
    }
  }

  recentData() async {
    recentChapterList.clear();
    Map<String, dynamic> getChapterPreference =
        await SharedPreference.instance.getRecentChapter("chapter");
    print(getChapterPreference);
    if (getChapterPreference.isNotEmpty) {
      List getChapterList = getChapterPreference["data"] ?? [];
      setState(() {
        for (int i = 0; i < getChapterList.length; i++) {
          Map<String, dynamic> getRecentItem = getChapterList[i];
          ChapterHomeListClass getChapterHomeItem =
              ChapterHomeListClass.fromJson(getRecentItem);
          recentChapterList.add(getChapterHomeItem);
        }
      });
    }
  }

  // callChapterAPI() async {
  //   setState(() {
  //     isAPILoading = true;
  //   });
  //   bool internetConnectCheck = await CheckInternetConnectionMethod();
  //   if (internetConnectCheck) {
  //     var getHomeChapterAPIResponse =
  //         await AllAPIMethod().getAllChapterDataAPI();
  //     print(getHomeChapterAPIResponse);
  //     if (getHomeChapterAPIResponse["status"]) {
  //       setState(() {
  //         allChapterList.clear();
  //         List<ChapterHomeListClass> getResponseData =
  //             getHomeChapterAPIResponse["data"];
  //         List<ChapterHomeListClass> getChapterHomeList = [];
  //         for (int i = 0; i < getResponseData.length; i++) {
  //           getChapterHomeList.add(getResponseData[i]);
  //           if ((i == (getResponseData.length - 1)) || ((i + 1) % 3 == 0)) {
  //             allChapterList.add(ChapterHomeAllListClass(
  //                 getAllChapterList: List.from(getChapterHomeList)));
  //             getChapterHomeList.clear();
  //           }
  //         }
  //       });
  //     } else {
  //       ToastMessage(screenHeight, getHomeChapterAPIResponse["message"],
  //           getHomeChapterAPIResponse["status"]);
  //     }
  //   } else {
  //     navigateToNoInternetScreen(null);
  //   }
  //   setState(() {
  //     isAPILoading = false;
  //   });
  //   recentData();
  // }

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

  callReBuildWidget(bool getDakMode, String getLanguageChange) {
    print("rebuild widget");
    setState(() {
      darkMode = getDakMode;
      getLanguageCode = getLanguageChange;
      futureFunctionMethod();
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

  localData() {
    allChapterList.clear();
    setState(() {
      for (int i = 0; i < 10; i++) {
        List<ChapterHomeListClass> getChapterHomeAllListClass = [];
        for (int j = 0; j < 3; j++) {
          int getValue = (i * 3) + (j + 1);
          ChapterHomeListClass getChapterItem = ChapterHomeListClass(
              id: getValue,
              isSelected: false,
              isRecentSelected: false,
              chapterName: '',
              chapterNumber: 0,
              chapterNameMeaning: '',
              slockCount: 1);
          getChapterHomeAllListClass.add(getChapterItem);
        }
        allChapterList.add(ChapterHomeAllListClass(
            getAllChapterList: getChapterHomeAllListClass.toList()));
      }
    });

    print("Clapter Lenght : ${allChapterList.length}");
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      // theme = Provider.of<ChangeThemeLocal>(context);
      // languageLocal = Provider.of<ChangeLanguageLocal>(context);
      // darkMode = theme.getTheme();
      // getLanguageCode = languageLocal.getLanguage();
      // callChapterAPI();
      localData();
    });
  }

  @override
  Widget build(BuildContext cxt) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    scaleFactor = MediaQuery.of(context).textScaleFactor;
    darkMode = themeMethod(context);

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
                          LanguageTextFile()
                              .getChapterScreenRecentChapterText(),
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
                              ToastMessage(screenHeight,
                                  "Recent Chapter cleared successfully", true);
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
                              LanguageTextFile().getChapterScreenClearAllText(),
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
                  child: Text(
                    LanguageTextFile().getChapterScreenAllChapterText(),
                    textScaler: const TextScaler.linear(1.0),
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        fontSize: screenHeight *
                            (AppConfig().chapterScreenAllChapterTextSize /
                                AppConfig().screenHeight),
                        color: darkMode
                            ? AppConfig().chapterScreenAllChapterTextDarkColor
                            : AppConfig().chapterScreenAllChapterTextLightColor,
                        fontFamily: AppConfig().outfitFontRegular),
                    textDirection:
                        LanguageTextFile().getTextDirection(getLanguageCode),
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
            if (recentChapterList[i].id == getResult.id) {
              setState(() {
                recentChapterList[i].isRecentSelected = true;
              });
              navigateToCategoryDetailScreen(getResult.id.toString());
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
        for (int i = 0; i < allChapterList.length; i++) {
          for (int j = 0; j < allChapterList[i].getAllChapterList.length; j++) {
            if (allChapterList[i].getAllChapterList[j].id == getResult.id) {
              setState(() {
                allChapterList[i].getAllChapterList[j].isSelected = true;
                /*if(getPreviousRecentChapterList.contains(getResult.id)){

              }
              else{
                getPreviousRecentChapterList.insert(0,getResult.id);
                recentChapterList.insert(0,getResult);
              }*/
              });
            } else {
              setState(() {
                allChapterList[i].getAllChapterList[j].isSelected = false;
              });
            }
          }
        }
        getSharedPreferenceData(getResult);
        navigateToCategoryDetailScreen(getResult.id.toString());
      },
    );
  }
}
