import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import 'package:flutter_tts/flutter_tts.dart';

import '../Class/ChapterDetailListClass.dart';

import '../config/app_config.dart';

class categoryDetailScreen extends StatefulWidget {
  final int screenType;
  final String getValue;
  final String? languageCode;
  const categoryDetailScreen(
      {super.key,
      required this.screenType,
      required this.getValue,
      required this.languageCode});

  @override
  State<StatefulWidget> createState() {
    return categoryDetailPage(
        screenType: screenType, getValue: getValue, languageCode: languageCode);
  }
}

class categoryDetailPage extends State<categoryDetailScreen> {
  final int screenType;
  final String getValue;
  final String? languageCode;
  categoryDetailPage(
      {Key? key,
      required this.screenType,
      required this.getValue,
      required this.languageCode});
  double screenWidth = 0;
  double screenHeight = 0;
  double scaleFactor = 0;
  List<ChapterDetailListClass> getChapterDetailListClass = [];
  FlutterTts flutterTts = FlutterTts();
  late bool darkMode;
  //late int getLanguageType;
  late String getLanguageCode;
  String getTitle = "";
  String getLanguageTitle = "";
  int currentPage = 0;
  bool isAPILoading = false;
  double statusBarHeight = 0;
  bool statusBarVisible = false;
  bool isEditionAPILoading = false;
  ChapterDetailListClass? selectedChapterClass;
  ScrollController pageScrollController = ScrollController();

  int numberOfTime = 0;
  int listviewLength = 0;
  //TtsState ttsState = TtsState.stopped;

  /*get isPlaying => ttsState == TtsState.playing;
  get isStopped => ttsState == TtsState.stopped;
  get isPaused => ttsState == TtsState.paused;
  get isContinued => ttsState == TtsState.continued;

  bool get isIOS => !kIsWeb && Platform.isIOS;
  bool get isAndroid => !kIsWeb && Platform.isAndroid;
  bool get isWeb => kIsWeb;
  int end = 0;
  String? selectedText;
  int pausedLength = 0;*/
  late PlayerState audioPlayerState;
  AudioPlayer player = AudioPlayer();
  //bool isAudioPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  bool isAudioWidget = false;
  double positionDouble = 0;
  double durationDouble = 1;
  String selectedAudioId = "";
  late var activeSource;
  bool isAudioPlayerLoading = false;
  bool playAllIsPlaying = false;
  int playNumber = 0;
  int scrollValue = 0;
  double topKeyHeight = 0;

