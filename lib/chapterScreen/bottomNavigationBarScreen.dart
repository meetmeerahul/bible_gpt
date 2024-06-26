import 'dart:io';

import 'package:bible_gpt/class/book_details.dart';
import 'package:bible_gpt/dashBoardScreen/dash_board_screen.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:launch_review/launch_review.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../APIRequest/api_handler.dart';
import '../class/LanguageMethod.dart';
import '../class/change_language_local.dart';
import '../class/change_theme_local.dart';
import '../class/languages_and_transilations.dart';
import '../class/theme_method.dart';
import '../config/app_config.dart';
import '../config/changable.dart';
import '../config/language_text_file.dart';
import '../config/shared_preferences.dart';
import '../dashBoardScreen/gptScreen.dart';
import '../dashBoardScreen/noInternetScreen.dart';
import '../loader/widget/TextLoaderWidget.dart';
import '../reuseable/button/BackArrowWidget.dart';
import '../reuseable/button/PrimaryButton.dart';
import '../signInScreen/profile_page.dart';
import '../signInScreen/signinScreen.dart';
import '../signInScreen/webViewScreen.dart';
import '../widgets/MenuBarDrawer.dart';
import '../widgets/app_logo_widget.dart';
import '../widgets/check_internet_method.dart';
import '../widgets/search_gpt_text_field.dart';
import '../widgets/toast_message.dart';
import 'chapterScreen.dart';

class bottomNavigationBarScreen extends StatefulWidget {
  final int currentPage;
  const bottomNavigationBarScreen({super.key, required this.currentPage});

  @override
  State<StatefulWidget> createState() {
    return bottomNavigationBarPage(currentPage: currentPage);
  }
}

class bottomNavigationBarPage extends State<bottomNavigationBarScreen> {
  final int currentPage;
  bottomNavigationBarPage({Key? key, required this.currentPage});
  double screenWidth = 0;
  double screenHeight = 0;
  double scaleFactor = 0;
  List screens = [];

  bool swippedDown = true;
  int pageIndex = 0;
  List<int> lastPageList = [];
  TextEditingController editingController = TextEditingController();
  late bool darkMode;
  //late VideoPlayerController _controller;
  //late int getLanguageType;
  late String getLanguageCode;
  late var activeSource;
  ScrollController pageScrollController = ScrollController();
  double statusBarHeight = 0;
  bool statusBarVisible = false;
  final GlobalKey<chapterPage> _chapterkey = GlobalKey<chapterPage>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String profilePictureUrl = "";
  String profileName = "";
  //String selectedLanguage = "";
  //List<LanguageClass> getLanguageClassList = [];
  List<String> getLanguageList = LanguageTextFile().getLanguageList();
  late ChangeLanguageLocal languageLocal;
  bool userLoggedIn = false;
  bool isDeleteAPILoading = false;
  late String getToken;
  late bool switchValue;
  late ChangeThemeLocal theme;
  late String bottomNavigationContent;
  late String chapterButtonText;
  late String bottomNavigationChapterText;
  late String profileNameText;

  bool isRebuild = true;

  Future<List<LanguagesAndTransilations>>? _languagesFuture;

  LanguagesAndTransilations? _selectedLanguage;

  List<Translations>? _selectedTranslations;

  Translations? userSelectedTranslation;

  Future<List<BookDetails>>? _bookDetailsFuture;

  String shortName = "YLT";

  String? _defaultShortName;
  bool languageSelected = false;

  bool oldTest = true;
  bool newTest = false;

  bool oldTShadow = true;
  bool newTShadow = false;

  scrollinit() async {
    bool internetConnectCheck = await CheckInternetConnectionMethod();
    if (internetConnectCheck) {
      pageScrollController.addListener(() {
        if (pageScrollController.offset > 0) {
          if (statusBarVisible) {
          } else {
            setState(() {
              statusBarVisible = true;
            });
          }
        } else {
          setState(() {
            statusBarVisible = false;
          });
        }
      });
    }
  }

  getUserToken() async {
    getToken = await SharedPreference.instance.getUserToken('token');
    setState(() {
      if (getToken != "") {
        userLoggedIn = true;
      } else {
        userLoggedIn = false;
      }
    });
  }

  getUserData() async {
    getUserToken();
    Map<String, dynamic> getUserDetail =
        await SharedPreference.instance.getUserProfileDetail("user");
    print("user info: $getUserDetail");
    setState(() {
      profileName =
          "${getUserDetail["first_name"] ?? ""} ${getUserDetail["last_name"] ?? ""}";
      profilePictureUrl = "${getUserDetail["avatar"] ?? ""}";
      if (profileName == "" || profileName == " ") {
        profileName = "Guest";
      }
    });
  }

  navigateToGPTScreen() {
    Navigator.push(
            context, MaterialPageRoute(builder: (context) => const GptScreen()))
        .then((value) {
      setState(() {});
    });
  }

  navigateToSignInScreen() {
    Navigator.push(context,
            MaterialPageRoute(builder: (context) => const SigninScreen()))
        .then((value) {
      if (value != "") {
        ToastMessage(screenHeight, value, true);
        getUserData();
      }
    });
  }

  navigateToProfileScreen() {
    Navigator.push(context,
            MaterialPageRoute(builder: (context) => const ProfilePage()))
        .then((value) {
      if (value != "") {
        ToastMessage(screenHeight, value, true);
        getUserData();
      }
    });
  }

