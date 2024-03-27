import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../class/LanguageMethod.dart';
import '../class/theme_method.dart';
import '../config/app_config.dart';
import '../config/language_text_file.dart';
import '../config/shared_preferences.dart';
import '../dashBoardScreen/noInternetScreen.dart';
import '../loader/widget/TextLoaderWidget.dart';
import '../reuseable/button/BackArrowWidget.dart';
import '../widgets/check_internet_method.dart';
import '../widgets/toast_message.dart';

//import 'package:webview_flutter_android/webview_flutter_android.dart';
// Import for iOS features.
//import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

// #enddocregion platform_imports

class webViewScreen extends StatefulWidget {
  final String webViewUrl;
  final String webViewTitle;
  const webViewScreen({
    super.key,
    required this.webViewUrl,
    required this.webViewTitle,
  });

  @override
  State<StatefulWidget> createState() {
    return webViewPage(
      webViewUrl: webViewUrl,
      webViewTitle: webViewTitle,
    );
  }
}

class webViewPage extends State<webViewScreen> {
  final String webViewUrl;
  final String webViewTitle;
  webViewPage({
    Key? key,
    required this.webViewUrl,
    required this.webViewTitle,
  });
  double screenWidth = 0;
  double screenHeight = 0;
  bool switchValue = false;
  //String webViewUrl = "https://flutter.dev/?gclid=Cj0KCQiAmNeqBhD4ARIsADsYfTeMnco904dYnHIT3W_k4sw2NBbTcVZ_NHh_99_IxPHSzUq6NAP-lVQaAse4EALw_wcB&gclsrc=aw.ds";
  late final WebViewController _controller;
  late bool darkMode;
  //late int getLanguageType;
  late String getLanguageCode;
  bool isLoading = true;
  //late Future<
  String webPageTitleFutureMethod = "Web View";

  navigateToNoInternetScreen(bool callInit) {
    Navigator.push(context,
            MaterialPageRoute(builder: (context) => const NoInternetScreen()))
        .then((value) {
      if (callInit) {
        callInitState();
      }
    });
  }

  initialize() async {
    if ((webViewUrl.startsWith(AppConfig().facebookLink))) {
      await _launchURL(webViewUrl);
    } else {
      print("url : $webViewUrl");
      _controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(const Color(0x00000000))
        ..setNavigationDelegate(
          NavigationDelegate(
            onNavigationRequest: (NavigationRequest request) async {
              print("navigate request : ${request.url}");
              if (request.url.startsWith(AppConfig().facebookLink)) {
                // Handle the redirect if necessary
                print("redirect url");

                return NavigationDecision.prevent;
              }
              return NavigationDecision.navigate;
            },
            onProgress: (int progress) {
              // Update loading bar.
              print("loading");
            },
            onPageStarted: (String url) {},
            onPageFinished: (String url) {
              setState(() {
                isLoading = false;
                if (webViewTitle ==
                        LanguageTextFile()
                            .getLanguageSettingTermPrivacyText(url) ||
                    webViewTitle ==
                        LanguageTextFile().getLanguageSettingContactText(url)) {
                  _controller.runJavaScript(
                      "document.getElementsByClassName('navbar navbar-expand-lg fixed-top')[0].style.display='none';");
                }
              });
              print("page finished");
            },
            onWebResourceError: (WebResourceError error) {
              print(
                  "error: ${error.description} ,code : ${error.errorCode}, type : ${error.errorType},url : ${error.url}");
              ToastMessage(screenHeight, error.description, false);
            },
          ),
        )
        ..loadRequest(Uri.parse(webViewUrl));
    }
  }

  _launchURL(String url) async {
    print("URL: $url");
    if (await canLaunch(url)) {
      await launch(url);
      Navigator.pop(context);
    } else {
      throw 'Could not launch $url';
    }
  }

  futureFunctionMethod() async {
    getLanguageCode =
        await SharedPreference.instance.getSelectedLanguage("language");
    // print("get lang : $getLanguageCode");
    // webPageTitleFutureMethod = languageTranslatorMethod(
    //     getText: webViewTitle, getLanguageCode: getLanguageCode);
    // setState(() {});
  }

