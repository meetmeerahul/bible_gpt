import 'dart:convert';
import 'dart:io';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:bible_gpt/APIRequest/api_handler.dart';
import 'package:bible_gpt/signInScreen/signinScreen.dart';
import 'package:bible_gpt/widgets/check_internet_method.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import '../class/change_language_local.dart';
import '../class/theme_method.dart';
import '../config/app_config.dart';
import '../config/language_text_file.dart';
import '../loader/widget/TextLoaderWidget.dart';
import '../reuseable/button/BackArrowWidget.dart';
import '../widgets/SpeakerWidget.dart';
import '../widgets/app_logo_widget.dart';
import '../widgets/background_color_widget.dart';
import '../widgets/search_gpt_text_field.dart';
import '../widgets/textWidget.dart';
import '../widgets/toast_message.dart';
import 'noInternetScreen.dart';

class GptScreen extends StatefulWidget {
  const GptScreen({super.key});

  @override
  State<GptScreen> createState() => _GptScreenState();
}

class _GptScreenState extends State<GptScreen> {
  double screenWidth = 0;
  double screenHeight = 0;
  double scaleFactor = 0;
  TextEditingController textEditingController = TextEditingController();
  late stt.SpeechToText _speech;
  bool isLoading = false;
  bool isListening = false;
  late bool darkMode;
  late ChangeLanguageLocal languageLocal;
  //late int getLanguageType;
  late String getLanguageCode;
  String searchResult = "";
  /*FlutterTts flutterTts = FlutterTts();
  int previousRunningLength = 0;
  int end = 0;

  TtsState ttsState = TtsState.stopped;

  get isPlaying => ttsState == TtsState.playing;
  get isStopped => ttsState == TtsState.stopped;
  get isPaused => ttsState == TtsState.paused;
  get isContinued => ttsState == TtsState.continued;

  bool get isIOS => !kIsWeb && Platform.isIOS;
  bool get isAndroid => !kIsWeb && Platform.isAndroid;
  bool get isWeb => kIsWeb
  bool bottomBar = false;*/
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  bool isAudioWidget = false;
  double positionDouble = 0;
  double durationDouble = 1;
  late PlayerState audioPlayerState;
  AudioPlayer player = AudioPlayer();
  late var activeSource;
  bool isAudioPlayerLoading = false;
  ScrollController textFieldScrollController = ScrollController();
  //Future<String>? searchResultFutureMethod;
  //Future<String>? timerPositionFutureMethod;
  String copyRightContentTextFuture = "© 2023 Copyright by Bible GPT";
  String searchGptHintText = "Tell us how can we help you";