  ///final scrollDirection = Axis.vertical;
  //late AutoScrollController autoScrollController;
  GlobalKey itemKey = GlobalKey();
  GlobalKey topKey = GlobalKey();
  //ItemScrollController itemScrollController = ItemScrollController();
  Future<String>? titleFutureMethod;
  Future<String>? gitaChapterFutureMethod;
  Future<String>? selectedLanguageNameFutureMethod;
  Future<String>? changeLanguageButtonTextFutureMethod;
  Future<String>? categoryDetailBackTextFutureMethod;
  Future<String>? categoryDetailBackNextFutureMethod;
  Future<String>? categoryDetailTimeTextFutureMethod;
  Future<String>? summaryTextFutureMethod;
  Future<String>? playPauseButtonTextFutureMethod;
  //late Future<String> categoryListTitleFutureMethod;
  //late Future<String> categoryListEnglishContentFutureMethod;
  //late Future<String> categoryListHindiContentFutureMethod;
  Future<String>? categoryListHindiTextFutureMethod;
  Future<String>? categoryListEnglishTextFutureMethod;
  bool summaryVisible = false;
  int selectedSummaryText = 0;
  String summaryEnglishText = "";
  String summaryHindiText = "";
/*
  navigateToGPTScreen() {
    Navigator.push(
            context, MaterialPageRoute(builder: (context) => const GptScreen()))
        .then((value) {
      setState(() {});
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

  callSummaryPageAPI(bool refreshType, int pageNumber) async {
    if (refreshType) {
    } else {
      setState(() {
        isAPILoading = true;
      });
    }
    bool internetConnectCheck = await CheckInternetConnectionMethod();
    if (internetConnectCheck) {
      var getSummaryAPIPageResponse =
          await AllAPIMethod().getSummaryChapterAPI(chapterNumber: pageNumber);
      print(getSummaryAPIPageResponse);
      if (getSummaryAPIPageResponse["status"]) {
        setState(() {
          getLanguageTitle = getSummaryAPIPageResponse["chapter_name"];
          summaryEnglishText = getSummaryAPIPageResponse["summary_english"];
          summaryHindiText = getSummaryAPIPageResponse["summary_hindi"];
        });
      } else {
        ToastMessage(screenHeight, getSummaryAPIPageResponse["message"],
            getSummaryAPIPageResponse["status"]);
      }
    } else {
      navigateToNoInternetScreen(false);
    }
    if (refreshType) {
    } else {
      setState(() {
        isAPILoading = false;
      });
    }
  }

  callChapterPageAPI(bool refreshType, int pageNumber) async {
    if (refreshType) {
    } else {
      setState(() {
        isAPILoading = true;
        isAudioWidget = false;
      });
    }
    bool internetConnectCheck = await CheckInternetConnectionMethod();
    if (internetConnectCheck) {
      var getChapterAPIPageResponse = await AllAPIMethod()
          .getPageChapterDetailAPI(chapterNumber: pageNumber);
      print(getChapterAPIPageResponse);
      if (getChapterAPIPageResponse["status"]) {
        setState(() {
          statusBarVisible = false;
          getChapterDetailListClass.clear();
          if (selectedEdition == null) {
            editionList.clear();
            List<ChapterTranslationListClass> getEditionData =
                getChapterAPIPageResponse["translatorListData"];
            for (int h = 0; h < getEditionData.length; h++) {
              if (h == 0) {
                selectedEdition = getEditionData[h];
              }
              editionList.add(getEditionData[h]);
            }
          }
          List<ChapterDetailListClass> getChapterListData =
              getChapterAPIPageResponse["chapterListData"];
          for (int i = 0; i < getChapterListData.length; i++) {
            for (int j = 0;
                j < getChapterListData[i].translationListClass.length;
                j++) {
              if (getChapterListData[i]
                      .translationListClass[j]
                      .translationAuthor ==
                  selectedEdition!.translationAuthor) {
                getChapterListData[i].chapterTranslatorText =
                    getChapterListData[i]
                        .translationListClass[j]
                        .translationDescription;
              }
            }
            getChapterDetailListClass.add(getChapterListData[i]);
          }
          numberOfTime = 0;
          getPageIncreaseCount();
          callRender();
        });
      } else {
        ToastMessage(screenHeight, getChapterAPIPageResponse["message"],
            getChapterAPIPageResponse["status"]);
      }
    } else {
      navigateToNoInternetScreen(false);
    }
    if (refreshType) {
    } else {
      setState(() {
        isAPILoading = false;
      });
    }
  }

  callTextToSpeechAPI(String getText, String getAPILanguageCode) async {
    print(getText);
    bool internetConnectCheck = await CheckInternetConnectionMethod();
    if (internetConnectCheck) {
      var getTextToSpeechAPIResponse = await AllAPIMethod().textToSpeechAPI(
          getText: getText, getLanguageCode: getAPILanguageCode);
      print(getTextToSpeechAPIResponse);
      if (getTextToSpeechAPIResponse["status"]) {
        String getAudio = getTextToSpeechAPIResponse["audio"];
        playSoundFromUrl(false, getAudio);
      } else {
        ToastMessage(screenHeight, getTextToSpeechAPIResponse["message"],
            getTextToSpeechAPIResponse["status"]);
      }
    } else {}
  }

  initialCallAPI() async {
    if (screenType == 0) {
      currentPage = int.parse(getValue);
      await callSummaryPageAPI(false, currentPage);
      await callChapterPageAPI(false, currentPage);
      //await callLanguageAPI();
    }
  }

  textToSpeech(String text) async {
    try {
      print("langugae : $getLanguageCode");
      var isLanguageAvailable = await flutterTts.isLanguageAvailable("en");
      print("langugae available : $isLanguageAvailable");
      if (isLanguageAvailable) {
        /*await flutterTts.setLanguage("${getLanguageCode}");
        await flutterTts.awaitSpeakCompletion(true);
        await flutterTts.speak(text);*/
        print(getLanguageCode);
        await flutterTts.setLanguage(getLanguageCode);
        Uint8List audioData = Uint8List.fromList(
            base64.decode(flutterTts.speak(text).toString()));
        print("Unit8List : $audioData");
        audioPlayerLocalRun(audioData);
        //_speak();
        //print(filePath);
      } else {
        callTextToSpeechAPI(text, "en");
        //ToastMessage(screenHeight,"'${getLanguageCode}' - This language not available in your device", false);
      }
    } catch (e) {
      print("error : ${e.toString()}");
      callTextToSpeechAPI(text, "en");
      //ToastMessage(screenHeight,"'${e.toString()}' - This language not available in your device", false);
    }
    //await flutterTts.setLanguage("en-us");
    //await flutterTts.speak(text);
    //print(await flutterTts.getLanguages);
    //print(await flutterTts.getMaxSpeechInputLength);
    //await flutterTts.awaitSpeakCompletion(true).then((value){
    //initialData();
    //});
  }

  playSoundFromUrl(bool getAudioUrl, String getAudio) async {
    if (getAudioUrl) {
      String url =
          "https://cdn.islamic.network/quran/audio/64/ar.abdurrahmaansudais/$getAudio.mp3";
      activeSource = UrlSource(url);
      player.play(UrlSource(url));
    } else {
      if (Platform.isIOS) {
        Uint8List audioData = Uint8List.fromList(base64.decode(getAudio));
        audioPlayerLocalRun(audioData);
      } else {
        Uint8List audioData = Uint8List.fromList(base64.decode(getAudio));
        activeSource = BytesSource(audioData);
        player.play(BytesSource(audioData));
      }
    }
  }

  audioPlayerLocalRun(Uint8List getData) async {
    print("get data $getData");
    final file = File('${(await getTemporaryDirectory()).path}/temp_audio.mp3');
    await file.writeAsBytes(getData);
    activeSource = DeviceFileSource(file.path);
    player.play(DeviceFileSource(file.path));
  }

  /*Future _speak() async {
    if (selectedText != null) {
      await flutterTts.awaitSpeakCompletion(true);
      await flutterTts.speak(selectedText!);
      print("total length : ${await flutterTts.getMaxSpeechInputLength}");
    }
  }

  Future _stop() async {
    var result = await flutterTts.stop();
    if (result == 1) setState(() => ttsState = TtsState.stopped);
  }

  Future _pause() async {
    var result = await flutterTts.pause();
    if (result == 1) setState(() => ttsState = TtsState.paused);
  }

  Future _resume() async {
    var result = await flutterTts.speak(selectedText!);
    if (result == 1) setState(() => ttsState = TtsState.continued);
  }*/

  initTts() async {
    await flutterTts.setVolume(0);
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setPitch(1);
    /*await flutterTts.areLanguagesInstalled(["en-AU", "en-US","en","am","ar","az","ber","bn","cs","de","dv","es",
      "fa","fr","ha","hi","id","it","ja","ko","ku","ml","nl","no","pl","ps","pt","ro","ru","sd","so","sq","sv","sw",
      "ta","tg","th","tr","tt","ug","ur","uz"]);
    if(Platform.isIOS){
      await flutterTts.setSharedInstance(true);
    }
    flutterTts.setStartHandler(() {
      setState(() {
        print("Playing");
        ttsState = TtsState.playing;
      });
    });

    flutterTts.setCompletionHandler(() {
      setState(() {
        print("Complete");
        end = selectedText!.length;
        ttsState = TtsState.stopped;
      });
    });

    flutterTts.setCancelHandler(() {
      setState(() {
        print("Cancel");
        ttsState = TtsState.stopped;
      });
    });

    flutterTts.setPauseHandler(() {
      setState(() {
        print("Paused");
        pausedLength = end;
        ttsState = TtsState.paused;
      });
    });

    flutterTts.setContinueHandler(() {
      setState(() {
        print("Continued");
        end = pausedLength;
        ttsState = TtsState.continued;
      });
    });

    flutterTts.setErrorHandler((msg) {
      setState(() {
        print("error: $msg");
        ttsState = TtsState.stopped;
      });
    });

    flutterTts.setProgressHandler((String text, int startOffset, int endOffset, String word) {
          setState(() {
            end = endOffset;
          });
          print("start $startOffset");
          print("end $endOffset");
        });*/
  }

  Future scrollToIndex(int getIndex) async {
    //await autoScrollController.scrollToIndex(getIndex, preferPosition: AutoScrollPosition.begin);
    //await Scrollable.ensureVisible(Key(getIndex.toString().bu));
    //itemScrollController.jumpTo(index: getIndex);
    itemScrollController.scrollTo(
        index: getIndex, duration: const Duration(milliseconds: 500));
  }

  audioPlayerInit() {
    audioPlayerState = player.state;
    player.onPlayerStateChanged.listen((state) {
      print(state);
      setState(() {
        audioPlayerState = state;
        if (state == PlayerState.playing) {
          //isAudioPlaying = true;
          print("playing");
        } else if (state == PlayerState.completed) {
          positionDouble = durationDouble;
          position = duration;
          //isAudioPlaying = false;
          print("completed");
          print("play all : $playAllIsPlaying");
          if (playAllIsPlaying) {
            playNumber += 1;
            if (playNumber < getChapterDetailListClass.length) {
              scrollToIndex(playNumber);
              meaningClick(getChapterDetailListClass[playNumber]);
            } else {
              playAllIsPlaying = false;
            }
          }
        } else if (state == PlayerState.paused) {
          //isAudioPlaying = false;
          print("paused");
        } else if (state == PlayerState.stopped) {
          //isAudioPlaying = false;
          print("stopped");
        }
      });
    });
    player.onDurationChanged.listen((getDuration) {
      setState(() {
        print(getDuration);
        durationDouble = (getDuration.inMilliseconds) / 1000;
        duration = getDuration;
      });
    });
    player.onPositionChanged.listen((getPosition) {
      setState(() {
        print(getPosition);
        positionDouble = (getPosition.inMilliseconds) / 1000;
        position = getPosition;
      });
    });
  }

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

  getPageIncreaseCount() {
    numberOfTime += 1;
    setState(() {
      listviewLength = numberOfTime * 10;
    });
    print(listviewLength);
  }

  callRender() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final RenderBox renderBox =
          topKey.currentContext!.findRenderObject() as RenderBox;
      setState(() {
        print("${renderBox.size}");
        topKeyHeight = renderBox.size.height;
      });
    });
  }

  futureFunctionMethod() async {
    print("language title : $getLanguageTitle");
    getLanguageCode =
        await SharedPreference.instance.getSelectedLanguage("language");
    print("get lang : $getLanguageCode");
    titleFutureMethod = languageTranslatorMethod(
        getText: getLanguageTitle, getLanguageCode: getLanguageCode);
    gitaChapterFutureMethod = languageTranslatorMethod(
        getText: "Gita / Chapter", getLanguageCode: getLanguageCode);
    selectedLanguageNameFutureMethod = languageTranslatorMethod(
        getText: "${LanguageTextFile().getLanguageName(getLanguageCode)}",
        getLanguageCode: getLanguageCode);
    changeLanguageButtonTextFutureMethod = languageTranslatorMethod(
        getText: LanguageTextFile()
            .getCategoryDetailScreenChangeLanguageButtonIconText(),
        getLanguageCode: getLanguageCode);
    categoryDetailBackTextFutureMethod = languageTranslatorMethod(
        getText: LanguageTextFile().getCategoryDetailScreenBackText(),
        getLanguageCode: getLanguageCode);
    categoryDetailBackNextFutureMethod = languageTranslatorMethod(
        getText: LanguageTextFile().getCategoryDetailScreenNextText(),
        getLanguageCode: getLanguageCode);
    categoryDetailTimeTextFutureMethod = languageTranslatorMethod(
        getText: "${formatTime(position)}/${formatTime(duration)}",
        getLanguageCode: getLanguageCode);
    summaryTextFutureMethod = languageTranslatorMethod(
        getText: "Summary", getLanguageCode: getLanguageCode);
    playPauseButtonTextFutureMethod = languageTranslatorMethod(
        getText: playAllIsPlaying
            ? LanguageTextFile().getCategoryDetailScreenPlayAllPauseButtonText()
            : LanguageTextFile().getCategoryDetailScreenPlayAllPlayButtonText(),
        getLanguageCode: getLanguageCode);
    //categoryListTitleFutureMethod = languageTranslatorMethod(getText: "Shlok: 1", getLanguageCode: getLanguageCode);
    //categoryListEnglishContentFutureMethod = languageTranslatorMethod(getText: "The King Dhritarashtra asked, O Sanjaya! What happened on the sacred battlefield of Kurukshetra when my people and the Pandavas gathered?", getLanguageCode: getLanguageCode);
    //categoryListHindiContentFutureMethod = languageTranslatorMethod(getText: "The King Dhritarashtra asked, O Sanjaya! What happened on the sacred battlefield of Kurukshetra when my people and the Pandavas gathered?", getLanguageCode: getLanguageCode);
    categoryListHindiTextFutureMethod = languageTranslatorMethod(
        getText: "Hindi", getLanguageCode: getLanguageCode);
    categoryListEnglishTextFutureMethod = languageTranslatorMethod(
        getText: "English", getLanguageCode: getLanguageCode);
    setState(() {});
  }

  callInitState() async {
    bool internetConnectCheck = await CheckInternetConnectionMethod();
    if (internetConnectCheck) {
      futureFunctionMethod();
      initTts();
      audioPlayerInit();
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
        if (pageScrollController.position.maxScrollExtent ==
            pageScrollController.position.pixels) {
          print("call bottom");
          getPageIncreaseCount();
        }
      });
      initialCallAPI();
    } else {
      navigateToNoInternetScreen(true);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //initialData();
    //autoScrollController = AutoScrollController(viewportBoundaryGetter: () => Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom), axis: scrollDirection);
    callInitState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    pageScrollController.dispose();
    flutterTts.stop();
    player.dispose();
  } */

  @override
  Widget build(BuildContext context) {
    statusBarHeight = MediaQuery.of(context).padding.top;
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    scaleFactor = MediaQuery.of(context).textScaleFactor;
    // darkMode = themeMethod(context);
    // getLanguageCode = languageMethod(context);
    AppConfig().getStatusBar(darkMode);
    /*  return WillPopScope(
      onWillPop: Platform.isIOS
          ? null
          : () async {
              return true;
            },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Container(
            width: screenWidth,
            height: screenHeight,
            alignment: Alignment.topCenter,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[
                  darkMode
                      ? AppConfig().categoryDetailScreenBackgroundStartDarkColor
                      : AppConfig()
                          .categoryDetailScreenBackgroundStartLightColor,
                  darkMode
                      ? AppConfig().categoryDetailScreenBackgroundStartDarkColor
                      : AppConfig()
                          .categoryDetailScreenBackgroundStartLightColor,
                  darkMode
                      ? AppConfig().categoryDetailScreenBackgroundEndDarkColor
                      : AppConfig().categoryDetailScreenBackgroundEndLightColor,
                  darkMode
                      ? AppConfig().categoryDetailScreenBackgroundEndDarkColor
                      : AppConfig().categoryDetailScreenBackgroundEndLightColor,
                ],
                tileMode: TileMode.mirror,
              ),
            ),
            child: isAPILoading
                ? DetailLoaderScreen(screenWidth, screenHeight, darkMode)
                : (titleFutureMethod == null ||
                        gitaChapterFutureMethod == null ||
                        selectedLanguageNameFutureMethod == null ||
                        changeLanguageButtonTextFutureMethod == null ||
                        categoryDetailBackTextFutureMethod == null ||
                        categoryDetailBackNextFutureMethod == null ||
                        categoryDetailTimeTextFutureMethod == null ||
                        summaryTextFutureMethod == null ||
                        playPauseButtonTextFutureMethod == null ||
                        categoryListHindiTextFutureMethod == null ||
                        categoryListEnglishTextFutureMethod == null)
                    ? const SizedBox()
                    : Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          Container(
                            width: screenWidth,
                            height:
                                screenHeight * (320 / AppConfig().screenHeight),
                            color: Colors.transparent
                                .withOpacity(darkMode ? 0.4 : 0),
                            child: Image.asset(
                              darkMode
                                  ? AppConfig().bottomNavigationBookLightIcon
                                  : AppConfig().bottomNavigationBookLightIcon,
                              fit: BoxFit.fill,
                            ),
                          ),
                          Container(
                            width: screenWidth,
                            height: screenHeight,
                            alignment: Alignment.topCenter,
                            child: RefreshIndicator(
                              onRefresh: () async {
                                if (screenType == 0) {
                                  await callSummaryPageAPI(true, currentPage);
                                  await callChapterPageAPI(true, currentPage);
                                }
                                return;
                              },
                              child: SingleChildScrollView(
                                physics: playAllIsPlaying
                                    ? const NeverScrollableScrollPhysics()
                                    : const AlwaysScrollableScrollPhysics(),
                                controller: pageScrollController,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      key: topKey,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            height: screenHeight *
                                                (AppConfig()
                                                        .categoryDetailScreenTopPadding /
                                                    AppConfig().screenHeight),
                                          ),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: screenWidth *
                                                    (16 /
                                                        AppConfig()
                                                            .screenWidth)),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  child: BackArrowWidget(
                                                      screenWidth: screenWidth,
                                                      screenHeight:
                                                          screenHeight,
                                                      darkMode: darkMode,
                                                      getCallBackFunction:
                                                          (isClicked) {
                                                        if (isClicked) {
                                                          Navigator.pop(
                                                              context);
                                                        }
                                                      }),
                                                ),
                                                Container(
                                                  child: TextWidget(
                                                      screenWidth: screenWidth,
                                                      screenHeight:
                                                          screenHeight,
                                                      getText: getLanguageTitle,
                                                      fontSize: AppConfig()
                                                          .categoryDetailScreenTitleTextSize,
                                                      getTextAlign:
                                                          TextAlign.center,
                                                      getTextColor: darkMode
                                                          ? AppConfig()
                                                              .categoryDetailScreenTitleTextDarkColor
                                                          : AppConfig()
                                                              .categoryDetailScreenTitleTextLightColor,
                                                      getFontFamily: AppConfig()
                                                          .outfitFontRegular,
                                                      getTextDirection:
                                                          LanguageTextFile()
                                                              .getTextDirection(
                                                                  getLanguageCode),
                                                      getSoftWrap: true),
                                                  //child: languageFutureWidget(screenWidth: screenWidth, screenHeight: screenHeight, selectedLanguage: getLanguageCode,  getFontSize: AppConfig().categoryDetailScreenTitleTextSize, getDarkMode: darkMode,getLanguageTranslatorMethod: titleFutureMethod, getTextAlign: TextAlign.center, getTextColor: darkMode?AppConfig().categoryDetailScreenTitleTextDarkColor:AppConfig().categoryDetailScreenTitleTextLightColor, getFontFamily: AppConfig().outfitFontRegular, getTextDirection: LanguageTextFile().getTextDirection(getLanguageCode), getSoftWrap: true),
                                                  //child: Text("${getLanguageTitle}",textScaler: TextScaler.linear(1.0),textAlign: TextAlign.center,style: TextStyle(fontSize: screenHeight*(AppConfig().categoryDetailScreenTitleTextSize/AppConfig().screenHeight),color: darkMode?AppConfig().categoryDetailScreenTitleTextDarkColor:AppConfig().categoryDetailScreenTitleTextLightColor,fontFamily: AppConfig().outfitFontRegular,height: 0),softWrap: true,),
                                                ),
                                                Container(
                                                  width: screenWidth *
                                                      (AppConfig()
                                                              .backArrowWidgetOuterWidth /
                                                          AppConfig()
                                                              .screenWidth),
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: TextButton(
                                                    onPressed: () {
                                                      navigateToGPTScreen();
                                                    },
                                                    style: TextButton.styleFrom(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius: BorderRadius
                                                            .all(Radius.circular(
                                                                screenWidth *
                                                                    (0 /
                                                                        AppConfig()
                                                                            .screenWidth))),
                                                      ),
                                                      minimumSize: Size.zero,
                                                      padding: EdgeInsets.zero,
                                                      tapTargetSize:
                                                          MaterialTapTargetSize
                                                              .shrinkWrap,
                                                    ),
                                                    child: SvgPicture.asset(
                                                      AppConfig()
                                                          .categoryDetailScreenSearchIcon,
                                                      fit: BoxFit.scaleDown,
                                                      color: darkMode
                                                          ? AppConfig()
                                                              .categoryDetailScreenSearchIconDarkColor
                                                          : AppConfig()
                                                              .categoryDetailScreenSearchIconLightColor,
                                                      width: screenHeight *
                                                          (22 /
                                                              AppConfig()
                                                                  .screenHeight),
                                                      height: screenHeight *
                                                          (22 /
                                                              AppConfig()
                                                                  .screenHeight),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: screenHeight *
                                                (10 / AppConfig().screenHeight),
                                          ),
                                          Container(
                                            // child: languageFutureWidget(
                                            //     screenWidth: screenWidth,
                                            //     screenHeight: screenHeight,
                                            //     getLanguageTranslatorMethod:
                                            //         gitaChapterFutureMethod,
                                            //     selectedLanguage:
                                            //         getLanguageCode,
                                            //     getFontSize: 14,
                                            //     getDarkMode: darkMode,
                                            //     getTextAlign: TextAlign.center,
                                            //     getTextColor: darkMode
                                            //         ? const Color(0xFFDB7F5E)
                                            //         : const Color(0xFFAB2E1A),
                                            //     getFontFamily: AppConfig()
                                            //         .outfitFontRegular,
                                            //     getTextDirection:
                                            //         LanguageTextFile()
                                            //             .getTextDirection(
                                            //                 getLanguageCode),
                                            //     getSoftWrap: true),
                                            child: Text(
                                              "Gita / Chapter",
                                              textScaler:
                                                  const TextScaler.linear(1.0),
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: screenHeight *
                                                      (14 /
                                                          AppConfig()
                                                              .screenHeight),
                                                  color: darkMode
                                                      ? const Color(0xFFFFFFFF)
                                                      : const Color(0xFFAB2E1A),
                                                  fontFamily: AppConfig()
                                                      .outfitFontRegular),
                                            ),
                                          ),
                                          SizedBox(
                                            height: screenHeight *
                                                (AppConfig()
                                                        .categoryDetailScreenTopChangeEditionPadding /
                                                    AppConfig().screenHeight),
                                          ),
                                          summaryVisible
                                              ? Container(
                                                  width: screenWidth,
                                                  margin: EdgeInsets.symmetric(
                                                      horizontal: screenWidth *
                                                          (12 /
                                                              AppConfig()
                                                                  .screenWidth)),
                                                  child: Stack(
                                                    alignment: Alignment.center,
                                                    children: [
                                                      Positioned.fill(
                                                        child: Column(
                                                          children: [
                                                            Expanded(
                                                              child:
                                                                  Image.asset(
                                                                AppConfig()
                                                                    .summaryBackgroundIcon,
                                                                fit:
                                                                    BoxFit.fill,
                                                                width:
                                                                    screenWidth,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Container(
                                                        padding: EdgeInsets.all(
                                                            screenWidth *
                                                                (28 /
                                                                    AppConfig()
                                                                        .screenWidth)),
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Container(
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                textDirection:
                                                                    LanguageTextFile()
                                                                        .getTextDirection(
                                                                            getLanguageCode),
                                                                children: [
                                                                  SizedBox(
                                                                    width: screenWidth *
                                                                        (24 /
                                                                            AppConfig().screenWidth),
                                                                  ),
                                                                  Container(
                                                                    child: languageFutureWidget(
                                                                        screenWidth:
                                                                            screenWidth,
                                                                        screenHeight:
                                                                            screenHeight,
                                                                        selectedLanguage:
                                                                            getLanguageCode,
                                                                        getLanguageTranslatorMethod:
                                                                            summaryTextFutureMethod,
                                                                        getFontSize:
                                                                            18,
                                                                        getDarkMode:
                                                                            darkMode,
                                                                        getTextAlign:
                                                                            TextAlign
                                                                                .center,
                                                                        getTextColor:
                                                                            const Color(
                                                                                0xFFE37144),
                                                                        getFontFamily:
                                                                            AppConfig()
                                                                                .outfitFontMedium,
                                                                        getTextDirection:
                                                                            LanguageTextFile().getTextDirection(
                                                                                getLanguageCode),
                                                                        getSoftWrap:
                                                                            true),
                                                                  ),
                                                                  SizedBox(
                                                                    width: screenWidth *
                                                                        (24 /
                                                                            AppConfig().screenWidth),
                                                                    height: screenWidth *
                                                                        (24 /
                                                                            AppConfig().screenWidth),
                                                                    child:
                                                                        TextButton(
                                                                      onPressed:
                                                                          () {
                                                                        setState(
                                                                            () {
                                                                          summaryVisible =
                                                                              false;
                                                                        });
                                                                      },
                                                                      style: TextButton
                                                                          .styleFrom(
                                                                        shape:
                                                                            RoundedRectangleBorder(
                                                                          borderRadius:
                                                                              BorderRadius.all(Radius.circular(screenWidth * (0 / AppConfig().screenWidth))),
                                                                        ),
                                                                        minimumSize:
                                                                            Size.zero,
                                                                        padding:
                                                                            EdgeInsets.zero,
                                                                        tapTargetSize:
                                                                            MaterialTapTargetSize.shrinkWrap,
                                                                      ),
                                                                      child: SvgPicture
                                                                          .asset(
                                                                        AppConfig()
                                                                            .summaryCloseIcon,
                                                                        fit: BoxFit
                                                                            .scaleDown,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: screenHeight *
                                                                  (7 /
                                                                      AppConfig()
                                                                          .screenHeight),
                                                            ),
                                                            Container(
                                                              child: Text(
                                                                selectedSummaryText ==
                                                                        0
                                                                    ? summaryEnglishText
                                                                    : selectedSummaryText ==
                                                                            1
                                                                        ? summaryHindiText
                                                                        : "",
                                                                textScaler:
                                                                    const TextScaler
                                                                        .linear(
                                                                        1.0),
                                                                softWrap: true,
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                textDirection:
                                                                    LanguageTextFile()
                                                                        .getTextDirection(
                                                                            getLanguageCode),
                                                                style: TextStyle(
                                                                    fontSize: screenHeight *
                                                                        (14 /
                                                                            AppConfig()
                                                                                .screenHeight),
                                                                    fontFamily:
                                                                        AppConfig()
                                                                            .outfitFontRegular,
                                                                    color: const Color(
                                                                        0xFFE37144)),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              : Container(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Container(
                                                        child: Stack(
                                                          children: [
                                                            SecondaryButton(
                                                                screenWidth:
                                                                    screenWidth,
                                                                screenHeight:
                                                                    screenHeight,
                                                                buttonWidth:
                                                                    115,
                                                                buttonHeight:
                                                                    36,
                                                                getDarkMode:
                                                                    darkMode,
                                                                buttonText:
                                                                    summaryTextFutureMethod!,
                                                                getLanguageCode:
                                                                    getLanguageCode,
                                                                iconPath:
                                                                    "assets/svg/dropdown_arrow.svg",
                                                                iconWidth: 12,
                                                                iconHeight: 8,
                                                                buttonPressedFunction:
                                                                    (isClick) {
                                                                  print(
                                                                      "is clicked");
                                                                }),
                                                            SizedBox(
                                                              width: screenWidth *
                                                                  (125 /
                                                                      AppConfig()
                                                                          .screenWidth),
                                                              height: screenHeight *
                                                                  (36 /
                                                                      AppConfig()
                                                                          .screenHeight),
                                                              child:
                                                                  DropdownMenu(
                                                                inputDecorationTheme:
                                                                    const InputDecorationTheme(
                                                                  isDense: true,
                                                                  suffixIconColor:
                                                                      Colors
                                                                          .transparent,
                                                                  contentPadding:
                                                                      EdgeInsets
                                                                          .zero,
                                                                  outlineBorder:
                                                                      BorderSide
                                                                          .none,
                                                                  border:
                                                                      InputBorder
                                                                          .none,
                                                                ),
                                                                expandedInsets:
                                                                    EdgeInsets
                                                                        .zero,
                                                                enableSearch:
                                                                    false,
                                                                menuStyle:
                                                                    MenuStyle(
                                                                  backgroundColor: MaterialStateProperty.all(darkMode
                                                                      ? const Color(
                                                                          0xFF303030)
                                                                      : const Color(
                                                                          0xFFFFFFFF)),
                                                                  //fixedSize: MaterialStateProperty.all(Size(screenWidth*(115/AppConfig().screenWidth), screenHeight*(98/AppConfig().screenHeight))),
                                                                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.all(Radius.circular(screenWidth *
                                                                              (6 / AppConfig().screenWidth))))),
                                                                  padding: MaterialStateProperty.all(
                                                                      EdgeInsets
                                                                          .zero),
                                                                ),
                                                                onSelected: (int?
                                                                    getSelected) {
                                                                  print(
                                                                      getSelected);
                                                                  setState(() {
                                                                    summaryVisible =
                                                                        true;
                                                                    selectedSummaryText =
                                                                        getSelected!;
                                                                  });
                                                                },
                                                                dropdownMenuEntries: [
                                                                  DropdownMenuEntry(
                                                                    style: ButtonStyle(
                                                                        backgroundColor: MaterialStateProperty.all(darkMode
                                                                            ? const Color(
                                                                                0xFF303030)
                                                                            : const Color(
                                                                                0xFFFFFFFF)),
                                                                        padding:
                                                                            MaterialStateProperty.all(EdgeInsets
                                                                                .zero),
                                                                        tapTargetSize:
                                                                            MaterialTapTargetSize
                                                                                .shrinkWrap,
                                                                        maximumSize: MaterialStateProperty.all(Size(
                                                                            screenWidth *
                                                                                (125 / AppConfig().screenWidth),
                                                                            screenHeight * (49 / AppConfig().screenHeight))),
                                                                        minimumSize: MaterialStateProperty.all(Size(screenWidth * (125 / AppConfig().screenWidth), screenHeight * (49 / AppConfig().screenHeight))),
                                                                        fixedSize: MaterialStateProperty.all(Size(screenWidth * (125 / AppConfig().screenWidth), screenHeight * (49 / AppConfig().screenHeight)))),
                                                                    value: 0,
                                                                    labelWidget:
                                                                        Container(
                                                                      alignment:
                                                                          Alignment
                                                                              .centerLeft,
                                                                      height: screenHeight *
                                                                          (49 /
                                                                              AppConfig().screenHeight),
                                                                      padding: EdgeInsets.symmetric(
                                                                          horizontal:
                                                                              screenWidth * (19 / AppConfig().screenWidth)),
                                                                      color: darkMode
                                                                          ? const Color(
                                                                              0xFF303030)
                                                                          : const Color(
                                                                              0xFFFFFFFF),
                                                                      width: screenWidth *
                                                                          (125 /
                                                                              AppConfig().screenWidth),
                                                                      // child: languageFutureWidget(
                                                                      //     screenWidth:
                                                                      //         screenWidth,
                                                                      //     screenHeight:
                                                                      //         screenHeight,
                                                                      //     selectedLanguage:
                                                                      //         getLanguageCode,
                                                                      //     getLanguageTranslatorMethod:
                                                                      //         categoryListEnglishTextFutureMethod,
                                                                      //     getFontSize:
                                                                      //         14,
                                                                      //     getDarkMode:
                                                                      //         darkMode,
                                                                      //     getTextAlign: TextAlign
                                                                      //         .start,
                                                                      //     getTextColor: darkMode
                                                                      //         ? const Color(
                                                                      //             0xFFFFFFFF)
                                                                      //         : const Color(
                                                                      //             0xFF999999),
                                                                      //     getFontFamily: AppConfig()
                                                                      //         .outfitFontRegular,
                                                                      //     getTextDirection: LanguageTextFile().getTextDirection(
                                                                      //         getLanguageCode),
                                                                      //     getSoftWrap:
                                                                      //         true),
                                                                      child:
                                                                          Text(
                                                                        "English",
                                                                        textScaler: const TextScaler
                                                                            .linear(
                                                                            1.0),
                                                                        softWrap:
                                                                            true,
                                                                        textAlign:
                                                                            TextAlign.start,
                                                                        textDirection:
                                                                            LanguageTextFile().getTextDirection(getLanguageCode),
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                screenHeight * (14 / AppConfig().screenHeight),
                                                                            fontFamily: AppConfig().outfitFontRegular,
                                                                            color: darkMode ? const Color(0xFFFFFFFF) : const Color(0xFF999999)),
                                                                      ),
                                                                    ),
                                                                    label: '',
                                                                  ),
                                                                  DropdownMenuEntry(
                                                                    style: ButtonStyle(
                                                                        backgroundColor: MaterialStateProperty.all(darkMode
                                                                            ? const Color(
                                                                                0xFF303030)
                                                                            : const Color(
                                                                                0xFFFFFFFF)),
                                                                        padding:
                                                                            MaterialStateProperty.all(EdgeInsets
                                                                                .zero),
                                                                        tapTargetSize:
                                                                            MaterialTapTargetSize
                                                                                .shrinkWrap,
                                                                        maximumSize: MaterialStateProperty.all(Size(
                                                                            screenWidth *
                                                                                (125 / AppConfig().screenWidth),
                                                                            screenHeight * (49 / AppConfig().screenHeight))),
                                                                        minimumSize: MaterialStateProperty.all(Size(screenWidth * (125 / AppConfig().screenWidth), screenHeight * (49 / AppConfig().screenHeight))),
                                                                        fixedSize: MaterialStateProperty.all(Size(screenWidth * (125 / AppConfig().screenWidth), screenHeight * (49 / AppConfig().screenHeight)))),
                                                                    value: 1,
                                                                    labelWidget:
                                                                        Container(
                                                                      alignment:
                                                                          Alignment
                                                                              .centerLeft,
                                                                      height: screenHeight *
                                                                          (49 /
                                                                              AppConfig().screenHeight),
                                                                      padding: EdgeInsets.symmetric(
                                                                          horizontal:
                                                                              screenWidth * (19 / AppConfig().screenWidth)),
                                                                      color: darkMode
                                                                          ? const Color(
                                                                              0xFF303030)
                                                                          : const Color(
                                                                              0xFFFFFFFF),
                                                                      width: screenWidth *
                                                                          (125 /
                                                                              AppConfig().screenWidth),
                                                                      // child: languageFutureWidget(
                                                                      //     screenWidth:
                                                                      //         screenWidth,
                                                                      //     screenHeight:
                                                                      //         screenHeight,
                                                                      //     selectedLanguage:
                                                                      //         getLanguageCode,
                                                                      //     getLanguageTranslatorMethod:
                                                                      //         categoryListHindiTextFutureMethod,
                                                                      //     getFontSize:
                                                                      //         14,
                                                                      //     getDarkMode:
                                                                      //         darkMode,
                                                                      //     getTextAlign: TextAlign
                                                                      //         .start,
                                                                      //     getTextColor: darkMode
                                                                      //         ? const Color(
                                                                      //             0xFFFFFFFF)
                                                                      //         : const Color(
                                                                      //             0xFF999999),
                                                                      //     getFontFamily: AppConfig()
                                                                      //         .outfitFontRegular,
                                                                      //     getTextDirection: LanguageTextFile().getTextDirection(
                                                                      //         getLanguageCode),
                                                                      //     getSoftWrap:
                                                                      //         true),
                                                                      child:
                                                                          Text(
                                                                        "Hindi",
                                                                        textScaler: const TextScaler
                                                                            .linear(
                                                                            1.0),
                                                                        softWrap:
                                                                            true,
                                                                        textAlign:
                                                                            TextAlign.start,
                                                                        textDirection:
                                                                            LanguageTextFile().getTextDirection(getLanguageCode),
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                screenHeight * (14 / AppConfig().screenHeight),
                                                                            fontFamily: AppConfig().outfitFontRegular,
                                                                            color: darkMode ? const Color(0xFFFFFFFF) : const Color(0xFF999999)),
                                                                      ),
                                                                    ),
                                                                    label: '',
                                                                  ),
                                                                  //DropdownMenuEntry(style:ButtonStyle(padding: MaterialStateProperty.all(EdgeInsets.zero),tapTargetSize: MaterialTapTargetSize.shrinkWrap,fixedSize: MaterialStateProperty.all(Size(screenWidth*(115/AppConfig().screenWidth),screenHeight*(49/AppConfig().screenHeight)))),value: 2,leadingIcon: Container(alignment: Alignment.centerLeft,height: screenHeight*(49/AppConfig().screenHeight),padding: EdgeInsets.symmetric(horizontal: screenWidth*(19/AppConfig().screenWidth)),color:darkMode?Color(0xFF30303):Color(0xFFFFFFFF),width: screenWidth*(115/AppConfig().screenWidth),child: Text("Hindi",textScaler: TextScaler.linear(1.0),softWrap: true,textAlign: TextAlign.start,textDirection: LanguageTextFile().getTextDirection(getLanguageCode),style: TextStyle(fontSize: screenHeight*(14/AppConfig().screenHeight),fontFamily: AppConfig().outfitFontRegular,color: Color(0xFF999999)),),), label: ''),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: screenWidth *
                                                            (15 /
                                                                AppConfig()
                                                                    .screenWidth),
                                                      ),
                                                      PrimaryButton(
                                                          screenWidth:
                                                              screenWidth,
                                                          screenHeight:
                                                              screenHeight,
                                                          buttonWidth: 115,
                                                          buttonHeight: 36,
                                                          getDarkMode: darkMode,
                                                          buttonText:
                                                              playPauseButtonTextFutureMethod,
                                                          getLanguageCode:
                                                              getLanguageCode,
                                                          isAPILoading: false,
                                                          iconPath: playAllIsPlaying
                                                              ? AppConfig()
                                                                  .categoryDetailScreenPauseIcon
                                                              : AppConfig()
                                                                  .categoryDetailScreenPlayIcon,
                                                          iconWidth: 12,
                                                          iconHeight: 12,
                                                          buttonPressedFunction:
                                                              (isClick) {
                                                            if (isClick) {
                                                              setState(() {
                                                                if (playAllIsPlaying) {
                                                                  playAllIsPlaying =
                                                                      false;
                                                                  playNumber =
                                                                      0;
                                                                  player.stop();
                                                                  playPauseButtonTextFutureMethod = languageTranslatorMethod(
                                                                      getText: playAllIsPlaying
                                                                          ? LanguageTextFile()
                                                                              .getCategoryDetailScreenPlayAllPauseButtonText()
                                                                          : LanguageTextFile()
                                                                              .getCategoryDetailScreenPlayAllPlayButtonText(),
                                                                      getLanguageCode:
                                                                          getLanguageCode);
                                                                  isAudioWidget =
                                                                      false;
                                                                } else {
                                                                  playAllIsPlaying =
                                                                      true;
                                                                  isAudioWidget =
                                                                      true;
                                                                  playNumber =
                                                                      0;
                                                                  playPauseButtonTextFutureMethod = languageTranslatorMethod(
                                                                      getText: playAllIsPlaying
                                                                          ? LanguageTextFile()
                                                                              .getCategoryDetailScreenPlayAllPauseButtonText()
                                                                          : LanguageTextFile()
                                                                              .getCategoryDetailScreenPlayAllPlayButtonText(),
                                                                      getLanguageCode:
                                                                          getLanguageCode);
                                                                  meaningClick(
                                                                      getChapterDetailListClass[
                                                                          playNumber]);
                                                                }
                                                              });
                                                            }
                                                          }),
                                                    ],
                                                  ),
                                                ),
                                          SizedBox(
                                            height: screenHeight *
                                                (AppConfig()
                                                        .categoryDetailScreenTopListviewPadding /
                                                    AppConfig().screenHeight),
                                          ),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: screenWidth *
                                                    (18 /
                                                        AppConfig()
                                                            .screenWidth)),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              textDirection: LanguageTextFile()
                                                  .getTextDirection(
                                                      getLanguageCode),
                                              children: [
                                                Container(
                                                  child: TextButton(
                                                    onPressed: () {
                                                      LanguageDialogBox();
                                                    },
                                                    style: TextButton.styleFrom(
                                                      minimumSize: Size.zero,
                                                      padding: EdgeInsets.zero,
                                                      tapTargetSize:
                                                          MaterialTapTargetSize
                                                              .shrinkWrap,
                                                    ),
                                                    child: Container(
                                                      padding: EdgeInsets.symmetric(
                                                          vertical: screenHeight *
                                                              (10 /
                                                                  AppConfig()
                                                                      .screenHeight)),
                                                      child: TextWidget(
                                                          screenWidth:
                                                              screenWidth,
                                                          screenHeight:
                                                              screenHeight,
                                                          getText:
                                                              "${selectedEdition!.translationLanguage} - ${selectedEdition!.translationAuthor}",
                                                          fontSize: AppConfig()
                                                              .categoryDetailScreenTitleChapterTextSize,
                                                          getTextAlign:
                                                              TextAlign.start,
                                                          getTextColor: darkMode
                                                              ? const Color(
                                                                  0xFFDB7F5E)
                                                              : const Color(
                                                                  0xFF9A3524),
                                                          getFontFamily: AppConfig()
                                                              .outfitFontRegular,
                                                          getTextDirection:
                                                              LanguageTextFile()
                                                                  .getTextDirection(
                                                                      getLanguageCode),
                                                          getSoftWrap: true),
                                                      //child: languageFutureWidget(screenWidth: screenWidth, screenHeight: screenHeight, selectedLanguage: getLanguageCode,getLanguageTranslatorMethod: selectedLanguageNameFutureMethod,getFontSize: AppConfig().categoryDetailScreenTitleChapterTextSize, getDarkMode: darkMode, getTextAlign: TextAlign.center, getTextColor: darkMode?Color(0xFFDB7F5E):Color(0xFF9A3524), getFontFamily: AppConfig().outfitFontRegular, getTextDirection: LanguageTextFile().getTextDirection(getLanguageCode), getSoftWrap: true),
                                                      //child: Text("${LanguageTextFile().getLanguageName(selectedLanguage)}",textScaler: TextScaler.linear(1.0),textAlign: TextAlign.center,style: TextStyle(fontSize: screenHeight*(AppConfig().categoryDetailScreenTitleChapterTextSize/AppConfig().screenHeight),color: darkMode?Color(0xFFFFFFFF):Color(0xFF9A3524),fontFamily: AppConfig().outfitFontRegular),),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: TextButton(
                                                    onPressed: () {
                                                      LanguageDialogBox();
                                                    },
                                                    style: TextButton.styleFrom(
                                                      minimumSize: Size.zero,
                                                      padding: EdgeInsets.zero,
                                                      tapTargetSize:
                                                          MaterialTapTargetSize
                                                              .shrinkWrap,
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Container(
                                                          // child: languageFutureWidget(
                                                          //     screenWidth:
                                                          //         screenWidth,
                                                          //     screenHeight:
                                                          //         screenHeight,
                                                          //     getLanguageTranslatorMethod:
                                                          //         changeLanguageButtonTextFutureMethod,
                                                          //     selectedLanguage:
                                                          //         getLanguageCode,
                                                          //     getFontSize: 14,
                                                          //     getDarkMode:
                                                          //         darkMode,
                                                          //     getTextAlign:
                                                          //         TextAlign
                                                          //             .start,
                                                          //     getTextColor: darkMode
                                                          //         ? const Color(
                                                          //             0xFFDB7F5E)
                                                          //         : const Color(
                                                          //             0xFF9A3524),
                                                          //     getFontFamily:
                                                          //         AppConfig()
                                                          //             .outfitFontRegular,
                                                          //     getTextDirection:
                                                          //         LanguageTextFile()
                                                          //             .getTextDirection(
                                                          //                 getLanguageCode),
                                                          //     getSoftWrap:
                                                          //         true),
                                                          child: Text(
                                                            LanguageTextFile()
                                                                .getCategoryDetailScreenChangeLanguageButtonIconText(),
                                                            textScaler:
                                                                const TextScaler
                                                                    .linear(
                                                                    1.0),
                                                            textAlign:
                                                                TextAlign.start,
                                                            style: TextStyle(
                                                                fontSize: screenHeight *
                                                                    (14 /
                                                                        AppConfig()
                                                                            .screenHeight),
                                                                color: const Color(
                                                                    0xFF9A3524),
                                                                fontFamily:
                                                                    AppConfig()
                                                                        .outfitFontRegular),
                                                            textDirection:
                                                                LanguageTextFile()
                                                                    .getTextDirection(
                                                                        getLanguageCode),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: screenWidth *
                                                              (5 /
                                                                  AppConfig()
                                                                      .screenWidth),
                                                        ),
                                                        Container(
                                                          width: screenWidth *
                                                              (22 /
                                                                  AppConfig()
                                                                      .screenWidth),
                                                          height: screenWidth *
                                                              (26 /
                                                                  AppConfig()
                                                                      .screenWidth),
                                                          alignment: Alignment
                                                              .centerRight,
                                                          child:
                                                              SvgPicture.asset(
                                                            "assets/svg/dropdown_arrow.svg",
                                                            fit: BoxFit
                                                                .scaleDown,
                                                            color: darkMode
                                                                ? const Color(
                                                                    0xFFDB7F5E)
                                                                : const Color(
                                                                    0xFF9A3524),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: screenHeight *
                                                (12 / AppConfig().screenHeight),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: screenWidth,
                                      height: playAllIsPlaying
                                          ? (screenHeight - topKeyHeight)
                                          : null,
                                      child: ScrollablePositionedList.builder(
                                        itemScrollController:
                                            itemScrollController,
                                        scrollDirection: Axis.vertical,
                                        //controller: autoScrollController,
                                        padding: const EdgeInsets.all(0),
                                        physics: playAllIsPlaying
                                            ? const AlwaysScrollableScrollPhysics()
                                            : const NeverScrollableScrollPhysics(),
                                        //physics: NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: listviewLength >
                                                getChapterDetailListClass.length
                                            ? getChapterDetailListClass.length
                                            : listviewLength,
                                        itemBuilder: (context, index) {
                                          return Container(
                                            key: Key(index.toString()),
                                            child: CategoryListviewWidget(
                                                getChapterDetailListClass[
                                                    index]),
                                          );
                                        },
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: screenWidth *
                                              (AppConfig()
                                                      .categoryDetailScreenHorizontalPadding /
                                                  AppConfig().screenWidth)),
                                      child: Row(
                                        textDirection: LanguageTextFile()
                                            .getTextDirection(getLanguageCode),
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          currentPage == 1
                                              ? const SizedBox()
                                              : Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius
                                                        .all(Radius.circular(
                                                            screenHeight *
                                                                (20 /
                                                                    AppConfig()
                                                                        .screenHeight))),
                                                    gradient:
                                                        const LinearGradient(
                                                      begin:
                                                          Alignment.topCenter,
                                                      end: Alignment
                                                          .bottomCenter,
                                                      colors: <Color>[
                                                        Color(0xFFF4EDD9),
                                                        Color(0xFFF5D784),
                                                      ],
                                                      tileMode: TileMode.mirror,
                                                    ),
                                                  ),
                                                  child: TextButton(
                                                    onPressed: () async {
                                                      setState(() {
                                                        if (currentPage == 1) {
                                                          ToastMessage(
                                                              screenHeight,
                                                              "Can't go to previous page",
                                                              false);
                                                        } else {
                                                          playAllIsPlaying =
                                                              false;
                                                          playNumber = 0;
                                                          player.stop();
                                                          isAudioWidget = false;
                                                          currentPage -= 1;
                                                        }
                                                      });
                                                      if (screenType == 0 &&
                                                          currentPage == 1) {
                                                        await callSummaryPageAPI(
                                                            false, currentPage);
                                                        await callChapterPageAPI(
                                                            false, currentPage);
                                                      }
                                                    },
                                                    style: TextButton.styleFrom(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius: BorderRadius
                                                            .all(Radius.circular(
                                                                screenWidth *
                                                                    (0 /
                                                                        AppConfig()
                                                                            .screenWidth))),
                                                      ),
                                                      minimumSize: Size.zero,
                                                      padding: EdgeInsets.zero,
                                                      tapTargetSize:
                                                          MaterialTapTargetSize
                                                              .shrinkWrap,
                                                    ),
                                                    child: Padding(
                                                      padding: EdgeInsets.symmetric(
                                                          horizontal: screenWidth *
                                                              (20 /
                                                                  AppConfig()
                                                                      .screenWidth),
                                                          vertical: screenHeight *
                                                              (5 /
                                                                  AppConfig()
                                                                      .screenHeight)),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          SizedBox(
                                                            width: screenHeight *
                                                                (20 /
                                                                    AppConfig()
                                                                        .screenHeight),
                                                            height: screenHeight *
                                                                (20 /
                                                                    AppConfig()
                                                                        .screenHeight),
                                                            child: Icon(
                                                              Icons
                                                                  .arrow_back_ios_outlined,
                                                              size: screenHeight *
                                                                  (15 /
                                                                      AppConfig()
                                                                          .screenHeight),
                                                              color: const Color(
                                                                  0xFF805002),
                                                            ),
                                                          ),
                                                          Container(
                                                            //height: screenHeight*(20/AppConfig().screenHeight),
                                                            alignment: Alignment
                                                                .topCenter,
                                                            // child: languageFutureWidget(
                                                            //     screenWidth:
                                                            //         screenWidth,
                                                            //     screenHeight:
                                                            //         screenHeight,
                                                            //     getLanguageTranslatorMethod:
                                                            //         categoryDetailBackTextFutureMethod,
                                                            //     selectedLanguage:
                                                            //         getLanguageCode,
                                                            //     getFontSize: 15,
                                                            //     getDarkMode:
                                                            //         darkMode,
                                                            //     getTextAlign:
                                                            //         TextAlign
                                                            //             .start,
                                                            //     getTextColor:
                                                            //         const Color(
                                                            //             0xFF805002),
                                                            //     getFontFamily:
                                                            //         AppConfig()
                                                            //             .outfitFontRegular,
                                                            //     getTextDirection:
                                                            //         LanguageTextFile()
                                                            //             .getTextDirection(
                                                            //                 getLanguageCode),
                                                            //     getSoftWrap:
                                                            //         true),
                                                            child: Text(
                                                              LanguageTextFile()
                                                                  .getCategoryDetailScreenBackText(),
                                                              textScaler:
                                                                  const TextScaler
                                                                      .linear(
                                                                      1.0),
                                                              textAlign:
                                                                  TextAlign
                                                                      .start,
                                                              style: TextStyle(
                                                                  fontSize: screenHeight *
                                                                      (15 /
                                                                          AppConfig()
                                                                              .screenHeight),
                                                                  color: const Color(
                                                                      0xFF805002),
                                                                  fontFamily:
                                                                      AppConfig()
                                                                          .outfitFontRegular),
                                                              textDirection:
                                                                  LanguageTextFile()
                                                                      .getTextDirection(
                                                                          getLanguageCode),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                          ((currentPage == 114 &&
                                                      screenType == 1) ||
                                                  (currentPage == 30 &&
                                                      screenType == 0))
                                              ? const SizedBox()
                                              : Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius
                                                        .all(Radius.circular(
                                                            screenHeight *
                                                                (20 /
                                                                    AppConfig()
                                                                        .screenHeight))),
                                                    gradient:
                                                        const LinearGradient(
                                                      begin:
                                                          Alignment.topCenter,
                                                      end: Alignment
                                                          .bottomCenter,
                                                      colors: <Color>[
                                                        Color(0xFFF4EDD9),
                                                        Color(0xFFF5D784),
                                                      ],
                                                      tileMode: TileMode.mirror,
                                                    ),
                                                  ),
                                                  child: TextButton(
                                                    onPressed: () async {
                                                      setState(() {
                                                        playAllIsPlaying =
                                                            false;
                                                        playNumber = 0;
                                                        player.stop();
                                                        isAudioWidget = false;
                                                        currentPage += 1;
                                                      });
                                                      if (screenType == 0) {
                                                        await callSummaryPageAPI(
                                                            false, currentPage);
                                                        await callChapterPageAPI(
                                                            false, currentPage);
                                                      }
                                                    },
                                                    style: TextButton.styleFrom(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius: BorderRadius
                                                            .all(Radius.circular(
                                                                screenWidth *
                                                                    (0 /
                                                                        AppConfig()
                                                                            .screenWidth))),
                                                      ),
                                                      minimumSize: Size.zero,
                                                      padding: EdgeInsets.zero,
                                                      tapTargetSize:
                                                          MaterialTapTargetSize
                                                              .shrinkWrap,
                                                    ),
                                                    child: Padding(
                                                      padding: EdgeInsets.symmetric(
                                                          horizontal: screenWidth *
                                                              (20 /
                                                                  AppConfig()
                                                                      .screenWidth),
                                                          vertical: screenHeight *
                                                              (5 /
                                                                  AppConfig()
                                                                      .screenHeight)),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Container(
                                                            //height: screenHeight*(20/AppConfig().screenHeight),
                                                            alignment: Alignment
                                                                .topCenter,
                                                            // child: languageFutureWidget(
                                                            //     screenWidth:
                                                            //         screenWidth,
                                                            //     screenHeight:
                                                            //         screenHeight,
                                                            //     selectedLanguage:
                                                            //         getLanguageCode,
                                                            //     getLanguageTranslatorMethod:
                                                            //         categoryDetailBackNextFutureMethod,
                                                            //     getFontSize: 15,
                                                            //     getDarkMode:
                                                            //         darkMode,
                                                            //     getTextAlign:
                                                            //         TextAlign
                                                            //             .start,
                                                            //     getTextColor:
                                                            //         const Color(
                                                            //             0xFF805002),
                                                            //     getFontFamily:
                                                            //         AppConfig()
                                                            //             .outfitFontRegular,
                                                            //     getTextDirection:
                                                            //         LanguageTextFile()
                                                            //             .getTextDirection(
                                                            //                 getLanguageCode),
                                                            //     getSoftWrap:
                                                            //         true),
                                                            
                                                            
                                                            child: Text(
                                                              LanguageTextFile()
                                                                  .getCategoryDetailScreenNextText(),
                                                              textScaler:
                                                                  const TextScaler
                                                                      .linear(
                                                                      1.0),
                                                              textAlign:
                                                                  TextAlign
                                                                      .start,
                                                              style: TextStyle(
                                                                  fontSize: screenHeight *
                                                                      (15 /
                                                                          AppConfig()
                                                                              .screenHeight),
                                                                  color: const Color(
                                                                      0xFF805002),
                                                                  fontFamily:
                                                                      AppConfig()
                                                                          .outfitFontRegular),
                                                              textDirection:
                                                                  LanguageTextFile()
                                                                      .getTextDirection(
                                                                          getLanguageCode),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: screenHeight *
                                                                (20 /
                                                                    AppConfig()
                                                                        .screenHeight),
                                                            height: screenHeight *
                                                                (20 /
                                                                    AppConfig()
                                                                        .screenHeight),
                                                            child: Icon(
                                                              Icons
                                                                  .arrow_forward_ios_outlined,
                                                              size: screenHeight *
                                                                  (15 /
                                                                      AppConfig()
                                                                          .screenHeight),
                                                              color: const Color(
                                                                  0xFF805002),
                                                            ),
                                                          ),
                                                        ],
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
                                                  .categoryDetailScreenTopListviewPadding /
                                              AppConfig().screenHeight),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          statusBarVisible
                              ? Container(
                                  width: screenWidth,
                                  height: statusBarHeight,
                                  color: darkMode
                                      ? AppConfig()
                                          .categoryDetailScreenBackgroundStartDarkColor
                                      : AppConfig()
                                          .categoryDetailScreenBackgroundStartLightColor,
                                )
                              : const SizedBox(),
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
                                            if (playAllIsPlaying) {
                                              playAllIsPlaying = false;
                                              playNumber = 0;
                                              player.stop();
                                              isAudioWidget = false;
                                              playPauseButtonTextFutureMethod =
                                                  languageTranslatorMethod(
                                                      getText: playAllIsPlaying
                                                          ? LanguageTextFile()
                                                              .getCategoryDetailScreenPlayAllPauseButtonText()
                                                          : LanguageTextFile()
                                                              .getCategoryDetailScreenPlayAllPlayButtonText(),
                                                      getLanguageCode:
                                                          getLanguageCode);
                                            } else {
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
                                        //child: languageFutureWidget(screenWidth: screenWidth, screenHeight: screenHeight, selectedLanguage: getLanguageCode, getLanguageTranslatorMethod: categoryDetailTimeTextFutureMethod,getFontSize: AppConfig().categoryDetailScreenTitleChapterTextSize, getDarkMode: darkMode, getTextAlign: TextAlign.center, getTextColor: darkMode?AppConfig().categoryDetailScreenTitleChapterText1DarkColor:AppConfig().categoryDetailScreenTitleChapterText1LightColor, getFontFamily: AppConfig().outfitFontRegular, getTextDirection: LanguageTextFile().getTextDirection(getLanguageCode), getSoftWrap: true),
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
    */
    return Container();
  }
