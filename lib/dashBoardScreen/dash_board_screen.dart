import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:launch_review/launch_review.dart';
import 'package:provider/provider.dart';

import '../chapterScreen/bottomNavigationBarScreen.dart';
import '../chapterScreen/chapterScreen.dart';
import '../class/LanguageMethod.dart';
import '../class/change_language_local.dart';
import '../class/change_theme_local.dart';
import '../class/theme_method.dart';
import '../config/app_config.dart';
import '../config/changable.dart';
import '../config/language_text_file.dart';
import '../config/shared_preferences.dart';
import '../reuseable/button/PrimaryButton.dart';
import '../signInScreen/profile_page.dart';
import '../signInScreen/signinScreen.dart';
import '../signInScreen/webViewScreen.dart';
import '../widgets/MenuBarDrawer.dart';
import '../widgets/app_logo_widget.dart';
import '../widgets/background_color_widget.dart';
import '../widgets/check_internet_method.dart';
import '../widgets/search_gpt_text_field.dart';
import '../widgets/toast_message.dart';
import 'gptScreen.dart';
import 'noInternetScreen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late bool darkMode;

  double screenWidth = 0;
  double screenHeight = 0;
  double scaleFactor = 0;
  double statusBarHeight = 0;
  TextEditingController editingController = TextEditingController();

  late int getLanguageType;
  late String getSelectedLanguageCode;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String profilePictureUrl = "";
  String profileName = "Guest";
  //String getLanguageCode = "en";

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
  // String profileNameText;

  String copyRightContentTextFutureMethod = "© 2023 Copyright by Bible GPT";

  //String searchGptHintText = "Tell us how can we help you!";

  changeScreen(int getCurrentScreen) {
    setState(() {
      navigateToChapterScreen(getCurrentScreen);
    });
  }

  navigateToGPTScreen() {
    Navigator.push(
            context, MaterialPageRoute(builder: (context) => const GptScreen()))
        .then((value) {
      setState(() {});
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

  navigateToNoInternetScreen(bool callInit) {
    Navigator.push(context,
            MaterialPageRoute(builder: (context) => const NoInternetScreen()))
        .then((value) {
      if (callInit) {
        callInitState();
      }
    });
  }

  callInitState() async {
    bool internetConnectCheck = await CheckInternetConnectionMethod();

    setState(() {
      changableLanguage = "English";
    });
    if (internetConnectCheck) {
      futureFunctionMethod();
      getUserData();
    } else {
      print("No internet");
      navigateToNoInternetScreen(true);
    }
  }

  navigateToWebViewScreen(String getWebViewUrl, String getWebViewTitle) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => webViewScreen(
                webViewUrl: getWebViewUrl,
                webViewTitle: getWebViewTitle))).then((value) {});
  }

  callSocialMediaClick(int getSelectedSocialMedia) {
    if (getSelectedSocialMedia == 1) {
      print("Youtube Click");
    } else if (getSelectedSocialMedia == 2) {
      print("Facebook Click");
      navigateToWebViewScreen(AppConfig().facebookLink, "");
    } else if (getSelectedSocialMedia == 3) {
      print("Twitter Click");
      navigateToWebViewScreen(AppConfig().twitterLink, "");
    } else {
      navigateToWebViewScreen(AppConfig().instagramLink, "");
      print("Instagram Click");
    }
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

  callDeleteAccountAPI(String getToken) async {
    setState(() {
      isDeleteAPILoading = true;
    });
    bool internetConnectCheck = await CheckInternetConnectionMethod();

    if (internetConnectCheck) {
      //   var getDeleteAccountAPIResponse = await AllAPIMethod().deleteAccountAPI(
      //     getToken: getToken,
      //   );
      //   print(getDeleteAccountAPIResponse);
      //   if (getDeleteAccountAPIResponse["status"]) {
      //     String getResponseMessage = getDeleteAccountAPIResponse["message"];
      //     logOutUser(getResponseMessage);
      //   } else {
      //     ToastMessage(screenHeight, getDeleteAccountAPIResponse["message"],
      //         getDeleteAccountAPIResponse["status"]);
      //   }
      // } else {
      //   navigateToNoInternetScreen(false);
      // }
      setState(() {
        isDeleteAPILoading = false;
      });
    }
  }

  navigateToStore() {
    LaunchReview.launch(
      androidAppId: AppConfig().googleStoreId,
      iOSAppId: AppConfig().appleStoreId,
    );
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

  checkUserLogIn() async {
    String getToken = await SharedPreference.instance.getUserToken('token');
    if (getToken == "") {
      navigateToSignInScreen();
    } else {
      navigateToProfileScreen();
    }
  }

  callSettingControl(int getSelectedSetting) {
    setState(() {
      if (getSelectedSetting == 2) {
        changeTheme();
      } else if (getSelectedSetting == 3) {
        navigateToWebViewScreen(
            AppConfig().aboutUsUrl,
            LanguageTextFile()
                .getLanguageSettingTermPrivacyText(getSelectedLanguageCode));
      } else if (getSelectedSetting == 4) {
        navigateToWebViewScreen(
            AppConfig().contactUsUrl,
            LanguageTextFile()
                .getLanguageSettingContactText(getSelectedLanguageCode));
      } else if (getSelectedSetting == 5) {
        navigateToStore();
      } else if (getSelectedSetting == 6) {
        //callDeleteAccountAPI(getToken);
      }
    });
  }

  languageChange(String getLanguageCode) {
    setState(() {
      print("Selected language : $getLanguageCode");
      getSelectedLanguageCode = getLanguageCode;
      /*for(int i = 0 ; i < getLanguageClassList.length; i++){
        if(getLanguageClassList[i].languageId==getLanguage){
          getLanguageClassList[i].languageSelected = true;
          selectedLanguage = getLanguageClassList[i].languageName;
        }
        else{
          getLanguageClassList[i].languageSelected = false;
        }
      }*/
    });
  }

  initialData() {
    setState(() {
      languageLocal = Provider.of<ChangeLanguageLocal>(context);
      print("Initial data");
      getSelectedLanguageCode = languageLocal.selectedLanguageCode!;
      print("Selected language is ${languageLocal.selectedLanguageCode}");
      //  getLanguageCode = languageMethod(context);
      //getLanguageClassList.clear();
      //getLanguageClassList.add(LanguageClass(languageId: AppConfig().languageSettingEnglishLanguageCode, languageName: LanguageTextFile().getLanguageSettingLanguageNameEnglishText(getLanguageType), languageDropDownName: LanguageTextFile().getLanguageSettingLanguageDropdownEnglishText(getLanguageType), languageSelected: false));
      //getLanguageClassList.add(LanguageClass(languageId: AppConfig().languageSettingArabicLanguageCode, languageName: LanguageTextFile().getLanguageSettingLanguageNameArabicText(getLanguageType), languageDropDownName: LanguageTextFile().getLanguageSettingLanguageDropdownArabicText(getLanguageType), languageSelected: false));
      languageChange(getSelectedLanguageCode);
      bottomNavigationChapterText = LanguageTextFile()
          .getBottomNavigationChapterText(getSelectedLanguageCode);
    });
  }

  futureFunctionMethod() async {
    getSelectedLanguageCode =
        await SharedPreference.instance.getSelectedLanguage("language");
    print("get lang : $getSelectedLanguageCode");

    // bottomContentFutureMethod = languageTranslatorMethod(
    //     getText: LanguageTextFile().getDashboardScreenBottomContentText(),
    //     getLanguageCode: getSelectedLanguageCode);
    // chapterTextFutureMethod = languageTranslatorMethod(
    //     getText: LanguageTextFile().getDashboardScreenChapterText(),
    //     getLanguageCode: getSelectedLanguageCode);
    // copyRightContentTextFutureMethod = languageTranslatorMethod(
    //     getText: LanguageTextFile().getDashboardScreenCopyRightText(),
    //     getLanguageCode: getSelectedLanguageCode);
    // bottomNavigationChapterTextFuture = languageTranslatorMethod(
    //     getText: LanguageTextFile().getBottomNavigationChapterText(),
    //     getLanguageCode: getSelectedLanguageCode);
    // profileNameTextFuture = languageTranslatorMethod(
    //     getText: profileName, getLanguageCode: getSelectedLanguageCode);
    // searchGptHintText = await languageTranslatorMethod(
    //     getText: LanguageTextFile().getSearchGPTWidgetHintText(),
    //     getLanguageCode: getSelectedLanguageCode);
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    callInitState();
    //  print(" in init $getSelectedLanguageCode");
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    scaleFactor = MediaQuery.of(context).textScaleFactor;
    statusBarHeight = MediaQuery.of(context).padding.top;
    theme = Provider.of<ChangeThemeLocal>(context);
    darkMode = themeMethod(context);
    themeChange();
    initialData();

    print(darkMode);
    //print(getSelectedLanguageCode);
    return WillPopScope(
      onWillPop: () async {
        if (_scaffoldKey.currentState!.isEndDrawerOpen) {
          _scaffoldKey.currentState!.closeEndDrawer();
          return false;
        }
        return true;
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          key: _scaffoldKey,
          endDrawer: MenuBarDrawer(
            context: context,
            screenWidth: screenWidth,
            screenHeight: screenHeight,
            statusBarHeight: statusBarHeight,
            getDarkMode: darkMode,
            getLanguageCode: getSelectedLanguageCode,
            profilePictureUrl: profilePictureUrl,
            profileName: profileName,
            currentCategory: 1,
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
              // callSocialMediaClick(getSocialMedia);
            },
            callBackSelectedCategory: (int getSelectedCategory) {
              _scaffoldKey.currentState!.closeEndDrawer();
              changeScreen(getSelectedCategory);
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
          body: SizedBox(
            width: screenWidth,
            height: screenHeight,
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                BackgroundColorWidget(
                    context: context,
                    screenWidth: screenWidth,
                    screenHeight: screenHeight,
                    getDarkMode: darkMode,
                    getLanguageCode: getSelectedLanguageCode,
                    imageWidget: true,
                    imageWidth: 400,
                    imageHeight: 280,
                    bottomImagePadding: 30,
                    bottomCopyRightsContentPadding: 34,
                    imageContentFuture: LanguageTextFile()
                        .getBottomNavigationContentText(
                            getSelectedLanguageCode)),
                SizedBox(
                  width: screenWidth,
                  height: screenHeight,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: screenHeight *
                            (AppConfig().dashboardScreenTopPadding /
                                AppConfig().screenHeight),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal:
                                screenWidth * (24 / AppConfig().screenWidth)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              child: TextButton(
                                onPressed: () {
                                  navigateToSignInScreen();
                                  checkUserLogIn();
                                  // print("Pressed drawer");
                                },
                                style: TextButton.styleFrom(
                                  minimumSize: Size.zero,
                                  padding: EdgeInsets.zero,
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: Container(
                                  width: screenWidth *
                                      (31 / AppConfig().screenWidth),
                                  height: screenWidth *
                                      (31 / AppConfig().screenWidth),
                                  alignment: Alignment.centerLeft,
                                  child: SvgPicture.asset(
                                    color: const Color(0xFFAF6A06),
                                    darkMode
                                        ? AppConfig()
                                            .chapterScreenProfileDarkIcon
                                        : AppConfig()
                                            .chapterScreenProfileLightIcon,
                                    fit: BoxFit.scaleDown,
                                    width: screenWidth *
                                        (21 / AppConfig().screenWidth),
                                    height: screenWidth *
                                        (21 / AppConfig().screenWidth),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              child: TextButton(
                                onPressed: () {
                                  // navigateToSignInScreen();
                                  checkUserLogIn();
                                  _scaffoldKey.currentState!.openEndDrawer();
                                },
                                style: TextButton.styleFrom(
                                  minimumSize: Size.zero,
                                  padding: EdgeInsets.zero,
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: Container(
                                  width: screenWidth *
                                      (31 / AppConfig().screenWidth),
                                  height: screenWidth *
                                      (31 / AppConfig().screenWidth),
                                  alignment: Alignment.centerRight,
                                  child: SvgPicture.asset(
                                    color: const Color(0xFFAF6A06),
                                    darkMode
                                        ? AppConfig().chapterScreenMenuIconDark
                                        : AppConfig()
                                            .chapterScreenMenuIconLight,
                                    fit: BoxFit.scaleDown,
                                    width: screenWidth *
                                        (21 / AppConfig().screenWidth),
                                    height: screenWidth *
                                        (21 / AppConfig().screenWidth),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: screenHeight *
                            (AppConfig().dashboardScreenTopAppLogoPadding /
                                AppConfig().screenHeight),
                      ),
                      AppLogoWidget(
                          screenWidth,
                          screenHeight,
                          AppConfig().dashboardScreenAppLogoWidth,
                          AppConfig().dashboardScreenAppLogoHeight,
                          darkMode),
                      SizedBox(
                        height: screenHeight * (30 / AppConfig().screenHeight),
                      ),
                      SearchGptTextFieldWidget(
                          context: context,
                          screenWidth: screenWidth,
                          screenHeight: screenHeight,
                          scaleFactor: scaleFactor,
                          getHintText: LanguageTextFile()
                              .getSearchGPTWidgetHintText(
                                  getSelectedLanguageCode),
                          readOnly: true,
                          textEditingController: editingController,
                          isListening: false,
                          darkMode: darkMode,
                          backgroundOpacity:
                              darkMode ? 0.4 : (Platform.isIOS ? 1 : 1),
                          getLanguageCode: getSelectedLanguageCode,
                          textScrollController: null,
                          getEdittextFunction: (p0) => null,
                          submitTextFunction: (get) {
                            navigateToGPTScreen();
                          },
                          getListeningFunction: (getResult) {
                            navigateToGPTScreen();
                          }),
                      SizedBox(
                        height: screenHeight * (16 / AppConfig().screenHeight),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: screenWidth *
                                (AppConfig().chapterScreenLeftPadding *
                                    2 /
                                    AppConfig().screenWidth)),
                        child: Text(
                          LanguageTextFile()
                              .getDashboardScreenBottomContentText(
                                  getSelectedLanguageCode),
                          textScaler: const TextScaler.linear(1.0),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: MediaQuery.of(context).textScaler.scale(
                                    screenHeight *
                                        (AppConfig()
                                                .chapterScreenContentTextSize /
                                            AppConfig().screenHeight),
                                  ),
                              color: darkMode
                                  ? AppConfig()
                                      .chapterScreenContentTextDarkColor
                                  : AppConfig()
                                      .chapterScreenContentTextLightColor,
                              fontFamily: AppConfig().outfitFontRegular),
                          textDirection: LanguageTextFile()
                              .getTextDirection(getSelectedLanguageCode),
                        ),
                      ),
                      SizedBox(
                        height: screenHeight *
                            (AppConfig().dashboardScreenTopCategoryPadding /
                                AppConfig().screenHeight),
                      ),
                      PrimaryButton(
                          context: context,
                          screenWidth: screenWidth,
                          screenHeight: screenHeight,
                          buttonWidth:
                              AppConfig().dashboardScreenCategoryBorderWidth,
                          buttonHeight:
                              AppConfig().dashboardScreenCategoryBorderHeight,
                          buttonText: LanguageTextFile()
                              .getDashboardButtonText(getSelectedLanguageCode),
                          getDarkMode: darkMode,
                          getLanguageCode: getSelectedLanguageCode,
                          isAPILoading: false,
                          iconPath: null,
                          iconWidth: null,
                          iconHeight: null,
                          buttonPressedFunction: (isClicked) {
                            setState(() {
                              changableLanguage = "English";
                            });
                            print("1");
                            navigateToChapterScreen(0);
                          }),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