  String formatTime(Duration getDuration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(getDuration.inHours);
    final minutes = twoDigits(getDuration.inMinutes.remainder(60));
    final seconds = twoDigits(getDuration.inSeconds.remainder(60));
    return [
      if (getDuration.inHours > 0) hours,
      minutes,
      seconds,
    ].join(":");
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

  callSearchGPTAPI(String getQuestion) async {
    setState(() {
      isLoading = true;
      searchResult = "";
      //bottomBar= false;
      isAudioWidget = false;
      player.stop();
      activeSource = null;
      textEditingController.text = "";
      //_stop();
    });
    bool internetConnectCheck = await CheckInternetConnectionMethod();
    if (internetConnectCheck) {
      var getSearchAPIResponse = await ApiHandler().searchGptAPI(
        getQuestion: getQuestion,
      );
      print(getSearchAPIResponse);
      if (getSearchAPIResponse["status"]) {
        HttpClientResponse getResponse = getSearchAPIResponse["data"];
        var content = await utf8.decodeStream(getResponse);
        print(content);
        setState(() {
          searchResult += content;
        });
        /*setState(() {
          searchResult = getSearchAPIResponse["result"];
        });*/
      } else {
        ToastMessage(screenHeight, getSearchAPIResponse["message"],
            getSearchAPIResponse["status"]);
      }
    } else {
      navigateToNoInternetScreen(false);
    }
    setState(() {
      isLoading = false;
    });
  }

  callInitState() async {
    bool internetConnectCheck = await CheckInternetConnectionMethod();
    if (internetConnectCheck) {
    } else {
      navigateToNoInternetScreen(true);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  loadInitialData() {
    languageLocal = Provider.of<ChangeLanguageLocal>(context);
    getLanguageCode = languageLocal.selectedLanguageCode!;
    _speech = stt.SpeechToText();
    print(getLanguageCode);
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    scaleFactor = MediaQuery.of(context).textScaleFactor;
    darkMode = themeMethod(context);
    loadInitialData();
    // getLanguageCode = languageMethod(context);
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
            resizeToAvoidBottomInset: false,
            body:
                // (copyRightContentTextFuture == null)
                //     ? const SizedBox()
                //     :
                Container(
              width: screenWidth,
              height: screenHeight,
              decoration:
                  BoxDecoration(color: darkMode ? Colors.black : Colors.white),
              child: Column(
                children: [
                  Container(
                    height: (screenHeight * (300 / AppConfig().screenHeight)),
                    width: screenWidth,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(darkMode
                              ? "assets/png/book_image_dark.png"
                              : "assets/png/book_image.png"),
                          fit: BoxFit.cover),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: screenHeight *
                              (AppConfig().gptScreenTopPadding /
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
                              Container(
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
                              AppLogoWidget(
                                  screenWidth,
                                  screenHeight,
                                  AppConfig().gptScreenAppLogoWidth,
                                  AppConfig().gptScreenAppLogoHeight,
                                  darkMode),
                              Container(
                                child: TextButton(
                                  onPressed: () {
                                    //navigateToSignInScreen();
                                    //checkUserLogIn();
                                  },
                                  style: TextButton.styleFrom(
                                    minimumSize: Size.zero,
                                    padding: EdgeInsets.zero,
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  child: Container(
                                    width: screenWidth *
                                        (AppConfig()
                                                .chapterScreenProfileIconWidth *
                                            2 /
                                            AppConfig().screenWidth),
                                    height: screenHeight *
                                        (AppConfig()
                                                .chapterScreenAppLogoHeight /
                                            AppConfig().screenHeight),
                                    alignment: Alignment.centerRight,
                                    child: SizedBox(
                                      width: screenWidth *
                                          (AppConfig()
                                                  .chapterScreenProfileIconWidth /
                                              AppConfig().screenWidth),
                                      height: screenWidth *
                                          (AppConfig()
                                                  .chapterScreenProfileIconWidth /
                                              AppConfig().screenWidth),
                                      child: InkWell(
                                        onTap: () => Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const SigninScreen())),
                                        child: SvgPicture.asset(
                                          color: const Color(0xFFAF6A06),
                                          darkMode
                                              ? AppConfig()
                                                  .chapterScreenProfileDarkIcon
                                              : AppConfig()
                                                  .chapterScreenProfileLightIcon,
                                          fit: BoxFit.scaleDown,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: screenHeight *
                              (AppConfig().gptScreenTopSearchPadding /
                                  AppConfig().screenHeight),
                        ),
                        Container(
                          child: SearchGptTextFieldWidget(
                              screenWidth: screenWidth,
                              screenHeight: screenHeight,
                              scaleFactor: scaleFactor,
                              getHintText: LanguageTextFile()
                                  .getSearchGPTWidgetHintText(getLanguageCode),
                              readOnly: false,
                              textEditingController: textEditingController,
                              isListening: isListening,
                              darkMode: darkMode,
                              backgroundOpacity:
                                  darkMode ? 0.4 : (Platform.isIOS ? 1 : 1),
                              getLanguageCode: getLanguageCode,
                              textScrollController: textFieldScrollController,
                              getEdittextFunction: (getText) {
                                setState(() {
                                  textEditingController.text = getText;
                                });
                              },
                              submitTextFunction: (getSubmitText) {
                                FocusManager.instance.primaryFocus?.unfocus();
                                setState(() {
                                  if (textEditingController.text.isNotEmpty) {
                                    isListening = false;
                                    _speech.stop();
                                    callSearchGPTAPI(
                                        textEditingController.text.toString());
                                  } else {
                                    ToastMessage(
                                        screenHeight,
                                        getLanguageCode == 'en'
                                            ? "Please enter in search field"
                                            : "कृपया खोज फ़ील्ड में दर्ज करें",
                                        false);
                                  }
                                });
                              },
                              getListeningFunction: (getListening) {
                                setState(() {
                                  if (textEditingController.text.isNotEmpty) {
                                    textEditingController.clear();
                                  } else {
                                    if (isListening) {
                                      isListening = false;
                                      _speech.stop();
                                    } else {
                                      isListening = true;

                                      Listen();
                                    }
                                  }
                                });
                              }),
                        ),
                        SizedBox(
                          height:
                              (screenHeight * (10 / AppConfig().screenHeight)),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: screenWidth *
                                  (AppConfig()
                                          .dashboardScreenBottomContentPadding /
                                      AppConfig().screenWidth)),
                          child: Text(
                            LanguageTextFile()
                                .getDashboardScreenBottomContentText(
                                    getLanguageCode),
                            textScaler: const TextScaler.linear(1.0),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: screenHeight *
                                    (AppConfig()
                                            .dashboardScreenBottomContentTextSize /
                                        AppConfig().screenHeight),
                                color: darkMode
                                    ? AppConfig()
                                        .dashboardScreenBottomContentTextDarkColor
                                    : AppConfig()
                                        .dashboardScreenBottomContentTextLightColor,
                                fontFamily: AppConfig().outfitFontRegular),
                            // textDirection: getLanguageType ==
                            //         AppConfig().languageSettingArabicLanguageCode
                            //     ? TextDirection.rtl
                            //     : TextDirection.ltr
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: SizedBox(
                        width: screenWidth,
                        // height: screenHeight -
                        //     (screenHeight * (300 / AppConfig().screenHeight)),

                        child: Padding(
                            padding: EdgeInsets.only(
                                top: (screenHeight *
                                    (20 / AppConfig().screenHeight))),
                            child: isLoading
                                ? Padding(
                                    padding: EdgeInsets.only(
                                      top: (screenHeight *
                                          (30 / AppConfig().screenHeight)),
                                      right: (screenWidth *
                                          (30 / AppConfig().screenWidth)),
                                      left: (screenWidth *
                                          (30 / AppConfig().screenWidth)),
                                    ),
                                    child: TextLoaderWidget(
                                        screenWidth,
                                        60,
                                        screenHeight *
                                            (AppConfig()
                                                    .gptScreenSearchResultTextSize /
                                                AppConfig().screenHeight),
                                        darkMode),
                                  )
                                : Padding(
                                    padding: EdgeInsets.only(
                                      top: (screenHeight *
                                          (30 / AppConfig().screenHeight)),
                                      right: (screenWidth *
                                          (30 / AppConfig().screenWidth)),
                                      left: (screenWidth *
                                          (30 / AppConfig().screenWidth)),
                                    ),
                                    child: AnimatedTextKit(
                                      animatedTexts: [
                                        TypewriterAnimatedText(
                                          textAlign: TextAlign.start,
                                          searchResult,
                                          textStyle: TextStyle(
                                            color: darkMode
                                                ? const Color(0xffffffff)
                                                : const Color(0xff0000000),
                                            fontSize: (screenHeight *
                                                (12 /
                                                    AppConfig().screenHeight)),
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                      totalRepeatCount: 1,
                                    ),
                                  )
                            // If not loading and text is empty, show nothing
                            ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  Listen() async {
    if (isListening) {
      print("recorded Started");
      bool available = await _speech.initialize(
        onError: (val) {
          print("error:$val");
          setState(() {
            isListening = false;
            //_speech.stop();
          });
        },
        onStatus: (val) {
          print("status:$val");
          if (val == "done") {
            print("status:$val");
            setState(() {
              isListening = false;
              //_speech.stop();
            });
          }
        },
      );
      if (available) {
        setState(() {
          isListening = true;
        });
        _speech.listen(onResult: (val) {
          setState(() {
            textEditingController.text = val.recognizedWords;
            textFieldScrollController
                .jumpTo(textFieldScrollController.position.maxScrollExtent);
          });
        });
      } else {
        setState(() {
          isListening = false;
          //_speech.stop();
        });
      }
    } else {
      setState(() {
        isListening = false;
        //_speech.stop();
      });
    }
  }
}

enum TtsState { playing, stopped, paused, continued }
