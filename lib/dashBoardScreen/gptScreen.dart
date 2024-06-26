import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:bible_gpt/APIRequest/api_handler.dart';
import 'package:bible_gpt/config/changable.dart';
import 'package:bible_gpt/signInScreen/signinScreen.dart';
import 'package:bible_gpt/widgets/check_internet_method.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:path_provider/path_provider.dart';
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

import 'package:http/http.dart' as http;

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

  bool isPlayerOn = false;

  bool isPlaying = false;
  bool musicApiIsLoading = false;
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
      // textEditingController.text = "";
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
          audioText = content;
        });
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

  audioPlayerInit() {
    print("Initially called #################################################");
    audioPlayerState = player.state;

    player.onPlayerStateChanged.listen((state) {
      print(" player state ^^^^^^^^^^^^^^^^ : $state");

      setState(() {
        audioPlayerState = state;

        if (state == PlayerState.playing) {
          //isAudioPlaying = true;
          print("playing");
        }

        // else if (state == PlayerState.completed) {
        //   positionDouble = durationDouble;
        //   position = duration;
        //   //isAudioPlaying = false;
        //   print("completed");
        //   print("play all : $playAllIsPlaying");

        //   if (playAllIsPlaying) {
        //     playNumber += 1;

        //     if (playNumber < chaptersList.length) {
        //       scrollToIndex(playNumber);
        //       print("Chapters list $chaptersList");

        //       print("@#%%#################################%%%%%%%");
        //       meaningClick(chaptersList[playNumber]);
        //     } else {
        //       playAllIsPlaying = false;
        //     }
        //   }
        // }

        else if (state == PlayerState.paused) {
          //isAudioPlaying = false;
          print("paused");
        } else if (state == PlayerState.stopped) {
          //isAudioPlaying = false;
          print("stopped");
        } else if (state == PlayerState.completed) {
          isPlaying = true;
          setState(() {
            isPlayerOn = false;
          });
          print("Playing compleated");
        }

        player.onPlayerStateChanged.listen((state) {
          if (state == PlayerState.completed || state == PlayerState.paused) {
            isPlayerOn = false;

            // Do something when audio playback completes
          } else if (state == PlayerState.playing) {
            isPlayerOn = true;
          } else if (state == PlayerState.stopped) {
            setState(() {
              player.seek(Duration.zero);
            });
          }
        });
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

  Future<void> playAudio(
      {required String text, required String languageCode}) async {
    setState(() {
      musicApiIsLoading = true;
      player.audioCache.clearAll();
    });

    Map<String, dynamic> getTextToSpeechResponse = {
      "status": false,
      "message": "",
      "audio": ""
    };
    String textToSpeechAPIUrl =
        "https://api.mybiblegpt.com/api/v1/user/text-to-speach/";
    print(textToSpeechAPIUrl);

    try {
      var getTextToSpeechAPIResponse = await http.post(
          Uri.parse(textToSpeechAPIUrl),
          body: {"text_input": text, "language_code": getLanguageCode});
      print(getTextToSpeechAPIResponse.body);

      if (getTextToSpeechAPIResponse.statusCode >= 200 &&
          getTextToSpeechAPIResponse.statusCode < 300) {
        getTextToSpeechResponse["status"] = true;

        Map getResponseMap = jsonDecode(getTextToSpeechAPIResponse.body);
        print("=============================");
        print(getResponseMap);

        String getAudioText = getResponseMap["audio_content"] ?? "";
        audioText = getResponseMap["audio_content"];
        getTextToSpeechResponse["audio"] = getAudioText;

        audioText = getAudioText;
      } else {
        getTextToSpeechResponse["status"] = false;
        Map getResponseMap = jsonDecode(getTextToSpeechAPIResponse.body);
        String getErrorMessage = getResponseMap["message"] ?? "";
        getTextToSpeechResponse["message"] = getErrorMessage;
      }
    } catch (e) {
      getTextToSpeechResponse["status"] = false;
      String getErrorMessage = "This voice is not available";
      getTextToSpeechResponse["message"] = getErrorMessage;
    }

    final audioContent = getTextToSpeechResponse["audio"];

    replayAudio(audioContent);
  }

  replayAudio(String getAudio) async {
    print(getAudio);

    setState(() {
      musicApiIsLoading = false;
      player.audioCache.clearAll();
    });

    if (Platform.isIOS) {
      Uint8List audioData = Uint8List.fromList(base64.decode(getAudio));
      audioPlayerLocalRun(audioData);
    } else {
      Uint8List audioData = Uint8List.fromList(base64.decode(getAudio));
      activeSource = BytesSource(audioData);
      player.play(BytesSource(audioData));
      if (audioPlayerState == PlayerState.completed) {
        setState(() {
          isPlayerOn = false;
        });
      }
    }
  }

  audioPlayerLocalRun(Uint8List getData) async {
    print("get data $getData");
    final file = File('${(await getTemporaryDirectory()).path}/temp_audio.mp3');
    await file.writeAsBytes(getData);
    activeSource = DeviceFileSource(file.path);
    player.play(DeviceFileSource(file.path));
    if (audioPlayerState == PlayerState.completed) {
      setState(() {
        isPlayerOn = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    audioPlayerInit();
  }

  @override
  void dispose() {
    super.dispose();
    player.dispose();
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
                    height: (screenHeight * (290 / AppConfig().screenHeight)),
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
                          height:
                              screenHeight * (60 / AppConfig().screenHeight),
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
                              context: context,
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
                                    isPlayerOn = false;
                                    isPlaying = false;
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
                                  (AppConfig().chapterScreenLeftPadding *
                                      2 /
                                      AppConfig().screenWidth)),
                          child: Text(
                            LanguageTextFile()
                                .getDashboardScreenBottomContentText(
                                    getLanguageCode),
                            textScaler: const TextScaler.linear(1.0),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).textScaler.scale(
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
                                .getTextDirection(getLanguageCode),
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
                                          (15 / AppConfig().screenHeight)),
                                      right: (screenWidth *
                                          (10 / AppConfig().screenWidth)),
                                      left: (screenWidth *
                                          (10 / AppConfig().screenWidth)),
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
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: searchResult.isNotEmpty
                                              ? Border.all(
                                                  color: !darkMode
                                                      ? const Color(0xFFAF6A06)
                                                      : const Color(0xFF623301))
                                              : null),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 20,
                                            bottom: 20,
                                            right: 10,
                                            left: 10),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                if (isPlaying) {
                                                  player.stop();
                                                  setState(() {
                                                    isPlaying = false;
                                                    isPlayerOn = false;
                                                  });
                                                } else {
                                                  setState(() {
                                                    isPlaying = true;
                                                    musicApiIsLoading = true;
                                                    isPlayerOn = true;
                                                  });
                                                  playAudio(
                                                      text: audioText!,
                                                      languageCode: "en");
                                                }
                                              },
                                              child: SvgPicture.asset(
                                                searchResult.isNotEmpty
                                                    ? isPlayerOn
                                                        ? "assets/svg/speaker_on.svg"
                                                        : "assets/svg/mic_icon.svg"
                                                    : "default_value_if_null",
                                                height: (screenHeight *
                                                    (25 /
                                                        AppConfig()
                                                            .screenHeight)),
                                                width: (screenWidth *
                                                    (25 *
                                                        AppConfig()
                                                            .screenWidth)),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            AnimatedTextKit(
                                              animatedTexts: [
                                                TypewriterAnimatedText(
                                                  speed: const Duration(
                                                      microseconds: 2000),
                                                  textAlign: TextAlign.start,
                                                  searchResult,
                                                  textStyle: TextStyle(
                                                    color: darkMode
                                                        ? const Color(
                                                            0xffffffff)
                                                        : const Color(
                                                            0xff0000000),

                                                    fontSize: MediaQuery.of(
                                                            context)
                                                        .textScaler
                                                        .scale((screenHeight *
                                                            (12 /
                                                                AppConfig()
                                                                    .screenHeight))),
                                                    //fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ],
                                              totalRepeatCount: 1,
                                            ),
                                          ],
                                        ),
                                      ),
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
            bottomNavigationBar: (isPlaying)
                ? musicApiIsLoading
                    ? TextLoaderWidget(
                        AppConfig().screenWidth * .8,
                        screenHeight * (50 / AppConfig().screenHeight),
                        screenHeight * (0 / AppConfig().screenHeight),
                        darkMode)
                    : Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal:
                                (screenWidth * (1 / AppConfig().screenWidth)),
                            vertical: (screenHeight *
                                (1 / AppConfig().screenHeight))),
                        child: Container(
                          height: 50,
                          width: 100,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(colors: [
                              Color(0xFF643402),
                              Color(0xFF643402),
                            ]),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                color: Colors.white,
                                icon: Icon(
                                    audioPlayerState == PlayerState.playing
                                        ? Icons.pause
                                        : Icons.play_arrow),
                                onPressed: () async {
                                  if (audioPlayerState == PlayerState.playing) {
                                    await player.pause();
                                  } else if (audioPlayerState ==
                                          PlayerState.paused ||
                                      audioPlayerState == PlayerState.stopped) {
                                    await player.resume();
                                  } else if (audioPlayerState ==
                                      PlayerState.completed) {
                                    print(" Text audio completed");
                                    replayAudio(audioText!);
                                  }
                                },
                              ),
                              Slider(
                                value: position.inSeconds
                                    .toDouble()
                                    .clamp(0.0, duration.inSeconds.toDouble()),
                                min: 0,
                                max: duration.inSeconds.toDouble(),
                                activeColor: const Color(0XFFAF6A06),
                                onChanged: (value) {
                                  setState(() {
                                    position = Duration(seconds: value.toInt());
                                    player.seek(position);
                                  });
                                },
                              ),
                              Text(
                                "${position.inSeconds}  /  ${duration.inSeconds} Sec ",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: (screenHeight *
                                      (12 / AppConfig().screenHeight)),
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                : null,
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
