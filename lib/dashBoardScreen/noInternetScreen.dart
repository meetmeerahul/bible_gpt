import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../class/LanguageMethod.dart';
import '../class/theme_method.dart';
import '../config/app_config.dart';
import '../config/language_text_file.dart';
import '../reuseable/button/PrimaryButton.dart';
import '../widgets/check_internet_method.dart';
import '../widgets/toast_message.dart';

class NoInternetScreen extends StatefulWidget {
  const NoInternetScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return NoInternetPage();
  }
}

class NoInternetPage extends State<NoInternetScreen> {
  double screenWidth = 0;
  double screenHeight = 0;
  late bool darkMode;
  //late int getLanguageType;
  late String getLanguageCode;
  //String titleText = LanguageTextFile().getNoInternetScreenTitleText();
  // String contentText = LanguageTextFile().getNoInternetScreenContentText(getLanguageCode);
  // String retryButtonText =
  //     LanguageTextFile().getNoInternetScreenRetryButtonText(getLanguageCode);

  // futureFunctionMethod() async {
  //   SchedulerBinding.instance.addPostFrameCallback((_) async {
  //     titleTextFutureMethod = languageTranslatorMethod(
  //         getText: LanguageTextFile().getNoInternetScreenTitleText(),
  //         getLanguageCode: getLanguageCode);
  //     contentTextFutureMethod = languageTranslatorMethod(
  //         getText: LanguageTextFile().getNoInternetScreenContentText(),
  //         getLanguageCode: getLanguageCode);
  //     retryButtonTextFutureMethod = languageTranslatorMethod(
  //         getText: LanguageTextFile().getNoInternetScreenRetryButtonText(),
  //         getLanguageCode: getLanguageCode);
  //   });
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //darkMode = themeMethod(context);
    // futureFunctionMethod();
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    darkMode = themeMethod(context);

    getLanguageCode = languageMethod(context);
    AppConfig().getStatusBar(darkMode);
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          resizeToAvoidBottomInset: true,
          body: Container(
            width: screenWidth,
            height: screenHeight,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[
                  darkMode
                      ? AppConfig().signInScreenGradiantStartBackgroundDarkColor
                      : AppConfig()
                          .signInScreenGradiantStartBackgroundLightColor,
                  darkMode
                      ? AppConfig().signInScreenGradiantEndBackgroundDarkColor
                      : AppConfig().signInScreenGradiantEndBackgroundLightColor,
                ],
                tileMode: TileMode.mirror,
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    child: Icon(
                      Icons.wifi_off_rounded,
                      color: Colors.red,
                      size: screenHeight * (150 / AppConfig().screenHeight),
                    ),
                  ),
                  SizedBox(
                    height: screenHeight * (40 / AppConfig().screenHeight),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: screenWidth *
                            (AppConfig().logInEdittextLeftPadding /
                                AppConfig().screenWidth)),
                    
                    child: Text(
                      LanguageTextFile()
                          .getNoInternetScreenTitleText(getLanguageCode),
                      textScaler: const TextScaler.linear(1.0),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize:
                              screenHeight * (25 / AppConfig().screenHeight),
                          color: darkMode
                              ? AppConfig()
                                  .categoryDetailScreenTitleTextDarkColor
                              : AppConfig()
                                  .categoryDetailScreenTitleTextLightColor,
                          fontFamily: AppConfig().outfitFontSemiBold,
                          height: 0),
                      softWrap: true,
                    ),
                  ),
                  SizedBox(
                    height: screenHeight * (20 / AppConfig().screenHeight),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: screenWidth *
                            (AppConfig().logInEdittextLeftPadding *
                                3 /
                                AppConfig().screenWidth)),
                   
                    child: Text(
                      LanguageTextFile()
                          .getNoInternetScreenContentText(getLanguageCode),
                      textScaler: const TextScaler.linear(1.0),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize:
                              screenHeight * (15 / AppConfig().screenHeight),
                          color: darkMode
                              ? AppConfig()
                                  .categoryDetailScreenTitleTextDarkColor
                              : AppConfig()
                                  .categoryDetailScreenTitleTextLightColor,
                          fontFamily: AppConfig().outfitFontRegular,
                          height: 0),
                      softWrap: true,
                    ),
                  ),
                  SizedBox(
                    height: screenHeight * (40 / AppConfig().screenHeight),
                  ),
                  PrimaryButton(
                      screenWidth: screenWidth,
                      screenHeight: screenHeight,
                      buttonWidth: 130,
                      buttonHeight: AppConfig().signInScreenButtonHeight,
                      getDarkMode: false,
                      buttonText: LanguageTextFile()
                          .getNoInternetScreenRetryButtonText(getLanguageCode),
                    
                      getLanguageCode: getLanguageCode,
                      isAPILoading: false,
                      iconPath: null,
                      iconWidth: null,
                      iconHeight: null,
                      buttonPressedFunction: (isClicked) async {
                        if (isClicked) {
                          bool checkInternet =
                              await CheckInternetConnectionMethod();
                          print(checkInternet);
                          if (checkInternet) {
                            Navigator.pop(context, true);
                          } else {
                            ToastMessage(
                                screenHeight,
                                getLanguageCode == 'en'
                                    ? "Check your Internet connection"
                                    : "अपना इंटरनेट संपर्क जांचे",
                                false);
                          }
                        }
                      }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