/*
  Widget CategoryListviewWidget(ChapterDetailListClass getCategoryClass) {
    return CategoryListWidget(
        screenWidth: screenWidth,
        screenHeight: screenHeight,
        getChapterClass: getCategoryClass,
        darkMode: darkMode,
        getLanguageCode: getLanguageCode,
        screenType: screenType,
        isPlaying: (audioPlayerState == PlayerState.playing) ? true : false,
        isPlayingAll: playAllIsPlaying,
        hindiTextFuture: categoryListHindiTextFutureMethod!,
        englishTextFuture: categoryListEnglishTextFutureMethod!,
        callBackMeaning: (getClass) {
          meaningClick(getClass);
        },
        callBackArabic: (getClass) {
          setState(() {
            playAllIsPlaying = false;
            playNumber = 0;
          });
          translatorClick(getClass);
        },
        languageButtonClick: (isClicked) async {
          if (isClicked) {
            LanguageDialogBox();
          }
        });
  }

  meaningClick(ChapterDetailListClass getClass) {
    setState(() {
      flutterTts.stop();
      isAudioWidget = true;
      if (selectedChapterClass != null &&
          selectedChapterClass!.chapterId == getClass.chapterId &&
          audioPlayerState == PlayerState.playing &&
          selectedChapterClass!.meaningPlaying) {
        player.pause();
      } else {
        player.stop();
      }
      for (int i = 0; i < getChapterDetailListClass.length; i++) {
        if (getChapterDetailListClass[i].chapterId == getClass.chapterId) {
          selectedChapterClass = getClass;
          selectedChapterClass?.translatePlaying = false;
          if (selectedChapterClass!.meaningPlaying) {
            selectedChapterClass?.meaningPlaying = false;
          } else {
            selectedChapterClass?.meaningPlaying = true;
            selectedAudioId = getChapterDetailListClass[i].chapterId.toString();
            callTextToSpeechAPI(selectedChapterClass!.chapterMeaningText, "hi");
            /*if(Platform.isIOS){
              callTextToSpeechAPI(selectedChapterClass!.chapterMeaningText);
            }
            else{
              print("android");
              textToSpeech(selectedChapterClass!.chapterMeaningText);
            }*/
          }
        } else {
          getChapterDetailListClass[i].translatePlaying = false;
          getChapterDetailListClass[i].meaningPlaying = false;
        }
      }
    });
  }

  translatorClick(ChapterDetailListClass getClass) {
    setState(() {
      flutterTts.stop();
      isAudioWidget = true;
      playAllIsPlaying = false;
      playNumber = 0;
      if (audioPlayerState == PlayerState.playing ||
          audioPlayerState == PlayerState.paused) {
        player.pause();
      } else {
        player.stop();
      }
      isAudioWidget = true;
      for (int i = 0; i < getChapterDetailListClass.length; i++) {
        if (getChapterDetailListClass[i].chapterId == getClass.chapterId) {
          getChapterDetailListClass[i].meaningPlaying = false;
          if (getChapterDetailListClass[i].translatePlaying) {
            getChapterDetailListClass[i].translatePlaying = false;
          } else {
            getChapterDetailListClass[i].translatePlaying = true;
            selectedAudioId = getChapterDetailListClass[i].chapterId.toString();
            callTextToSpeechAPI(
                getChapterDetailListClass[i].chapterTranslatorText,
                selectedEdition?.translationLanguage == "English"
                    ? "en"
                    : "hi");
            //playSoundFromUrl(true,"${selectedAudioId}");
            //textToSpeech(getCategoryListClass[i].arabicText,"ar");
          }
        } else {
          getChapterDetailListClass[i].translatePlaying = false;
          getChapterDetailListClass[i].meaningPlaying = false;
        }
      }
    });
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

  /*Widget _btnSection() {
    /*if (isAndroid) {
      return Container(
          padding: EdgeInsets.only(top: 50.0),
          child:
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            _buildButtonColumn(Colors.green, Colors.greenAccent,
                Icons.play_arrow, 'PLAY', _speak),
            _buildButtonColumn(
                Colors.red, Colors.redAccent, Icons.stop, 'STOP', _stop),
          ]));
    } else {
      return Container(
          padding: EdgeInsets.only(top: 50.0),
          child:
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            _buildButtonColumn(Colors.green, Colors.greenAccent,
                Icons.play_arrow, 'PLAY', _speak),
            _buildButtonColumn(
                Colors.red, Colors.redAccent, Icons.stop, 'STOP', _stop),
            _buildButtonColumn(
                Colors.blue, Colors.blueAccent, Icons.pause, 'PAUSE', _pause),
          ]));
    }*/
    return Container(
      width: screenWidth*(35/AppConfig().screenWidth),
      height: screenWidth*(35/AppConfig().screenWidth),
      child: IconButton(
        onPressed: (){
          if(ttsState==TtsState.stopped){
            _speak();
          }
          else if(ttsState==TtsState.playing || ttsState == TtsState.continued){
            _pause();
          }
          else if(ttsState==TtsState.paused){
            _resume();
          }

        },
        padding: EdgeInsets.all(0),
        icon: Icon(((ttsState == TtsState.playing) || (ttsState == TtsState.continued))?Icons.pause:Icons.play_arrow,size: screenWidth*(35/AppConfig().screenWidth),color: Color(0xFFF5D784),),
      ),
    );
  }*/

  submitButtonFunction() {
    setState(() {
      playAllIsPlaying = false;
      playNumber = 0;
      player.stop();
      isAudioWidget = false;
      if (screenType == 0) {
        for (int i = 0; i < getChapterDetailListClass.length; i++) {
          ChapterDetailListClass getChapterDetail =
              getChapterDetailListClass[i];
          for (int j = 0;
              j < getChapterDetail.translationListClass.length;
              j++) {
            if (selectedEdition!.translationAuthor ==
                getChapterDetail.translationListClass[j].translationAuthor) {
              getChapterDetail.chapterTranslatorText = getChapterDetail
                  .translationListClass[j].translationDescription;
            }
          }
        }
      }
    });
    Navigator.pop(context);
  }

  LanguageDialogBox() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter stateSetter) {
            return Dialog(
              insetPadding: const EdgeInsets.all(0),
              backgroundColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                side: BorderSide(
                    width: screenWidth * (1 / AppConfig().screenWidth),
                    color: darkMode
                        ? const Color(0xFF973424)
                        : const Color(0xFF973424)),
                borderRadius: BorderRadius.circular(
                    screenWidth * (6 / AppConfig().screenWidth)),
              ), //this right here
              child: Wrap(
                children: [
                  LanguageDialogBoxWidget(
                      screenWidth: screenWidth,
                      screenHeight: screenHeight,
                      selectedEdition: selectedEdition,
                      editionList: editionList,
                      darkMode: darkMode,
                      getLanguageCode: getLanguageCode,
                      submitButton: (isClick) {
                        if (isClick) {
                          submitButtonFunction();
                        }
                      },
                      editionCallBack: (getEdition) {
                        stateSetter(() {
                          selectedEdition = getEdition;
                        });
                        submitButtonFunction();
                      }),
                ],
              ),
            );
          });
        });
  } */
}

enum TtsState { playing, stopped, paused, continued }
