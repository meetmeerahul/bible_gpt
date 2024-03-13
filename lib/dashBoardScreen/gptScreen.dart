import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:bible_gpt/signInScreen/signinScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

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
  //late int getLanguageType;
  String getLanguageCode = "en";
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

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    scaleFactor = MediaQuery.of(context).textScaleFactor;
    darkMode = themeMethod(context);
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
              SizedBox(
            width: screenWidth,
            height: screenHeight,
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: darkMode ? Colors.black : Colors.white),
                ),
                Image(
                    image: AssetImage(darkMode
                        ? "assets/png/book_image_dark.png"
                        : "assets/png/book_image.png")),
                SizedBox(
                  width: screenWidth,
                  height: screenHeight,
                  child: SingleChildScrollView(
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
                              getHintText: searchGptHintText,
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
                                  // if (textEditingController.text.isNotEmpty) {
                                  //   callSearchGPTAPI(
                                  //       textEditingController.text.toString());
                                  // } else {
                                  ToastMessage(screenHeight,
                                      "Please enter in search field", false);
                                  //}
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
                          /*    child: languageFutureWidget(
                            screenWidth: screenWidth,
                            screenHeight: screenHeight,
                            selectedLanguage: getSelectedLanguageCode,
                            getLanguageTranslatorMethod: bottomContentFutureMethod,
                            getFontSize:
                                AppConfig().dashboardScreenBottomContentTextSize,
                            getDarkMode: darkMode,
                            getTextAlign: TextAlign.center,
                            getTextColor: darkMode
                                ? AppConfig()
                                    .dashboardScreenBottomContentTextDarkColor
                                : AppConfig()
                                    .dashboardScreenBottomContentTextLightColor,
                            getFontFamily: AppConfig().outfitFontRegular,
                            getTextDirection: LanguageTextFile()
                                .getTextDirection(getSelectedLanguageCode),
                            getSoftWrap: true),*/

                          //child:languageFutureWidget(screenWidth: screenWidth, screenHeight: screenHeight, selectedLanguage: getSelectedLanguageCode, getText: LanguageTextFile().getDashboardScreenBottomContentText(0), getTextStyle: TextStyle(fontSize: screenHeight*(AppConfig().dashboardScreenBottomContentTextSize/AppConfig().screenHeight),color: darkMode?AppConfig().dashboardScreenBottomContentTextDarkColor:AppConfig().dashboardScreenBottomContentTextLightColor,fontFamily: AppConfig().outfitFontRegular)),
                          child: Text(
                            LanguageTextFile()
                                .getDashboardScreenBottomContentText(),
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
                        isLoading
                            ? SizedBox(
                                height: screenHeight *
                                    (AppConfig()
                                            .gptScreenTopSearchResultPadding /
                                        AppConfig().screenHeight),
                              )
                            : const SizedBox(),
                        isLoading
                            ? Container(
                                width: screenWidth,
                                margin: EdgeInsets.symmetric(
                                    horizontal: screenWidth *
                                        (AppConfig()
                                                .gptScreenSearchResultLeftPadding /
                                            AppConfig().screenWidth)),
                                decoration: BoxDecoration(
                                  color: darkMode
                                      ? AppConfig()
                                          .gptScreenSearchResultBackgroundDarkColor
                                      : AppConfig()
                                          .gptScreenSearchResultBackgroundLightColor,
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(screenWidth *
                                          (AppConfig()
                                              .gptScreenSearchResultCornerRadius) /
                                          AppConfig().screenWidth)),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: screenHeight *
                                          (AppConfig()
                                                  .gptScreenSearchResultInnerTopPadding /
                                              AppConfig().screenHeight),
                                      horizontal: screenWidth *
                                          (AppConfig()
                                                  .gptScreenSearchResultInnerLeftPadding /
                                              AppConfig().screenWidth)),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      TextLoaderWidget(
                                          screenWidth,
                                          screenHeight *
                                              (AppConfig()
                                                      .gptScreenSearchResultTextSize /
                                                  AppConfig().screenHeight),
                                          screenHeight *
                                              (AppConfig()
                                                      .gptScreenSearchResultTextSize /
                                                  AppConfig().screenHeight),
                                          darkMode),
                                      SizedBox(
                                        height: screenHeight *
                                            (7 / AppConfig().screenHeight),
                                      ),
                                      TextLoaderWidget(
                                          screenWidth,
                                          screenHeight *
                                              (AppConfig()
                                                      .gptScreenSearchResultTextSize /
                                                  AppConfig().screenHeight),
                                          screenHeight *
                                              (AppConfig()
                                                      .gptScreenSearchResultTextSize /
                                                  AppConfig().screenHeight),
                                          darkMode),
                                      SizedBox(
                                        height: screenHeight *
                                            (7 / AppConfig().screenHeight),
                                      ),
                                      TextLoaderWidget(
                                          screenWidth,
                                          screenHeight *
                                              (AppConfig()
                                                      .gptScreenSearchResultTextSize /
                                                  AppConfig().screenHeight),
                                          screenHeight *
                                              (AppConfig()
                                                      .gptScreenSearchResultTextSize /
                                                  AppConfig().screenHeight),
                                          darkMode),
                                      SizedBox(
                                        height: screenHeight *
                                            (7 / AppConfig().screenHeight),
                                      ),
                                      TextLoaderWidget(
                                          screenWidth,
                                          screenHeight *
                                              (AppConfig()
                                                      .gptScreenSearchResultTextSize /
                                                  AppConfig().screenHeight),
                                          screenHeight *
                                              (AppConfig()
                                                      .gptScreenSearchResultTextSize /
                                                  AppConfig().screenHeight),
                                          darkMode),
                                      SizedBox(
                                        height: screenHeight *
                                            (7 / AppConfig().screenHeight),
                                      ),
                                      TextLoaderWidget(
                                          screenWidth * 0.5,
                                          screenHeight *
                                              (AppConfig()
                                                      .gptScreenSearchResultTextSize /
                                                  AppConfig().screenHeight),
                                          screenHeight *
                                              (AppConfig()
                                                      .gptScreenSearchResultTextSize /
                                                  AppConfig().screenHeight),
                                          darkMode),
                                    ],
                                  ),
                                ),
                              )
                            : searchResult == ""
                                ? const SizedBox()
                                : Stack(
                                    alignment: Alignment.topCenter,
                                    children: [
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            height: screenHeight *
                                                (AppConfig()
                                                        .gptScreenTopSearchResultPadding /
                                                    AppConfig().screenHeight),
                                          ),
                                          Container(
                                            width: screenWidth,
                                            margin: EdgeInsets.symmetric(
                                                horizontal: screenWidth *
                                                    (AppConfig()
                                                            .gptScreenSearchResultLeftPadding /
                                                        AppConfig()
                                                            .screenWidth)),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(screenWidth *
                                                      (AppConfig()
                                                          .gptScreenSearchResultCornerRadius) /
                                                      AppConfig().screenWidth)),
                                              color: darkMode
                                                  ? AppConfig()
                                                      .gptScreenSearchResultBackgroundDarkColor
                                                  : AppConfig()
                                                      .gptScreenSearchResultBackgroundLightColor,
                                              boxShadow: <BoxShadow>[
                                                BoxShadow(
                                                  blurStyle: BlurStyle.outer,
                                                  color: Colors.grey
                                                      .withOpacity(0.25),
                                                  blurRadius: 1,
                                                ),
                                              ],
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: screenHeight *
                                                      (AppConfig()
                                                              .gptScreenSearchResultInnerTopPadding /
                                                          AppConfig()
                                                              .screenHeight),
                                                  horizontal: screenWidth *
                                                      (AppConfig()
                                                              .gptScreenSearchResultInnerLeftPadding /
                                                          AppConfig()
                                                              .screenWidth)),
                                              child: Column(
                                                children: [
                                                  Container(
                                                    // child: TextWidget(
                                                    //   screenWidth:
                                                    //       screenWidth,
                                                    //   screenHeight:
                                                    //       screenHeight,
                                                    //   getText: searchResult,
                                                    //   fontSize: AppConfig()
                                                    //       .gptScreenSearchResultTextSize,
                                                    //   getTextAlign:
                                                    //       TextAlign.start,
                                                    //   getTextColor: darkMode
                                                    //       ? AppConfig()
                                                    //           .gptScreenSearchResultTextDarkColor
                                                    //       : AppConfig()
                                                    //           .gptScreenSearchResultTextLightColor,
                                                    //   getFontFamily: AppConfig()
                                                    //       .outfitFontRegular,
                                                    //   getTextDirection:
                                                    //       LanguageTextFile()
                                                    //           .getTextDirection(
                                                    //               getLanguageCode),
                                                    //   getSoftWrap: true
                                                    // ),

                                                    //child: languageFutureWidget(screenWidth: screenWidth, screenHeight: screenHeight, selectedLanguage: getLanguageCode, getLanguageTranslatorMethod: searchResultFutureMethod, getFontSize: AppConfig().gptScreenSearchResultTextSize, getDarkMode: darkMode, getTextAlign: TextAlign.start, getTextColor: darkMode?AppConfig().gptScreenSearchResultTextDarkColor:AppConfig().gptScreenSearchResultTextLightColor, getFontFamily: AppConfig().outfitFontRegular, getTextDirection: LanguageTextFile().getTextDirection(getLanguageCode), getSoftWrap: true),
                                                    child: Text(
                                                      searchResult,
                                                      textScaler:
                                                          const TextScaler
                                                              .linear(1.0),
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: TextStyle(
                                                          fontSize: screenHeight *
                                                              (AppConfig()
                                                                      .gptScreenSearchResultTextSize /
                                                                  AppConfig()
                                                                      .screenHeight),
                                                          color: darkMode
                                                              ? AppConfig()
                                                                  .gptScreenSearchResultTextDarkColor
                                                              : AppConfig()
                                                                  .gptScreenSearchResultTextLightColor,
                                                          fontFamily: AppConfig()
                                                              .outfitFontRegular),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: screenHeight *
                                                (AppConfig()
                                                        .gptScreenTopSearchResultPadding /
                                                    AppConfig().screenHeight),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(
                                            top: screenHeight *
                                                (5 / AppConfig().screenHeight)),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Container(),
                                            SpeakerWidget(
                                                screenWidth: screenWidth,
                                                screenHeight: screenHeight,
                                                getDarkMode: darkMode,
                                                isPlayed: (audioPlayerState ==
                                                        PlayerState.playing)
                                                    ? true
                                                    : false,
                                                callBackFunction:
                                                    (getCallBackResult) async {
                                                  if (getCallBackResult) {
                                                    if (activeSource == null) {
                                                      // getLanguageTypeMethod(
                                                      //     searchResult);
                                                    } else {
                                                      if (audioPlayerState ==
                                                          PlayerState.playing) {
                                                        await player.pause();
                                                      } else if (audioPlayerState ==
                                                          PlayerState.paused) {
                                                        await player.resume();
                                                      } else if ((audioPlayerState ==
                                                              PlayerState
                                                                  .completed) ||
                                                          (audioPlayerState ==
                                                              PlayerState
                                                                  .stopped)) {
                                                        await player
                                                            .play(activeSource);
                                                      }
                                                    }
                                                    setState(() {
                                                      isAudioWidget = true;

                                                      //bottomBar= true;
                                                      /*if(ttsState==TtsState.playing || ttsState == TtsState.continued){
                                    _pause();
                                  }
                                  else if (ttsState == TtsState.paused){
                                    _resume();
                                  }
                                  else{
                                    _speak();
                                  }*/
                                                    });
                                                  }
                                                }),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          textAlign: TextAlign.start,
                          "The Bible is a sacred scripture in the Christian religion,\nbelieved to be inspired by God. It is a collection of books\nwritten by various authors over a span of centuries. It is\ndivided into two main parts: the Old Testament (which is\nalso a sacred text in Judaism) and the New Testament.\nThe Old Testament contains books such as Genesis,\nExodus, Psalms, among others, and tells stories of\nancient prophets, kings, and the teachings they shared.\nThe New Testament contains the four Gospels (Matthew,\nMark, Luke, and John), which tell the story of Jesus\nChrist's life, teachings, death, and resurrection, as well as\nother books like Acts, which describes the early Christian\nchurch, and Revelation, which shares prophetic visions.\nThe Bible is considered the holy guideline by\nChristians by which they should live.",
                          style: TextStyle(
                              color: const Color(0xFFFFFFFF),
                              fontSize: (screenHeight *
                                  (14 / AppConfig().screenHeight))),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: Wrap(
            children: [
              isAudioWidget
                  ? Container(
                      decoration: BoxDecoration(
                        color: darkMode
                            ? AppConfig()
                                .categoryDetailScreenBackgroundEndDarkColor
                            : AppConfig()
                                .categoryDetailScreenBackgroundEndLightColor,
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            blurStyle: BlurStyle.outer,
                            color: darkMode
                                ? Colors.transparent.withOpacity(0.7)
                                : Colors.grey.withOpacity(0.5),
                            blurRadius: 7,
                          ),
                        ],
                      ),
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).padding.bottom),
                      child: Padding(
                        padding: EdgeInsets.all(
                            screenWidth * (16 / AppConfig().screenWidth)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ((audioPlayerState == PlayerState.playing) ||
                                        (audioPlayerState ==
                                            PlayerState.paused) ||
                                        (audioPlayerState ==
                                            PlayerState.completed))
                                    ? SizedBox(
                                        width: screenWidth *
                                            (35 / AppConfig().screenWidth),
                                        height: screenWidth *
                                            (35 / AppConfig().screenWidth),
                                        child: IconButton(
                                          onPressed: () async {
                                            print(audioPlayerState);
                                            if (audioPlayerState ==
                                                PlayerState.playing) {
                                              await player.pause();
                                            } else if (audioPlayerState ==
                                                PlayerState.paused) {
                                              await player.resume();
                                            } else if ((audioPlayerState ==
                                                    PlayerState.completed) ||
                                                (audioPlayerState ==
                                                    PlayerState.stopped)) {
                                              await player.play(activeSource);
                                            }
                                          },
                                          padding: const EdgeInsets.all(0),
                                          icon: Icon(
                                            (audioPlayerState ==
                                                    PlayerState.playing)
                                                ? Icons.pause
                                                : Icons.play_arrow,
                                            size: screenWidth *
                                                (35 / AppConfig().screenWidth),
                                            color: const Color(0xFFE67647),
                                          ),
                                        ),
                                      )
                                    : TextLoaderWidget(
                                        screenWidth *
                                            (35 / AppConfig().screenWidth),
                                        screenWidth *
                                            (35 / AppConfig().screenWidth),
                                        screenWidth *
                                            (5 / AppConfig().screenWidth),
                                        darkMode),
                                SizedBox(
                                  width: screenWidth *
                                      (16 / AppConfig().screenWidth),
                                ),
                                ((audioPlayerState == PlayerState.playing) ||
                                        (audioPlayerState ==
                                            PlayerState.paused) ||
                                        (audioPlayerState ==
                                            PlayerState.completed))
                                    ? SizedBox(
                                        width: screenWidth -
                                            screenWidth *
                                                ((16 + 16 + 16 + 35) /
                                                    AppConfig().screenWidth),
                                        child: _audioProgressBar(),
                                      )
                                    : TextLoaderWidget(
                                        screenWidth -
                                            screenWidth *
                                                ((16 + 16 + 16 + 35) /
                                                    AppConfig().screenWidth),
                                        screenHeight *
                                            (15 / AppConfig().screenHeight),
                                        screenHeight *
                                            (15 / AppConfig().screenHeight),
                                        darkMode),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(),
                                ((audioPlayerState == PlayerState.playing) ||
                                        (audioPlayerState ==
                                            PlayerState.paused) ||
                                        (audioPlayerState ==
                                            PlayerState.completed))
                                    ? Container(
                                        child: TextWidget(
                                            screenWidth: screenWidth,
                                            screenHeight: screenHeight,
                                            getText:
                                                "${formatTime(position)}/${formatTime(duration)}",
                                            fontSize: AppConfig()
                                                .categoryDetailScreenTitleChapterTextSize,
                                            getTextAlign: TextAlign.end,
                                            getTextColor:
                                                const Color(0xFF9D3524),
                                            getFontFamily:
                                                AppConfig().outfitFontRegular,
                                            getTextDirection: LanguageTextFile()
                                                .getTextDirection(
                                                    getLanguageCode),
                                            getSoftWrap: true),
                                        //child: languageFutureWidget(screenWidth: screenWidth, screenHeight: screenHeight, selectedLanguage: getLanguageCode,getLanguageTranslatorMethod: timerPositionFutureMethod, getFontSize: AppConfig().categoryDetailScreenTitleChapterTextSize, getDarkMode: darkMode, getTextAlign: TextAlign.center, getTextColor: Color(0xFF9D3524), getFontFamily: AppConfig().outfitFontRegular, getTextDirection: LanguageTextFile().getTextDirection(getLanguageCode), getSoftWrap: true),
                                        //child: Text("${formatTime(position)}/${formatTime(duration)}",textScaler: TextScaler.linear(1.0),textAlign: TextAlign.center,style: TextStyle(fontSize: screenHeight*(AppConfig().categoryDetailScreenTitleChapterTextSize/AppConfig().screenHeight),color: darkMode?AppConfig().categoryDetailScreenTitleChapterText1DarkColor:AppConfig().categoryDetailScreenTitleChapterText1LightColor,fontFamily: AppConfig().outfitFontRegular),textDirection: LanguageTextFile().getTextDirection(getLanguageCode),),
                                      )
                                    : TextLoaderWidget(
                                        screenWidth *
                                            ((16 + 16 + 16 + 35) /
                                                AppConfig().screenWidth),
                                        screenHeight *
                                            (AppConfig()
                                                    .categoryDetailScreenTitleChapterTextSize /
                                                AppConfig().screenHeight),
                                        screenHeight *
                                            (AppConfig()
                                                    .categoryDetailScreenTitleChapterTextSize /
                                                AppConfig().screenHeight),
                                        darkMode),
                              ],
                            ),
                          ],
                        ),
                      ),
                    )
                  : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _audioProgressBar() {
    return Container(
      alignment: Alignment.center,
      child: LinearProgressIndicator(
        backgroundColor: const Color(0xFFE67647),
        valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF9D3524)),
        value: durationDouble != 0 ? (positionDouble / durationDouble) : 0,
        borderRadius: BorderRadius.all(
            Radius.circular(screenHeight * (15 / AppConfig().screenHeight))),
      ),
    );
  }

  /*Widget _progressBar(int end){
    print(end);
    return Container(
        alignment: Alignment.center,
        child: LinearProgressIndicator(
          backgroundColor: Color(0xFFF5D784),
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF805002)),
          value: (previousRunningLength+end) / (searchResult!.length),
        ));
  }*/

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
