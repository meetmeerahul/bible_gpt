import 'dart:io';

import 'package:bible_gpt/class/theme_method.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../config/app_config.dart';
import '../config/language_text_file.dart';
import '../config/shared_preferences.dart';
import '../reuseable/button/BackArrowWidget.dart';
import '../reuseable/button/PrimaryButton.dart';
import '../widgets/background_color_widget.dart';
import '../widgets/check_internet_method.dart';
import '../widgets/login_textfield_widget.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  double screenWidth = 0;
  double screenHeight = 0;
  double scaleFactor = 0;
  double statusBarHeight = 0;
  bool statusBarVisible = false;
  late bool darkMode;
  ScrollController pageScrollController = ScrollController();

  TextEditingController fullNameController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  String profilePictureUrl = "";
  String? profileTitleFutureMethod;
  String? logOutTextFutureMethod;
  String? copyRightContentTextFutureMethod;

  String getLanguageCode = "en";

  navigateToNoInternetScreen(bool callInit) {
    // Navigator.push(context,
    //         MaterialPageRoute(builder: (context) => NoInternetScreen()))
    //     .then((value) {
    //   if (callInit) {
    //     callInitState();
    //   }
    // });
  }

  callInitState() async {
    bool internetConnectCheck = await CheckInternetConnectionMethod();
    if (internetConnectCheck) {
      //  futureFunctionMethod();
      //  getUserData();
    } else {
      navigateToNoInternetScreen(true);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    callInitState();
  }

  @override
  Widget build(BuildContext context) {
    statusBarHeight = MediaQuery.of(context).padding.top;
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    scaleFactor = MediaQuery.of(context).textScaleFactor;
    darkMode = themeMethod(context);
    //getLanguageCode = languageMethod(context);
    // AppConfig().getStatusBar(darkMode);
    return WillPopScope(
        onWillPop: Platform.isIOS
            ? null
            : () async {
                return true;
              },
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            resizeToAvoidBottomInset: true,
            body: SizedBox(
              width: screenWidth,
              height: screenHeight,
              child: Stack(
                children: [
                  BackgroundColorWidget(
                      screenWidth: screenWidth,
                      screenHeight: screenHeight,
                      getDarkMode: darkMode,
                      getLanguageCode: getLanguageCode,
                      imageWidget: true,
                      imageWidth: 312,
                      imageHeight: 218,
                      bottomImagePadding: AppConfig()
                          .signInScreenBackgroundImageCopyRightPadding,
                      bottomCopyRightsContentPadding:
                          AppConfig().signInScreenBottomCopyRightsPadding,
                      imageContentFuture: LanguageTextFile()
                          .getSignInScreenCopyRightText(getLanguageCode)),
                  SizedBox(
                    width: screenWidth,
                    height: screenHeight,
                    child: SingleChildScrollView(
                      controller: pageScrollController,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: screenHeight *
                                (AppConfig().settingScreenTopPadding /
                                    AppConfig().screenHeight),
                          ),
                          Container(
                            width: screenWidth,
                            padding: EdgeInsets.symmetric(
                                horizontal: screenWidth *
                                    (24 / AppConfig().screenWidth)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  child: BackArrowWidget(
                                      screenWidth: screenWidth,
                                      screenHeight: screenHeight,
                                      darkMode: darkMode,
                                      getCallBackFunction:
                                          (getCallBackFunction) {
                                        if (getCallBackFunction) {
                                          Navigator.pop(context);
                                        }
                                      }),
                                ),
                                Container(
                                  // child: languageFutureWidget(
                                  //     screenWidth: screenWidth,
                                  //     screenHeight: screenHeight,
                                  //     selectedLanguage: getLanguageCode,
                                  //     getLanguageTranslatorMethod:
                                  //         profileTitleFutureMethod,
                                  //     getFontSize: AppConfig()
                                  //         .settingScreenTitleTextSize,
                                  //     getDarkMode: darkMode,
                                  //     getTextAlign: TextAlign.center,
                                  //     getTextColor: darkMode
                                  //         ? AppConfig()
                                  //             .settingScreenTitleTextDarkColor
                                  //         : AppConfig()
                                  //             .settingScreenTitleTextLightColor,
                                  //     getFontFamily:
                                  //         AppConfig().outfitFontRegular,
                                  //     getTextDirection: LanguageTextFile()
                                  //         .getTextDirection(getLanguageCode),
                                  //     getSoftWrap: true),
                                  child: Text(
                                    LanguageTextFile()
                                        .getProfileScreenProfileTitleText(),
                                    textScaler: const TextScaler.linear(1.0),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: screenHeight *
                                            (AppConfig()
                                                    .settingScreenTitleTextSize /
                                                AppConfig().screenHeight),
                                        color: darkMode
                                            ? AppConfig()
                                                .settingScreenTitleTextDarkColor
                                            : AppConfig()
                                                .settingScreenTitleTextLightColor,
                                        fontFamily:
                                            AppConfig().outfitFontRegular),
                                    textDirection: LanguageTextFile()
                                        .getTextDirection(getLanguageCode),
                                  ),
                                ),
                                SizedBox(
                                  width: screenWidth *
                                      ((AppConfig().backArrowWidgetOuterWidth) /
                                          AppConfig().screenWidth),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: screenHeight *
                                (AppConfig().settingScreenTopLanguagePadding /
                                    AppConfig().screenHeight),
                          ),
                          Container(
                            width:
                                screenWidth * (100 / AppConfig().screenWidth),
                            height:
                                screenWidth * (100 / AppConfig().screenWidth),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF5E9C7),
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                  //color: Color(0xFFA36501),
                                  color: AppConfig()
                                      .bottomNavigationBarShadowColor
                                      .withOpacity(AppConfig()
                                          .bottomNavigationBarShadowOpacity),
                                  blurRadius: 0,
                                  blurStyle: BlurStyle.outer,
                                ),
                              ],
                              borderRadius: BorderRadius.all(Radius.circular(
                                  screenWidth *
                                      (100 / AppConfig().screenWidth))),
                            ),
                            child: profilePictureUrl == ""
                                ? Container(
                                    width: screenWidth *
                                        (32 / AppConfig().screenWidth),
                                    alignment: Alignment.center,
                                    child: SvgPicture.asset(
                                      AppConfig().chapterScreenProfileLightIcon,
                                      fit: BoxFit.fitWidth,
                                      color: const Color(0xFFA36501),
                                    ),
                                  )
                                : ClipRRect(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(screenWidth *
                                            (100 / AppConfig().screenWidth))),
                                    child: Image.network(
                                      profilePictureUrl,
                                      fit: BoxFit.scaleDown,
                                    ),
                                  ),
                          ),
                          SizedBox(
                            height:
                                screenHeight * (50 / AppConfig().screenHeight),
                          ),
                          LogInTextFieldWidget(
                              context,
                              screenWidth,
                              screenHeight,
                              scaleFactor,
                              AppConfig().logInWidgetEdittextWidth,
                              AppConfig().logInWidgetEdittextHeight,
                              fullNameController,
                              false,
                              false,
                              LanguageTextFile()
                                  .getProfileScreenFullNameHintText(),
                              TextInputAction.next,
                              TextInputType.name,
                              darkMode,
                              getLanguageCode,
                              true,
                              (getFirstName) {},
                              (getSelected) {}),
                          SizedBox(
                            height:
                                screenHeight * (40 / AppConfig().screenHeight),
                          ),
                          LogInTextFieldWidget(
                              context,
                              screenWidth,
                              screenHeight,
                              scaleFactor,
                              AppConfig().logInWidgetEdittextWidth,
                              AppConfig().logInWidgetEdittextHeight,
                              userNameController,
                              false,
                              false,
                              LanguageTextFile()
                                  .getProfileScreenUserNameHintText(),
                              TextInputAction.next,
                              TextInputType.text,
                              darkMode,
                              getLanguageCode,
                              true,
                              (getFirstName) {},
                              (getSelected) {}),
                          SizedBox(
                            height:
                                screenHeight * (65 / AppConfig().screenHeight),
                          ),
                          PrimaryButton(
                              screenWidth: screenWidth,
                              screenHeight: screenHeight,
                              buttonWidth: 130,
                              buttonHeight:
                                  AppConfig().signInScreenButtonHeight,
                              getDarkMode: false,
                              buttonText: LanguageTextFile()
                                  .getProfileScreenLogoutText(),
                              getLanguageCode: getLanguageCode,
                              isAPILoading: false,
                              iconPath: null,
                              iconWidth: null,
                              iconHeight: null,
                              buttonPressedFunction: (isClicked) {
                                print("2");
                                SharedPreference.instance
                                    .setUserToken("token", "");
                                SharedPreference.instance
                                    .setUserProfileDetail("user", {});
                                Navigator.pop(
                                    context, "User Logged out successfully");
                              }),
                        ],
                      ),
                    ),
                  ),
                  statusBarVisible
                      ? Container(
                          width: screenWidth,
                          height: statusBarHeight,
                          color: darkMode
                              ? AppConfig()
                                  .signInScreenGradiantStartBackgroundDarkColor
                              : AppConfig()
                                  .signInScreenGradiantStartBackgroundLightColor,
                        )
                      : const SizedBox()
                ],
              ),
            ),
          ),
        ));
  }
}