  callInitState() async {
    bool internetConnectCheck = await CheckInternetConnectionMethod();
    if (internetConnectCheck) {
      futureFunctionMethod();
      initialize();
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
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    darkMode = themeMethod(context);
    getLanguageCode = languageMethod(context);
    AppConfig().getStatusBar(darkMode);
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
          body: (webPageTitleFutureMethod == null)
              ? const SizedBox()
              : Container(
                  width: screenWidth,
                  height: screenHeight,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: <Color>[
                        darkMode
                            ? AppConfig().termUseScreenBackgroundStartDarkColor
                            : AppConfig()
                                .termUseScreenBackgroundStartLightColor,
                        darkMode
                            ? AppConfig().termUseScreenBackgroundEndDarkColor
                            : AppConfig().termUseScreenBackgroundEndLightColor,
                      ],
                      tileMode: TileMode.mirror,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: screenHeight *
                            (AppConfig().termUseScreenTopPadding /
                                AppConfig().screenHeight),
                      ),
                      Container(
                        width: screenWidth,
                        padding: EdgeInsets.symmetric(
                            horizontal:
                                screenWidth * (24 / AppConfig().screenWidth)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: screenWidth *
                                  ((AppConfig().backArrowWidgetOuterWidth +
                                          AppConfig()
                                              .backArrowWidgetLeftPadding +
                                          AppConfig()
                                              .backArrowWidgetLeftPadding) /
                                      AppConfig().screenWidth),
                              child: BackArrowWidget(
                                  screenWidth: screenWidth,
                                  screenHeight: screenHeight,
                                  darkMode: darkMode,
                                  getCallBackFunction: (getCallBackFunction) {
                                    if (getCallBackFunction) {
                                      Navigator.pop(context);
                                    }
                                  }),
                            ),
                            Container(
                              //width: screenWidth,
                              //padding: EdgeInsets.symmetric(horizontal: screenWidth*(AppConfig().termUseScreenLeftPadding/AppConfig().screenWidth)),
                              //width: screenWidth - (screenWidth*((AppConfig().backArrowWidgetOuterWidth+AppConfig().backArrowWidgetLeftPadding+AppConfig().backArrowWidgetLeftPadding)/AppConfig().screenWidth))*2,
                              // child: languageFutureWidget(
                              //     screenWidth: screenWidth,
                              //     screenHeight: screenHeight,
                              //     selectedLanguage: getLanguageCode,
                              //     getLanguageTranslatorMethod:
                              //         webPageTitleFutureMethod,
                              //     getFontSize:
                              //         AppConfig().termUseScreenTitleTextSize,
                              //     getDarkMode: darkMode,
                              //     getTextAlign: TextAlign.center,
                              //     getTextColor: darkMode
                              //         ? AppConfig()
                              //             .termUseScreenTitleTextDarkColor
                              //         : AppConfig()
                              //             .termUseScreenTitleTextLightColor,
                              //     getFontFamily: AppConfig().outfitFontRegular,
                              //     getTextDirection: LanguageTextFile()
                              //         .getTextDirection(getLanguageCode),
                              //     getSoftWrap: true),
                              child: Text(webViewTitle,
                                  textScaler: const TextScaler.linear(1.0),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: screenHeight *
                                          (AppConfig()
                                                  .termUseScreenTitleTextSize /
                                              AppConfig().screenHeight),
                                      color: darkMode
                                          ? AppConfig()
                                              .termUseScreenTitleTextDarkColor
                                          : AppConfig()
                                              .termUseScreenTitleTextLightColor,
                                      fontFamily:
                                          AppConfig().outfitFontRegular),
                                  textDirection: LanguageTextFile()
                                      .getTextDirection(getLanguageCode)),
                            ),
                            SizedBox(
                              width: screenWidth *
                                  ((AppConfig().backArrowWidgetOuterWidth +
                                          AppConfig()
                                              .backArrowWidgetLeftPadding +
                                          AppConfig()
                                              .backArrowWidgetLeftPadding) /
                                      AppConfig().screenWidth),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: screenHeight *
                            (AppConfig().termUseScreenTopLanguagePadding /
                                AppConfig().screenHeight),
                      ),
                      isLoading
                          ? TextLoaderWidget(
                              screenWidth, screenHeight * 0.75, 0, darkMode)
                          : Expanded(
                              child: SizedBox(
                                width: screenWidth,
                                child: WebViewWidget(controller: _controller),
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