  navigateToWebViewScreen(String getWebViewUrl, String getWebViewTitle) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => webViewScreen(
                webViewUrl: getWebViewUrl,
                webViewTitle: getWebViewTitle))).then((value) {});
  }

  navigateToNoInternetScreen(bool initCall) {
    Navigator.push(context,
            MaterialPageRoute(builder: (context) => const NoInternetScreen()))
        .then((value) {
      if (initCall) {
        callInitState();
      }
    });
  }

  navigateToStore() {
    LaunchReview.launch(
      androidAppId: AppConfig().googleStoreId,
      iOSAppId: AppConfig().appleStoreId,
    );
  }

  checkUserLogIn() async {
    String getToken = await SharedPreference.instance.getUserToken('token');
    if (getToken == "") {
      navigateToSignInScreen();
    } else {
      navigateToProfileScreen();
    }
  }

  callSocialMediaClick(int getSelectedSocialMedia) {
    // if (getSelectedSocialMedia == 1) {
    //   print("Youtube Click");
    // } else if (getSelectedSocialMedia == 2) {
    //   print("Facebook Click");
    //   navigateToWebViewScreen(AppConfig().facebookLink, "");
    // } else if (getSelectedSocialMedia == 3) {
    //   print("Twitter Click");
    //   navigateToWebViewScreen(AppConfig().twitterLink, "");
    // } else {
    //   navigateToWebViewScreen(AppConfig().instagramLink, "");
    //   print("Instagram Click");
    // }
  }

  addContextInScreen() {
    print("rebuild");

    setState(() {
      isRebuild = false;

      screens.add(chapterScreen(
        key: _chapterkey,
        context: context,
      ));
    });
  }

  themeChange() {
    setState(() {
      switchValue = darkMode;
    });
  }

  changeTheme() {
    setState(() {
      print(switchValue);
      if (switchValue) {
        switchValue = false;
      } else {
        switchValue = true;
      }
      darkMode = switchValue;
      theme.setTheme(switchValue);
      themeChange();
      SharedPreference.instance.setOnDarkMode("darkMode", darkMode);
      print("language code in theme : $getLanguageCode");
      _chapterkey.currentState?.callReBuildWidget(
          darkMode, getLanguageCode, oldTest, newTest, false);
    });
  }

  callSettingControl(int getSelectedSetting) {
    setState(() {
      if (getSelectedSetting == 2) {
        changeTheme();
      } else if (getSelectedSetting == 3) {
        navigateToWebViewScreen(
            AppConfig().aboutUsUrl,
            LanguageTextFile()
                .getLanguageSettingTermPrivacyText(getLanguageCode));
      } else if (getSelectedSetting == 4) {
        navigateToWebViewScreen(AppConfig().contactUsUrl,
            LanguageTextFile().getLanguageSettingContactText(getLanguageCode));
      } else if (getSelectedSetting == 5) {
        // navigateToStore();
      } else if (getSelectedSetting == 6) {
        callDeleteAccountAPI(getToken);
      }
    });
  }

  languageChange(String getLanguage) {
    setState(() {
      print("Selected language : $getLanguage");
      getLanguageCode = getLanguage;
      futureFunctionMethod();
      /*for(int i = 0 ; i < getLanguageClassList.length; i++){
        if(getLanguageClassList[i].languageId==getLanguage){
          getLanguageClassList[i].languageSelected = true;
          selectedLanguage = getLanguageClassList[i].languageName;
        }
        else{
          getLanguageClassList[i].languageSelected = false;
        }
      }*/
      print("language code in language : $getLanguageCode");
      _chapterkey.currentState?.callReBuildWidget(
          darkMode, getLanguageCode, oldTest, newTest, false);
    });
  }

  logOutUser(String getMessage) {
    _scaffoldKey.currentState!.closeEndDrawer();
    SharedPreference.instance.setUserToken("token", "");
    SharedPreference.instance.setUserProfileDetail("user", {});
    ToastMessage(screenHeight, getMessage, true);
    getUserData();
  }

  callDeleteAccountAPI(String getToken) async {
    setState(() {
      isDeleteAPILoading = true;
    });
    bool internetConnectCheck = await CheckInternetConnectionMethod();
    if (internetConnectCheck) {
      var getDeleteAccountAPIResponse = await ApiHandler().deleteAccountAPI(
        getToken: getToken,
      );
      print(getDeleteAccountAPIResponse);
      if (getDeleteAccountAPIResponse["status"]) {
        String getResponseMessage = getDeleteAccountAPIResponse["message"];
        logOutUser(getResponseMessage);
      } else {
        ToastMessage(screenHeight, getDeleteAccountAPIResponse["message"],
            getDeleteAccountAPIResponse["status"]);
      }
    } else {
      navigateToNoInternetScreen(false);
    }
    setState(() {
      isDeleteAPILoading = false;
    });
  }

  initialData() {
    setState(() {
      languageLocal = Provider.of<ChangeLanguageLocal>(context);
      getLanguageCode = languageMethod(context);
      //getLanguageClassList.clear();
      //getLanguageClassList.add(LanguageClass(languageId: AppConfig().languageSettingEnglishLanguageCode, languageName: LanguageTextFile().getLanguageSettingLanguageNameEnglishText(getLanguageType), languageDropDownName: LanguageTextFile().getLanguageSettingLanguageDropdownEnglishText(getLanguageType), languageSelected: false));
      //getLanguageClassList.add(LanguageClass(languageId: AppConfig().languageSettingArabicLanguageCode, languageName: LanguageTextFile().getLanguageSettingLanguageNameArabicText(getLanguageType), languageDropDownName: LanguageTextFile().getLanguageSettingLanguageDropdownArabicText(getLanguageType), languageSelected: false));
      languageChange(getLanguageCode);
    });
  }

  futureFunctionMethod() {
    // bottomNavigationContent =
    //     LanguageTextFile().getBottomNavigationContentText(context);
    chapterButtonText = LanguageTextFile().getChapterScreenChapterText();
    bottomNavigationChapterText =
        LanguageTextFile().getBottomNavigationChapterText(getLanguageCode);
    profileNameText = profileName;

    // bottomNavigationContentFuture = languageTranslatorMethod(
    //     getText: LanguageTextFile().getBottomNavigationContentText(),
    //     getLanguageCode: getLanguageCode);
    // chapterButtonTextFuture = languageTranslatorMethod(
    //     getText: LanguageTextFile().getChapterScreenChapterText(),
    //     getLanguageCode: getLanguageCode);
    // bottomNavigationChapterTextFuture = languageTranslatorMethod(
    //     getText: LanguageTextFile().getBottomNavigationChapterText(),
    //     getLanguageCode: getLanguageCode);
    // profileNameTextFuture = languageTranslatorMethod(
    //     getText: profileName, getLanguageCode: getLanguageCode);
    setState(() {});
  }

  changeScreen(int getCurrentScreen) {
    setState(() {
      navigateToChapterScreen(getCurrentScreen);
    });
  }

  navigateToChapterScreen(int page) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => bottomNavigationBarScreen(
                  currentPage: page,
                ))).then((value) {
      setState(() {});
    });
  }

  callInitState() async {
    bool internetConnectCheck = await CheckInternetConnectionMethod();

    if (internetConnectCheck) {
      setState(() {
        pageIndex = currentPage;
      });
      // pageScrollController.addListener(() {
      //   if (pageScrollController.offset > 0) {
      //     if (statusBarVisible) {
      //     } else {
      //       setState(() {
      //         statusBarVisible = true;
      //       });
      //     }
      //   } else {
      //     setState(() {
      //       statusBarVisible = false;
      //     });
      //   }
      //   if (pageScrollController.position.maxScrollExtent ==
      //       pageScrollController.position.pixels) {
      //     print("call bottom");
      //   }
      // });
      getUserData();
    } else {
      navigateToNoInternetScreen(true);
    }
  }

  void getBookDetails(String shortName) async {
    bool internetConnectCheck = await CheckInternetConnectionMethod();

    if (internetConnectCheck) {
      List<BookDetails> bookDetails =
          await ApiHandler.getBookDetails(shortName: shortName);
      int count = bookDetails.length; // Retrieve the count directly
      print('Number of result maps: $count');

      // Index 40 to last

      // print("First Slice greek : ${firstSlice.length}");
      // print("Second Slice greek : ${secondSlice.length}");

      if (bookDetails.length == 27) {
        setState(() {
          newT = 0;

          List<BookDetails> firstSlice = bookDetails.sublist(0, 27);
          oldT = firstSlice.length;

          print("Length Of $oldT");
        });
      } else {
        List<BookDetails> firstSlice =
            bookDetails.sublist(0, 39); // Index 0 to 39
        List<BookDetails> secondSlice = bookDetails.sublist(39);

        setState(() {
          newT = secondSlice.length;
          oldT = firstSlice.length;
        });
      }

      // if (count == 66) {
      //   setState(() {
      //     newT = 27;
      //     oldT = 39;
      //   });
      // } else {
      //   setState(() {
      //     oldT = 39;
      //     newT = 0;
      //   });
      // }
    } else {
      navigateToNoInternetScreen(true);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    scrollinit();
    callInitState();
    _languagesFuture = ApiHandler.getLanguages();

    _languagesFuture!.then((languages) {
      _selectedLanguage =
          languages.firstWhere((lang) => lang.language == 'English');
      _selectedTranslations = _selectedLanguage!.translations;
    });

    print("---Book details---");
    _bookDetailsFuture = ApiHandler.getBookDetails(shortName: "YLT");
    changableShortName = "YLT";
    // setShortname(shortName);
    print("$_bookDetailsFuture");
  }

  @override
  void dispose() {
    pageScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    statusBarHeight = MediaQuery.of(context).padding.top;
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    scaleFactor = MediaQuery.of(context).textScaleFactor;
    theme = Provider.of<ChangeThemeLocal>(context);
    darkMode = themeMethod(context);
    themeChange();
    initialData();

    // newTShadow = false;
    // oldTShadow = true;

    if (isRebuild) {
      addContextInScreen();
    }

    print(_selectedLanguage);

    AppConfig().getStatusBar(darkMode);
    return WillPopScope(
      onWillPop: Platform.isIOS
          ? null
          : () async {
              if (_scaffoldKey.currentState!.isEndDrawerOpen) {
                _scaffoldKey.currentState!.closeEndDrawer();
                return false;
              }
              return true;
            },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home:
            // (bottomNavigationChapterTextFuture == null)
            //     ? const SizedBox()
            //     :
            Scaffold(
          resizeToAvoidBottomInset: true,
          key: _scaffoldKey,
          endDrawer: MenuBarDrawer(
            context: context,
            screenWidth: screenWidth,
            screenHeight: screenHeight,
            statusBarHeight: statusBarHeight,
            getDarkMode: darkMode,
            getLanguageCode: getLanguageCode,
            profilePictureUrl: profilePictureUrl,
            profileName: profileNameText,
            currentCategory: pageIndex,
            getLanguageList: getLanguageList,
            isDeleteAPILoading: isDeleteAPILoading,
            isUserLoggedIn: userLoggedIn,
            switchValue: switchValue,
            chapterText: bottomNavigationChapterText,
            callBackProfileClickFunction: (isClick) {
              if (isClick) {
                _scaffoldKey.currentState!.closeEndDrawer();
                checkUserLogIn();
              }
            },
            callBackSocialMediaFunction: (int getSocialMedia) {
              _scaffoldKey.currentState!.closeEndDrawer();
              callSocialMediaClick(getSocialMedia);
            },
            callBackSelectedCategory: (int getSelectedCategory) {
              _scaffoldKey.currentState!.closeEndDrawer();
              if (pageIndex == getSelectedCategory) {
              } else {
                changeScreen(getSelectedCategory);
              }
            },
            callBackSettingSelected: (int getSettingSelected) {
              if (getSettingSelected == 6) {
              } else {
                _scaffoldKey.currentState!.closeEndDrawer();
              }

              callSettingControl(getSettingSelected);
            },
            callBackLanguageSelectedClick: (String getSelectedLanguage) {
              _scaffoldKey.currentState!.closeEndDrawer();
              languageLocal.setLanguage(getSelectedLanguage);
              SharedPreference.instance
                  .setSelectedLanguage("language", getSelectedLanguage);
              languageChange(getSelectedLanguage);
            },
          ),
          body: Container(
            width: screenWidth,
            height: screenHeight,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[
                  darkMode
                      ? AppConfig().chapterScreenBackgroundStartDarkColor
                      : AppConfig().chapterScreenBackgroundStartLightColor,
                  darkMode
                      ? AppConfig().chapterScreenBackgroundEndDarkColor
                      : AppConfig().chapterScreenBackgroundEndLightColor,
                ],
                tileMode: TileMode.mirror,
              ),
            ),
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                SingleChildScrollView(
                  controller: pageScrollController,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: swippedDown
                            ? (screenHeight * (400 / AppConfig().screenHeight))
                            : (screenHeight * (520 / AppConfig().screenHeight)),

                        decoration: const BoxDecoration(),
                        //   height: 345, //add to appconfig()
                        child: Stack(
                          alignment: Alignment.topCenter,
                          children: [
                            Positioned.fill(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Container(
                                        color: Colors.transparent
                                            .withOpacity(darkMode ? 0 : 0),
                                        width: screenWidth,
                                        //color: darkMode?Colors.transparent.withOpacity(0.7):null,
                                        child: Image.asset(
                                          darkMode
                                              ? AppConfig()
                                                  .bottomNavigationBookDarkIcon
                                              : AppConfig()
                                                  .bottomNavigationBookLightIcon,
                                          fit: darkMode
                                              ? BoxFit.fill
                                              : BoxFit.fill,
                                        )),
                                  ),
                                  SizedBox(
                                    height: screenHeight *
                                        ((AppConfig()
                                                    .chapterScreenCategoryButtonHeight /
                                                2) /
                                            AppConfig().screenHeight),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                //crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: screenHeight *
                                        (AppConfig()
                                                .chapterScreenTopAppLogoPadding /
                                            AppConfig().screenHeight),
                                  ),
                                  Container(
                                    width: screenWidth,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: screenWidth *
                                            (24 / AppConfig().screenWidth)),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          child: BackArrowWidget(
                                              screenWidth: screenWidth,
                                              screenHeight: screenHeight,
                                              darkMode: darkMode,
                                              getCallBackFunction: (isClicked) {
                                                if (isClicked) {
                                                  // Navigator.pop(context);
                                                  Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              const DashboardScreen()));
                                                }
                                              }),
                                        ),
                                        AppLogoWidget(
                                            screenWidth,
                                            screenHeight,
                                            AppConfig()
                                                .chapterScreenAppLogoWidth,
                                            AppConfig()
                                                .chapterScreenAppLogoHeight,
                                            darkMode),
                                        Container(
                                          child: TextButton(
                                            onPressed: () {
                                              //navigateToSignInScreen();
                                              //checkUserLogIn();
                                              _scaffoldKey.currentState!
                                                  .openEndDrawer();
                                            },
                                            style: TextButton.styleFrom(
                                              minimumSize: Size.zero,
                                              padding: EdgeInsets.zero,
                                              tapTargetSize:
                                                  MaterialTapTargetSize
                                                      .shrinkWrap,
                                            ),
                                            child: Container(
                                              width: screenWidth *
                                                  ((AppConfig()
                                                              .backArrowWidgetOuterWidth +
                                                          15) /
                                                      AppConfig().screenWidth),
                                              height: screenWidth *
                                                  (31 /
                                                      AppConfig().screenWidth),
                                              alignment: Alignment.centerRight,
                                              child: SvgPicture.asset(
                                                color: darkMode
                                                    ? const Color(0xFFFFFFFF)
                                                    : const Color(0xFFAF6A06),
                                                darkMode
                                                    ? AppConfig()
                                                        .chapterScreenMenuIconDark
                                                    : AppConfig()
                                                        .chapterScreenMenuIconLight,
                                                fit: BoxFit.scaleDown,
                                                width: screenWidth *
                                                    (21 /
                                                        AppConfig()
                                                            .screenWidth),
                                                height: screenWidth *
                                                    (21 /
                                                        AppConfig()
                                                            .screenWidth),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: screenHeight *
                                        (AppConfig()
                                                .chapterScreenTopSearchPadding /
                                            AppConfig().screenHeight),
                                  ),
                                  SearchGptTextFieldWidget(
                                      context: context,
                                      screenWidth: screenWidth,
                                      screenHeight: screenHeight,
                                      scaleFactor: scaleFactor,
                                      getHintText: LanguageTextFile()
                                          .getSearchGPTWidgetHintText(
                                              getLanguageCode),
                                      readOnly: true,
                                      textEditingController: editingController,
                                      isListening: false,
                                      darkMode: darkMode,
                                      backgroundOpacity: darkMode
                                          ? 0.4
                                          : (Platform.isIOS ? 1 : 1),
                                      getLanguageCode: getLanguageCode,
                                      textScrollController: null,
                                      getEdittextFunction: (p0) => null,
                                      submitTextFunction: (get) {
                                        navigateToGPTScreen();
                                      },
                                      getListeningFunction: (getResult) {
                                        navigateToGPTScreen();
                                      }),
                                  SizedBox(
                                    height: screenHeight *
                                        (AppConfig()
                                                .chapterScreenTopContentPadding /
                                            AppConfig().screenHeight),
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: screenWidth *
                                            (AppConfig()
                                                    .chapterScreenLeftPadding *
                                                2 /
                                                AppConfig().screenWidth)),
                                    child: Text(
                                      LanguageTextFile()
                                          .getDashboardScreenBottomContentText(
                                              getLanguageCode),
                                      textScaler: const TextScaler.linear(1.0),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: MediaQuery.of(context)
                                              .textScaler
                                              .scale(
                                                screenHeight *
                                                    (AppConfig()
                                                            .chapterScreenContentTextSize /
                                                        AppConfig()
                                                            .screenHeight),
                                              ),
                                          color: darkMode
                                              ? AppConfig()
                                                  .chapterScreenContentTextDarkColor
                                              : AppConfig()
                                                  .chapterScreenContentTextLightColor,
                                          fontFamily:
                                              AppConfig().outfitFontRegular),
                                      textDirection: LanguageTextFile()
                                          .getTextDirection(getLanguageCode),
                                    ),
                                  ),
                                  SizedBox(
                                    height: screenHeight *
                                        (AppConfig()
                                                .chapterScreenBottomContentPadding /
                                            AppConfig().screenHeight),
                                  ),
                                  // PrimaryButton(
                                  //     screenWidth: screenWidth,
                                  //     screenHeight: screenHeight,
                                  //     buttonWidth: AppConfig()
                                  //         .chapterScreenCategoryButtonWidth,
                                  //     buttonHeight: AppConfig()
                                  //         .chapterScreenCategoryButtonHeight,
                                  //     getDarkMode: false,
                                  //     buttonText: chapterButtonText,
                                  //     getLanguageCode: getLanguageCode,
                                  //     isAPILoading: false,
                                  //     iconPath: null,
                                  //     iconWidth: null,
                                  //     iconHeight: null,
                                  //     buttonPressedFunction: (isClicked) {
                                  //       print("1");
                                  //     }),

                                  // SWIPE DOWN AND SWIPE UP

                                  Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                // oldTest = !oldTest;
                                                // if (newTest) {
                                                //   newTest = !newTest;
                                                // }
                                                oldTest = true;
                                                newTest = false;

                                                oldTShadow = true;
                                                newTShadow = false;
                                                _chapterkey.currentState
                                                    ?.callReBuildWidget(
                                                        darkMode,
                                                        getLanguageCode,
                                                        oldTest,
                                                        newTest,
                                                        true);
                                              });
                                            },
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                  .textScaler
                                                  .scale(screenWidth *
                                                      (143 /
                                                          AppConfig()
                                                              .screenWidth)),
                                              height: MediaQuery.of(context)
                                                  .textScaler
                                                  .scale((screenHeight *
                                                      (40 /
                                                          AppConfig()
                                                              .screenHeight))),
                                              decoration: BoxDecoration(
                                                boxShadow: [
                                                  oldTShadow
                                                      ? BoxShadow(
                                                          color: const Color(
                                                                  0xFFBE7C12)
                                                              .withOpacity(.9),
                                                          spreadRadius: 1,
                                                          blurRadius: 10,
                                                          blurStyle:
                                                              BlurStyle.outer)
                                                      : const BoxShadow(
                                                          color: Colors
                                                              .transparent)
                                                ],
                                                border: Border.all(
                                                  color: darkMode
                                                      ? const Color(0xFFFFCA8C)
                                                      : const Color(0xFF754003),
                                                  width: 1,
                                                ),
                                                color: Colors.transparent,
                                                borderRadius:
                                                    const BorderRadiusDirectional
                                                        .all(
                                                  Radius.circular(100),
                                                ),
                                              ),
                                              child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    Text(
                                                      LanguageTextFile()
                                                          .bottomNavOldTestment(
                                                              getLanguageCode),
                                                      style: TextStyle(
                                                          color: darkMode
                                                              ? const Color(
                                                                  0xFFFFCA8C)
                                                              : const Color(
                                                                  0xFF754003),
                                                          fontSize: MediaQuery
                                                                  .of(context)
                                                              .textScaler
                                                              .scale((screenHeight *
                                                                  (12 /
                                                                      AppConfig()
                                                                          .screenHeight)))),
                                                    ),
                                                    CircleAvatar(
                                                      radius: MediaQuery.of(
                                                              context)
                                                          .textScaler
                                                          .scale((screenHeight *
                                                              (14.5 /
                                                                  AppConfig()
                                                                      .screenHeight))),
                                                      backgroundColor: darkMode
                                                          ? const Color(
                                                              0xFF673602)
                                                          : const Color(
                                                              0xFFD69E0B),
                                                      child: Text(
                                                          oldT.toString(),
                                                          style: TextStyle(
                                                              color: const Color(
                                                                  0xFFFFFFFF),
                                                              fontSize: MediaQuery
                                                                      .of(
                                                                          context)
                                                                  .textScaler
                                                                  .scale((screenHeight *
                                                                      (14.5 /
                                                                          AppConfig()
                                                                              .screenHeight))))),
                                                    )
                                                  ]),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                // newTest = !newTest;
                                                // if (oldTest) {
                                                //   oldTest = !oldTest;
                                                // }

                                                oldTest = false;
                                                newTest = true;

                                                oldTShadow = false;
                                                newTShadow = true;

                                                _chapterkey.currentState
                                                    ?.callReBuildWidget(
                                                        darkMode,
                                                        getLanguageCode,
                                                        oldTest,
                                                        newTest,
                                                        true);
                                              });
                                            },
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                  .textScaler
                                                  .scale(screenWidth *
                                                      (143 /
                                                          AppConfig()
                                                              .screenWidth)),
                                              height: MediaQuery.of(context)
                                                  .textScaler
                                                  .scale((screenHeight *
                                                      (40 /
                                                          AppConfig()
                                                              .screenHeight))),
                                              decoration: BoxDecoration(
                                                boxShadow: [
                                                  newTShadow
                                                      ? BoxShadow(
                                                          color: const Color(
                                                                  0xFFBE7C12)
                                                              .withOpacity(.9),
                                                          spreadRadius: 1,
                                                          blurRadius: 10,
                                                          blurStyle:
                                                              BlurStyle.outer)
                                                      : const BoxShadow(
                                                          color: Colors
                                                              .transparent)
                                                ],
                                                border: Border.all(
                                                    color: darkMode
                                                        ? const Color(
                                                            0xFFFFCA8C)
                                                        : const Color(
                                                            0xFF754003),
                                                    width: 1),
                                                color: Colors.transparent,
                                                borderRadius:
                                                    const BorderRadiusDirectional
                                                        .all(
                                                  Radius.circular(100),
                                                ),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  Text(
                                                    LanguageTextFile()
                                                        .bottomNavNewTestment(
                                                            getLanguageCode),
                                                    style: TextStyle(
                                                        color: darkMode
                                                            ? const Color(
                                                                0xFFFFCA8C)
                                                            : const Color(
                                                                0xFF754003),
                                                        fontSize: MediaQuery.of(
                                                                context)
                                                            .textScaler
                                                            .scale((screenHeight *
                                                                (12 /
                                                                    AppConfig()
                                                                        .screenHeight)))),
                                                  ),
                                                  CircleAvatar(
                                                    radius: MediaQuery.of(
                                                            context)
                                                        .textScaler
                                                        .scale((screenHeight *
                                                            (14.5 /
                                                                AppConfig()
                                                                    .screenHeight))),
                                                    backgroundColor: darkMode
                                                        ? const Color(
                                                            0xFF673602)
                                                        : const Color(
                                                            0xFFD69E0B),
                                                    child: Text(newT.toString(),
                                                        style: TextStyle(
                                                            color: const Color(
                                                                0xFFFFFFFF),
                                                            fontSize: MediaQuery
                                                                    .of(context)
                                                                .textScaler
                                                                .scale((screenHeight *
                                                                    (14 /
                                                                        AppConfig()
                                                                            .screenHeight))))),
                                                  )
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      !swippedDown
                                          ? Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                SizedBox(
                                                  height: (screenHeight *
                                                      (67 /
                                                          AppConfig()
                                                              .screenHeight)),
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          LanguageTextFile()
                                                              .bottomNavLanguageDropDown(
                                                                  getLanguageCode),
                                                          style: TextStyle(
                                                              color: darkMode
                                                                  ? const Color(
                                                                      0xFFFFCA8C)
                                                                  : const Color(
                                                                      0xFF754003),
                                                              fontSize: (screenHeight *
                                                                  (12 /
                                                                      AppConfig()
                                                                          .screenHeight))),
                                                        ),
                                                        FutureBuilder<
                                                                List<
                                                                    LanguagesAndTransilations>>(
                                                            future:
                                                                _languagesFuture,
                                                            builder: (context,
                                                                snapshot) {
                                                              if (snapshot.connectionState ==
                                                                  ConnectionState
                                                                      .waiting) {
                                                                return TextLoaderWidget(
                                                                    200,
                                                                    screenHeight *
                                                                        (20 /
                                                                            AppConfig()
                                                                                .screenHeight),
                                                                    screenHeight *
                                                                        (0 /
                                                                            AppConfig().screenHeight),
                                                                    darkMode);
                                                              } else if (snapshot
                                                                          .data ==
                                                                      null ||
                                                                  snapshot.data!
                                                                      .isEmpty ||
                                                                  snapshot
                                                                      .hasError) {
                                                                return TextLoaderWidget(
                                                                    200,
                                                                    screenHeight *
                                                                        (20 /
                                                                            AppConfig()
                                                                                .screenHeight),
                                                                    screenHeight *
                                                                        (0 /
                                                                            AppConfig().screenHeight),
                                                                    darkMode);
                                                              } else {
                                                                _selectedLanguage ??=
                                                                    snapshot
                                                                        .data!
                                                                        .first;
                                                                _selectedTranslations =
                                                                    _selectedLanguage!
                                                                        .translations;
                                                                return DropdownButtonHideUnderline(
                                                                  child: DropdownButton2<
                                                                      LanguagesAndTransilations>(
                                                                    isExpanded:
                                                                        true,
                                                                    hint: Row(
                                                                      children: [
                                                                        SizedBox(
                                                                          width:
                                                                              (screenWidth * (4 / AppConfig().screenWidth)),
                                                                        ),
                                                                        Expanded(
                                                                          child:
                                                                              Text(
                                                                            LanguageTextFile().bottomNavAll(getLanguageCode),
                                                                            style:
                                                                                TextStyle(
                                                                              fontSize: 12,
                                                                              color: darkMode ? const Color(0xFFFFFFFF) : Colors.black,
                                                                            ),
                                                                            overflow:
                                                                                TextOverflow.ellipsis,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    items: snapshot
                                                                        .data!
                                                                        .map((LanguagesAndTransilations
                                                                            value) {
                                                                      return DropdownMenuItem<
                                                                          LanguagesAndTransilations>(
                                                                        value:
                                                                            value,
                                                                        child:
                                                                            Text(
                                                                          value.language ??
                                                                              "",
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                (screenHeight * (12 / AppConfig().screenHeight)),
                                                                            color: darkMode
                                                                                ? const Color(0xFFFFFFFF)
                                                                                : Colors.black,
                                                                          ),
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                        ),
                                                                      );
                                                                    }).toList(),
                                                                    value:
                                                                        _selectedLanguage,
                                                                    onChanged:
                                                                        (LanguagesAndTransilations?
                                                                            newValue) {
                                                                      print(newValue!
                                                                          .language);

                                                                      changableLanguage =
                                                                          newValue
                                                                              .language!;
                                                                      print(
                                                                          "Selected language is ******** $changableLanguage");
                                                                      _selectedLanguage =
                                                                          newValue;
                                                                      _selectedTranslations =
                                                                          newValue
                                                                              .translations;
                                                                      userSelectedTranslation =
                                                                          null;

                                                                      _defaultShortName = _selectedLanguage!
                                                                          .translations!
                                                                          .first
                                                                          .shortName!;

                                                                      setState(
                                                                          () {
                                                                        oldTest =
                                                                            true;
                                                                        newTest =
                                                                            false;
                                                                        oldTShadow =
                                                                            true;
                                                                        newTShadow =
                                                                            false;
                                                                      });

                                                                      getBookDetails(
                                                                          _defaultShortName!);

                                                                      changableShortName =
                                                                          _defaultShortName!;

                                                                      _chapterkey.currentState?.callReBuildWidget(
                                                                          darkMode,
                                                                          getLanguageCode,
                                                                          oldTest,
                                                                          newTest,
                                                                          true);

                                                                      print(
                                                                          "Default shortname : $_defaultShortName");
                                                                    },
                                                                    buttonStyleData:
                                                                        ButtonStyleData(
                                                                      height: (screenHeight *
                                                                          (40 /
                                                                              AppConfig().screenHeight)),
                                                                      width: (screenWidth *
                                                                          (189 /
                                                                              AppConfig().screenWidth)),
                                                                      padding: const EdgeInsets
                                                                          .only(
                                                                          left:
                                                                              14,
                                                                          right:
                                                                              14),
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(0),
                                                                        border:
                                                                            Border.all(
                                                                          color: darkMode
                                                                              ? const Color(0xffFFCA8C)
                                                                              : Colors.black26,
                                                                        ),
                                                                        color: darkMode
                                                                            ? const Color(0xFF2D281E)
                                                                            : Colors.white,
                                                                      ),
                                                                      elevation:
                                                                          0,
                                                                    ),
                                                                    iconStyleData:
                                                                        IconStyleData(
                                                                      icon: SvgPicture.asset(
                                                                          color: darkMode
                                                                              ? const Color(0xffFFCA8C)
                                                                              : Colors.black26,
                                                                          "assets/svg/drop_down.svg"),
                                                                      iconSize:
                                                                          12,
                                                                      iconEnabledColor:
                                                                          Colors
                                                                              .black,
                                                                      iconDisabledColor:
                                                                          Colors
                                                                              .black,
                                                                    ),
                                                                    dropdownStyleData:
                                                                        DropdownStyleData(
                                                                      maxHeight:
                                                                          200,
                                                                      width: (screenWidth *
                                                                          (189 /
                                                                              AppConfig().screenWidth)),
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: darkMode
                                                                            ? const Color(0xFF2D281E)
                                                                            : Colors.white,
                                                                        borderRadius:
                                                                            BorderRadius.circular(0),
                                                                      ),
                                                                      offset:
                                                                          const Offset(
                                                                              0,
                                                                              -10),
                                                                    ),
                                                                    menuItemStyleData:
                                                                        const MenuItemStyleData(
                                                                      height:
                                                                          30,
                                                                      padding: EdgeInsets.only(
                                                                          left:
                                                                              20,
                                                                          right:
                                                                              14),
                                                                    ),
                                                                  ),
                                                                );
                                                              }
                                                            })
                                                      ],
                                                    ),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          LanguageTextFile()
                                                              .bottomNavEditionDropDown(
                                                                  getLanguageCode),
                                                          style: TextStyle(
                                                              color: darkMode
                                                                  ? const Color(
                                                                      0xFFFFCA8C)
                                                                  : const Color(
                                                                      0xFF754003),
                                                              fontSize: (screenHeight *
                                                                  (12 /
                                                                      AppConfig()
                                                                          .screenHeight))),
                                                        ),
                                                        if (_selectedTranslations !=
                                                            null)
                                                          DropdownButtonHideUnderline(
                                                            child:
                                                                DropdownButton2<
                                                                    Translations>(
                                                              isExpanded: true,
                                                              hint: Row(
                                                                children: [
                                                                  SizedBox(
                                                                    width: (screenWidth *
                                                                        (4 /
                                                                            AppConfig().screenWidth)),
                                                                  ),
                                                                  Expanded(
                                                                    child: Text(
                                                                      LanguageTextFile()
                                                                          .bottomNavAll(
                                                                              getLanguageCode),
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            (screenHeight *
                                                                                (12 / AppConfig().screenHeight)),
                                                                        color: darkMode
                                                                            ? const Color(0xFFFFFFFF)
                                                                            : Colors.black,
                                                                      ),
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              items: _selectedTranslations!
                                                                  .map((Translations
                                                                      value) {
                                                                return DropdownMenuItem<
                                                                    Translations>(
                                                                  value: value,
                                                                  child: Text(
                                                                    value.fullName ??
                                                                        '',
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          (screenHeight *
                                                                              (12 / AppConfig().screenHeight)),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: darkMode
                                                                          ? const Color(
                                                                              0xFFFFFFFF)
                                                                          : Colors
                                                                              .black,
                                                                    ),
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                  ),
                                                                );
                                                              }).toList(),
                                                              value: userSelectedTranslation ??
                                                                  _selectedTranslations!
                                                                      .first,
                                                              // Set the value directly
                                                              onChanged:
                                                                  (Translations?
                                                                      newValue) {
                                                                // setState(() {
                                                                // Update selected translation
                                                                // });
                                                                userSelectedTranslation =
                                                                    newValue;
                                                                setState(() {
                                                                  userSelectedTrans =
                                                                      newValue;
                                                                });

                                                                setState(() {
                                                                  oldTest =
                                                                      true;
                                                                  newTest =
                                                                      false;
                                                                  oldTShadow =
                                                                      true;
                                                                  newTShadow =
                                                                      false;
                                                                });
                                                                changableShortName =
                                                                    newValue!
                                                                        .shortName!;
                                                                getBookDetails(
                                                                    newValue
                                                                        .shortName!);
                                                                _chapterkey
                                                                    .currentState
                                                                    ?.callReBuildWidget(
                                                                        darkMode,
                                                                        getLanguageCode,
                                                                        oldTest,
                                                                        newTest,
                                                                        true); // Retrieve book details
                                                              },
                                                              buttonStyleData:
                                                                  ButtonStyleData(
                                                                height: (screenHeight *
                                                                    (40 /
                                                                        AppConfig()
                                                                            .screenHeight)),
                                                                width: (screenWidth *
                                                                    (189 /
                                                                        AppConfig()
                                                                            .screenWidth)),
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        left:
                                                                            14,
                                                                        right:
                                                                            14),
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              0),
                                                                  border: Border
                                                                      .all(
                                                                    color: darkMode
                                                                        ? const Color(
                                                                            0xffFFCA8C)
                                                                        : Colors
                                                                            .black26,
                                                                  ),
                                                                  color: darkMode
                                                                      ? const Color(
                                                                          0xFF2D281E)
                                                                      : Colors
                                                                          .white,
                                                                ),
                                                                elevation: 0,
                                                              ),
                                                              iconStyleData:
                                                                  IconStyleData(
                                                                icon: SvgPicture
                                                                    .asset(
                                                                  color: darkMode
                                                                      ? const Color(
                                                                          0xffFFCA8C)
                                                                      : Colors
                                                                          .black26,
                                                                  "assets/svg/drop_down.svg",
                                                                ),
                                                                iconSize: 14,
                                                                iconEnabledColor:
                                                                    Colors
                                                                        .green,
                                                                iconDisabledColor:
                                                                    Colors
                                                                        .black,
                                                              ),
                                                              dropdownStyleData:
                                                                  DropdownStyleData(
                                                                maxHeight: 200,
                                                                width: (screenWidth *
                                                                    (189 /
                                                                        AppConfig()
                                                                            .screenWidth)),
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: darkMode
                                                                      ? const Color(
                                                                          0xFF2D281E)
                                                                      : Colors
                                                                          .white,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              0),
                                                                ),
                                                                offset:
                                                                    const Offset(
                                                                        0, -10),
                                                              ),
                                                              menuItemStyleData:
                                                                  MenuItemStyleData(
                                                                height: (screenHeight *
                                                                    (30 /
                                                                        AppConfig()
                                                                            .screenHeight)),
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        left:
                                                                            20,
                                                                        right:
                                                                            14),
                                                              ),
                                                            ),
                                                          ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            )
                                          : const Text("")
                                    ],
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        swippedDown = !swippedDown;
                                      });
                                    },
                                    child: Column(
                                      children: [
                                        // SizedBox(
                                        //   height: (screenHeight *
                                        //       (39 / AppConfig().screenHeight)),
                                        // ),
                                        Stack(
                                          children: [
                                            !swippedDown
                                                ? const SizedBox()
                                                : SvgPicture.asset(
                                                    width:
                                                        (MediaQuery.of(context)
                                                            .size
                                                            .width),
                                                    "assets/svg/rectangle.svg"),
                                            !swippedDown
                                                ? const SizedBox()
                                                : Padding(
                                                    padding: EdgeInsets.symmetric(
                                                        horizontal: 0,
                                                        vertical: (screenHeight *
                                                            (4 /
                                                                AppConfig()
                                                                    .screenHeight))),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        SvgPicture.asset(
                                                            height: (screenHeight *
                                                                (11 /
                                                                    AppConfig()
                                                                        .screenHeight)),
                                                            width: (screenWidth *
                                                                (41 /
                                                                    AppConfig()
                                                                        .screenWidth)),
                                                            "assets/svg/swipe_down.svg"),
                                                      ],
                                                    ),
                                                  )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  swippedDown
                                      ? const SizedBox()
                                      : Expanded(
                                          child: Container(
                                            height: (screenHeight *
                                                (50 /
                                                    AppConfig().screenHeight)),
                                          ),
                                        ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        swippedDown = !swippedDown;
                                      });
                                    },
                                    child: Stack(
                                      children: [
                                        !swippedDown
                                            ? SvgPicture.asset(
                                                width: (MediaQuery.of(context)
                                                    .size
                                                    .width),
                                                "assets/svg/rectangle.svg")
                                            : const SizedBox(),
                                        !swippedDown
                                            ? Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 0,
                                                    vertical: (screenHeight *
                                                        (4 /
                                                            AppConfig()
                                                                .screenHeight))),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    SvgPicture.asset(
                                                      height: (screenHeight *
                                                          (11 /
                                                              AppConfig()
                                                                  .screenHeight)),
                                                      width: (screenWidth *
                                                          (41 /
                                                              AppConfig()
                                                                  .screenWidth)),
                                                      "assets/svg/swipe_up.svg",
                                                    ),
                                                  ],
                                                ),
                                              )
                                            : const SizedBox(),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            color: darkMode
                                ? const Color(0xFF000000)
                                : const Color(0xFFFFF7D8)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            swippedDown
                                ? Text(
                                    getLanguageCode == 'en'
                                        ? "Swipe down"
                                        : "नीचे ढकेलें",
                                    style: TextStyle(
                                      color: const Color(0xFF999999),
                                      fontSize: MediaQuery.of(context)
                                          .textScaler
                                          .scale((screenHeight *
                                              (10 / AppConfig().screenHeight))),
                                    ),
                                  )
                                : Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: (screenWidth *
                                          (170 / AppConfig().screenWidth)),
                                    ),
                                    child: Text(
                                      getLanguageCode == 'en'
                                          ? "Swipe up"
                                          : "ऊपर ढकेलें",
                                      style: TextStyle(
                                        color: const Color(0xFF999999),
                                        fontSize: MediaQuery.of(context)
                                            .textScaler
                                            .scale((screenHeight *
                                                (10 /
                                                    AppConfig().screenHeight))),
                                      ),
                                    ),
                                  ),
                          ],
                        ),
                      ),
                      screens[pageIndex],
                    ],
                  ),
                ),
                statusBarVisible
                    ? Container(
                        width: screenWidth,
                        height: statusBarHeight,
                        color: darkMode
                            ? AppConfig().chapterScreenBackgroundStartDarkColor
                            : AppConfig()
                                .chapterScreenBackgroundStartLightColor,
                      )
                    : const SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
