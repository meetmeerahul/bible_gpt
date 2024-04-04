import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
import 'package:bible_gpt/APIRequest/api_handler.dart';
import 'package:bible_gpt/class/book_chapter.dart';
import 'package:bible_gpt/config/app_config.dart';
import 'package:bible_gpt/config/changable.dart';
import 'package:bible_gpt/dashBoardScreen/gptScreen.dart';
import 'package:bible_gpt/loader/screen/DetailLoaderScreen.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../class/LanguageMethod.dart';
import '../class/change_language_local.dart';
import '../class/languages_and_transilations.dart';
import '../class/theme_method.dart';
import '../config/language_text_file.dart';

import 'package:http/http.dart' as http;

import '../dashBoardScreen/noInternetScreen.dart';
import '../loader/widget/TextLoaderWidget.dart';

import '../loader/widget/player_loader.dart';
import '../widgets/check_internet_method.dart';
import '../widgets/toast_message.dart';

class BookDetailScreen extends StatefulWidget {
  final String bookid;
  final String chapterCOunt;
  final String chapterName;
  const BookDetailScreen(
      {super.key,
      required this.bookid,
      required this.chapterCOunt,
      required this.chapterName});

  @override
  State<BookDetailScreen> createState() => BookDetail(
      bookid: bookid, chapterCOunt: chapterCOunt, chapterName: chapterName);
}

class BookDetail extends State<BookDetailScreen> {
  double screenWidth = 0;
  double screenHeight = 0;
  late bool darkMode;

  String bookid;
  String chapterCOunt;
  String chapterName;

  BookDetail(
      {Key? key,
      required this.bookid,
      required this.chapterCOunt,
      required this.chapterName});

  bool statusBarVisible = true;
  ScrollController pageScrollController = ScrollController();
  double statusBarHeight = 0;

  bool translationIsLoading = false;

  final AudioPlayer _audioPlayer = AudioPlayer();
  String _audioState = 'Stopped';

  Duration totalDuration = const Duration();
  Duration currentPosition = const Duration();

  late String getLanguageCode;
  late ChangeLanguageLocal languageLocal;

  int num = 20;

  bool isPlaying = false;
  bool isPause = false;

  bool playIcon = false;

  bool apiIsloading = false;

  bool songIsFetching = false;

  late double scaleFactor;

  ItemScrollController itemScrollController = ItemScrollController();

  bool chapterListIsEmpty = true;
  late PlayerState audioPlayerState;

  // List<Translations>? _selectedTranslations;
  List<LanguagesAndTransilations>? languagesList;

  Translations? userSelectedTranslation;

  List<BookChapters> chaptersList = [];

  BookChapters? selectedChapterClass;

  int checkedIndex = 0;

  int verseCount = 0;

  int verseIdForReplay = 0;

  int playingIndex = -100;

  String selectedChapter = "1";
  final FlutterTts fluttertts = FlutterTts();

  late Future<List<BookChapters>> _booksFuture;
  late List<Translations> _translations;

  bool musicApiIsLoading = false;

  GlobalKey topKey = GlobalKey();
  double topKeyHeight = 0;

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

  int listviewLength = 0;
  int numberOfTime = 0;

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

  getPageIncreaseCount() {
    numberOfTime += 1;
    print("Incremented");
    setState(() {
      // listviewLength = numberOfTime * 10;
    });
    print(listviewLength);
  }

  callInitState() async {
    bool internetConnectCheck = await CheckInternetConnectionMethod();
    if (internetConnectCheck) {
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
          // getPageIncreaseCount();
        }
      });
    } else {
      navigateToNoInternetScreen(true);
    }
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

  getLanguage() {
    languageLocal = Provider.of<ChangeLanguageLocal>(context);
    getLanguageCode = languageMethod(context);
    print("Language in details :$getLanguageCode");
  }

  callTextToSpeechAPI(String getText, String getAPILanguageCode) async {
    print(getText);
    bool internetConnectCheck = await CheckInternetConnectionMethod();
    if (internetConnectCheck) {
      var getTextToSpeechAPIResponse = await ApiHandler.textToSpeechAPI(
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

  playSoundFromUrl(bool getAudioUrl, String getAudio) async {
    if (getAudioUrl) {
      String url =
          "https://cdn.islamic.network/quran/audio/64/ar.abdurrahmaansudais/$getAudio.mp3";
      activeSource = UrlSource(url);
      _audioPlayer.play(UrlSource(url));
    } else {
      if (Platform.isIOS) {
        Uint8List audioData = Uint8List.fromList(base64.decode(getAudio));
        audioPlayerLocalRun(audioData);
      } else {
        Uint8List audioData = Uint8List.fromList(base64.decode(getAudio));
        activeSource = BytesSource(audioData);
        _audioPlayer.play(BytesSource(audioData));
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //scrollinit();
    callInitState();
    _booksFuture = getBookChapters(0);
    // audioPlayerInit();
    getTransilations();

    setState(() {
      apiIsloading = false;
    });
  }

  // scrollinit() async {
  //   bool internetConnectCheck = await CheckInternetConnectionMethod();
  //   if (internetConnectCheck) {
  //     pageScrollController.addListener(() {
  //       if (pageScrollController.offset > 0) {
  //         if (statusBarVisible) {
  //           setState(() {
  //             statusBarVisible = !statusBarVisible;
  //           });
  //         }
  //       } else {
  //         setState(() {
  //           statusBarVisible = !statusBarVisible;
  //         });
  //       }
  //     });
  //   }
  // }

  Future<List<BookChapters>> getBookChapters(int chapter) async {
    late String chapterNumber;

    if (chapter == 0) {
      chapterNumber = 1.toString();

      setState(() {
        apiIsloading = true;
      });
      print(" Apiloading :   $apiIsloading");
      var result = await ApiHandler.getChaptersContents(
          changableShortName, bookid, chapterNumber);
      setState(() {
        apiIsloading = false;
      });

      numberOfTime = 0;
      getPageIncreaseCount();
      callRender();

      return result;
    } else {
      chapterNumber = chapter.toString();

      setState(() {
        apiIsloading = true;
      });
      print(" Apiloading :   $apiIsloading");
      var result = await ApiHandler.getChaptersContents(
          changableShortName, bookid, chapterNumber);
      setState(() {
        apiIsloading = false;
      });

      numberOfTime = 0;
      getPageIncreaseCount();
      callRender();
      return result;
    }
  }

  Future<void> playAudio(
      {required String text, required String languageCode}) async {
    setState(() {
      musicApiIsLoading = true;
      isPlaying = true;
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

    if (Platform.isIOS) {
      Uint8List audioData = Uint8List.fromList(base64.decode(audioContent));
      audioPlayerLocalRun(audioData);
    } else {
      Uint8List audioData = Uint8List.fromList(base64.decode(audioContent));
      activeSource = BytesSource(audioData);
      _audioPlayer.play(BytesSource(audioData));
      // _audioPlayer.onPlayerStateChanged.listen((event) {
      //   if (event == PlayerState.completed) {
      //     setState(() {
      //       isPlaying = false;
      //     });
      //   }
      // });
    }

    setState(() {
      musicApiIsLoading = false;
    });
  }

  audioPlayerLocalRun(Uint8List getData) async {
    print("get data $getData");
    final file = File('${(await getTemporaryDirectory()).path}/temp_audio.mp3');
    await file.writeAsBytes(getData);
    activeSource = DeviceFileSource(file.path);
    _audioPlayer.play(DeviceFileSource(file.path));
  }

  Future<void> play(DeviceFileSource activeSource) async {
    _audioPlayer.play(activeSource);
  }

  audioPlayerInit() {
    print("Initially called #################################################");
    audioPlayerState = _audioPlayer.state;

    _audioPlayer.onPlayerStateChanged.listen((state) {
      print(" player state ^^^^^^^^^^^^^^^^ : $state");

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

            if (playNumber < chaptersList.length) {
              scrollToIndex(playNumber);
              print("Chapters list $chaptersList");

              print("@#%%#################################%%%%%%%");
              meaningClick(chaptersList[playNumber]);
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
        } else if (state == PlayerState.completed) {
          playAllIsPlaying = true;
          isPlaying = true;
        }
      });
    });
    _audioPlayer.onDurationChanged.listen((getDuration) {
      setState(() {
        print(getDuration);
        durationDouble = (getDuration.inMilliseconds) / 1000;
        duration = getDuration;
      });
    });
    _audioPlayer.onPositionChanged.listen((getPosition) {
      setState(() {
        print(getPosition);
        positionDouble = (getPosition.inMilliseconds) / 1000;
        position = getPosition;
      });
    });
  }

  Future<void> stop() async {
    await _audioPlayer.stop();
  }

  @override
  void dispose() {
    super.dispose();
    // TODO: implement dispose
    pageScrollController.dispose();

    if (isPlaying) {
      _audioPlayer.dispose();
    }

    // _audioPlayer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    statusBarHeight = MediaQuery.of(context).padding.top;
    darkMode = themeMethod(context);

    getLanguage();
    print(darkMode);
    print(("ook id : $bookid"));
    print(" BookId-------$chapterCOunt");
    print("book name $chapterName");

    print("TopKey Height : $topKeyHeight");
    // print(" Chapters-------${chapterCount}");
    return Scaffold(
      body: Container(
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          controller: pageScrollController,
          child: Column(
            children: [
              Column(
                children: [
                  Container(
                    key: topKey,
                    height: (screenHeight * (400 / AppConfig().screenHeight)),
                    width: (screenWidth * (440 / AppConfig().screenWidth)),
                    decoration: BoxDecoration(
                      color: darkMode
                          ? const Color(0xff000000)
                          : const Color(0xffffffff),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage(darkMode
                            ? "assets/png/book_image_dark.png"
                            : "assets/png/book_image.png"),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: (screenHeight *
                                (27 / AppConfig().screenHeight)),
                          ),
                          child: SizedBox(
                            height:
                                kToolbarHeight, // Assuming you want the widget to have the same height as the app bar
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: () => Navigator.of(context).pop(),
                                  child: SvgPicture.asset(
                                    "assets/svg/back_arrow.svg",
                                    color: darkMode
                                        ? Colors.white
                                        : Colors
                                            .black, // Change icon color according to dark mode
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    chapterName,
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: darkMode
                                          ? Colors.white
                                          : const Color(0xFF353535),
                                      fontSize: MediaQuery.of(context)
                                              .textScaleFactor *
                                          (screenHeight *
                                              (18 / AppConfig().screenHeight)),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => const GptScreen(),
                                    ),
                                  ),
                                  child: SvgPicture.asset(
                                    "assets/svg/search_icon.svg",
                                    color: darkMode
                                        ? Colors.white
                                        : Colors
                                            .black, // Change icon color according to dark mode
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                getLanguageCode == 'en'
                                    ? "Bible / "
                                    : " बाइबिल /",
                                style: TextStyle(
                                  fontSize: MediaQuery.of(context)
                                      .textScaler
                                      .scale((screenHeight *
                                          (12 / AppConfig().screenHeight))),
                                  color: darkMode
                                      ? const Color(0xffffffff)
                                      : const Color(0xFF353535),
                                ),
                              ),
                              Text(
                                getLanguageCode == 'en'
                                    ? " Book / "
                                    : " किताब /",
                                style: TextStyle(
                                    fontSize: MediaQuery.of(context)
                                        .textScaler
                                        .scale((screenHeight *
                                            (12 / AppConfig().screenHeight))),
                                    color: const Color(0XFFAF6A06)),
                              ),
                              Text(
                                chapterName,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: MediaQuery.of(context)
                                        .textScaler
                                        .scale((screenHeight *
                                            (12 / AppConfig().screenHeight))),
                                    color: const Color(0XFFAF6A06)),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              if (!musicApiIsLoading) {
                                if ((playAllIsPlaying || isPlaying) ||
                                    (playAllIsPlaying && isPlaying) ||
                                    (playAllIsPlaying && !isPlaying) ||
                                    (!playAllIsPlaying && isPlaying) ||
                                    playAllIsPlaying ||
                                    songIsFetching) {
                                  playingIndex = -1;
                                  _audioPlayer.stop();

                                  songIsFetching = false;
                                  playAllIsPlaying = false;
                                  isPlaying = false;
                                  playNumber = 0;
                                  isPlaying = false;
                                  print("****************Audio PLayer Stopped");
                                  isAudioWidget = false;
                                } else {
                                  playAllIsPlaying = true;
                                  isPlaying = true;
                                  isAudioWidget = true;
                                  playNumber = 0;
                                  print(
                                      "******************Audio PLayer started");
                                  meaningClick(chaptersList[playNumber]);
                                }
                              }
                            });
                          },
                          child: Container(
                            height: MediaQuery.of(context).textScaler.scale(
                                (screenHeight *
                                    (36 / AppConfig().screenHeight))),
                            width: MediaQuery.of(context).textScaler.scale(
                                screenWidth * (113 / AppConfig().screenWidth)),
                            decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30)),
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Color(0xFFC47807),
                                  Color(0xFF643402),
                                ],
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                SvgPicture.asset(
                                    width: MediaQuery.of(context)
                                        .textScaler
                                        .scale(((screenWidth *
                                            (10.87 /
                                                AppConfig().screenWidth)))),
                                    height: MediaQuery.of(context)
                                        .textScaler
                                        .scale(((screenHeight *
                                            (12 / AppConfig().screenHeight)))),
                                    !playAllIsPlaying
                                        ? "assets/svg/play_icon.svg"
                                        : "assets/svg/pause.svg"),
                                Text(
                                  getLanguageCode == 'en'
                                      ? playAllIsPlaying
                                          ? "Stop"
                                          : "Play All"
                                      : playAllIsPlaying
                                          ? "रुकना"
                                          : "सभी खेलना",
                                  style: TextStyle(
                                    color: const Color(0xFFFFFFFF),
                                    fontSize: MediaQuery.of(context)
                                        .textScaler
                                        .scale((screenHeight *
                                            (16 / AppConfig().screenHeight))),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  getLanguageCode == 'en'
                                      ? "Search Chapters"
                                      : "अध्याय खोजें",
                                  style: TextStyle(
                                    color: darkMode
                                        ? const Color(0xFFAF6A06)
                                        : const Color(0xFF623301),
                                    fontSize: MediaQuery.of(context)
                                        .textScaler
                                        .scale((screenHeight *
                                            (12 / AppConfig().screenHeight))),
                                  ),
                                ),
                                SizedBox(
                                  height: MediaQuery.of(context)
                                      .textScaler
                                      .scale((screenHeight *
                                          (5 / AppConfig().screenHeight))),
                                ),
                                DropdownButtonHideUnderline(
                                  child: DropdownButton2<String>(
                                    isExpanded: true,
                                    hint: Row(
                                      children: [
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                              .textScaler
                                              .scale(screenWidth *
                                                  (4 /
                                                      AppConfig().screenWidth)),
                                        ),
                                        Expanded(
                                          child: Text(
                                            LanguageTextFile()
                                                .bottomNavAll(getLanguageCode),
                                            style: TextStyle(
                                              fontSize: MediaQuery.of(context)
                                                  .textScaler
                                                  .scale((screenHeight *
                                                      (12 /
                                                          AppConfig()
                                                              .screenHeight))),
                                              color: darkMode
                                                  ? Colors.white
                                                  : Colors.black,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    items: List.generate(
                                        int.parse(chapterCOunt), (index) {
                                      return DropdownMenuItem<String>(
                                        value: (index + 1)
                                            .toString(), // Assuming chapter numbering starts from 1
                                        child: Text(
                                          (index + 1)
                                              .toString(), // Assuming chapter numbering starts from 1
                                          style: TextStyle(
                                            fontSize: MediaQuery.of(context)
                                                .textScaler
                                                .scale((screenHeight *
                                                    (12 /
                                                        AppConfig()
                                                            .screenHeight))),
                                            color: darkMode
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      );
                                    }),
                                    value: selectedChapter,
                                    onChanged: (String? value) {
                                      String? oldValue;
                                      setState(() {
                                        if (musicApiIsLoading) {
                                          selectedChapter = oldValue!;
                                        }
                                        if (!musicApiIsLoading) {
                                          oldValue = value;
                                          selectedChapter = value!;
                                          print(
                                              " Selected chapter : $selectedChapter");
                                          _booksFuture = getBookChapters(
                                              int.parse(selectedChapter));
                                          _audioPlayer.stop();
                                          checkedIndex = -1;
                                          playAllIsPlaying = false;
                                          isPlaying = false;
                                        }
                                      });
                                    },
                                    buttonStyleData: ButtonStyleData(
                                      height: (screenHeight *
                                          (40 / AppConfig().screenHeight)),
                                      width: (screenWidth *
                                          (311 / AppConfig().screenWidth)),
                                      padding: const EdgeInsets.only(
                                          left: 14, right: 14),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(0),
                                        border: Border.all(
                                          color: Colors.black26,
                                        ),
                                        color: darkMode
                                            ? const Color(0xFF2D281E)
                                            : Colors.white,
                                      ),
                                      elevation: 0,
                                    ),
                                    iconStyleData: IconStyleData(
                                      icon: SvgPicture.asset(
                                        "assets/svg/drop_down.svg",
                                        color: darkMode
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                      iconSize: MediaQuery.of(context)
                                          .textScaler
                                          .scale((screenHeight *
                                              (12 / AppConfig().screenHeight))),
                                      iconEnabledColor: Colors.black,
                                      iconDisabledColor: Colors.black,
                                    ),
                                    dropdownStyleData: DropdownStyleData(
                                      maxHeight:
                                          200, // Adjust this value as needed
                                      width: (screenWidth *
                                          (311 / AppConfig().screenWidth)),
                                      decoration: BoxDecoration(
                                        color: darkMode
                                            ? const Color(0xFF2D281E)
                                            : Colors.white,
                                        borderRadius: BorderRadius.circular(0),
                                      ),
                                      offset: const Offset(0, -10),
                                    ),
                                    menuItemStyleData: const MenuItemStyleData(
                                      height: 30,
                                      padding:
                                          EdgeInsets.only(left: 20, right: 14),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: darkMode ? Colors.black : Colors.white),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal:
                                (screenWidth * (13 / AppConfig().screenWidth)),
                            vertical: (screenHeight *
                                (21 / AppConfig().screenHeight)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    changableLanguage,
                                    style: TextStyle(
                                      color: darkMode
                                          ? const Color(0xFFAF6A06)
                                          : const Color(0xFF623301),
                                      fontSize: MediaQuery.of(context)
                                          .textScaler
                                          .scale((screenHeight *
                                              (12 / AppConfig().screenHeight))),
                                    ),
                                  ),
                                  SizedBox(
                                    height: (screenHeight *
                                        (5 / AppConfig().screenHeight)),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        LanguageTextFile()
                                            .bottomNavEditionDropDown(
                                                getLanguageCode),
                                        style: TextStyle(
                                          color: darkMode
                                              ? const Color(0xFFAF6A06)
                                              : const Color(0xFF623301),
                                          fontSize: MediaQuery.of(context)
                                              .textScaler
                                              .scale((screenHeight *
                                                  (12 /
                                                      AppConfig()
                                                          .screenHeight))),
                                        ),
                                      ),
                                      SizedBox(
                                        height: (screenHeight *
                                            (5 / AppConfig().screenHeight)),
                                      ),
                                      translationIsLoading == false
                                          ? DropdownButtonHideUnderline(
                                              child:
                                                  DropdownButton2<Translations>(
                                                isExpanded: true,
                                                hint: Row(
                                                  children: [
                                                    const SizedBox(
                                                      width: 4,
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                        LanguageTextFile()
                                                            .bottomNavAll(
                                                                getLanguageCode),
                                                        style: TextStyle(
                                                          fontSize: MediaQuery
                                                                  .of(context)
                                                              .textScaler
                                                              .scale((screenHeight *
                                                                  (12 /
                                                                      AppConfig()
                                                                          .screenHeight))),
                                                          color: darkMode
                                                              ? Colors.white
                                                              : Colors.black,
                                                        ),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                items: _translations
                                                    .map(
                                                        (Translations item) =>
                                                            DropdownMenuItem<
                                                                Translations>(
                                                              value: item,
                                                              child: Text(
                                                                item.fullName!,
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: MediaQuery.of(
                                                                          context)
                                                                      .textScaler
                                                                      .scale((screenHeight *
                                                                          (12 /
                                                                              AppConfig().screenHeight))),
                                                                  color: darkMode
                                                                      ? Colors
                                                                          .white
                                                                      : Colors
                                                                          .black,
                                                                ),
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                              ),
                                                            ))
                                                    .toList(),
                                                value: userSelectedTranslation ??
                                                    _translations
                                                        .first, // Set default value
                                                onChanged:
                                                    (Translations? value) {
                                                  Translations? oldTrans;

                                                  setState(() {
                                                    if (musicApiIsLoading) {
                                                      value = oldTrans;
                                                    } else {
                                                      userSelectedTranslation =
                                                          value;
                                                      changableShortName =
                                                          value!.shortName!;
                                                      _booksFuture =
                                                          getBookChapters(int.parse(
                                                              selectedChapter));
                                                      oldTrans = value;
                                                      _audioPlayer.stop();
                                                      playAllIsPlaying = false;
                                                      isPlaying = false;
                                                      playingIndex = -1;
                                                    }
                                                  });
                                                },
                                                buttonStyleData:
                                                    ButtonStyleData(
                                                  height: (screenHeight *
                                                      (40 /
                                                          AppConfig()
                                                              .screenHeight)),
                                                  width: (screenWidth *
                                                      (200 /
                                                          AppConfig()
                                                              .screenWidth)),
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 14, right: 14),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            0),
                                                    border: Border.all(
                                                      color: Colors.black26,
                                                    ),
                                                    color: darkMode
                                                        ? const Color(
                                                            0xFF2D281E)
                                                        : Colors.white,
                                                  ),
                                                  elevation: 0,
                                                ),
                                                iconStyleData: IconStyleData(
                                                  icon: SvgPicture.asset(
                                                      color: darkMode
                                                          ? Colors.white
                                                          : Colors.black,
                                                      "assets/svg/drop_down.svg"),
                                                  iconSize: 12,
                                                  iconEnabledColor:
                                                      Colors.black,
                                                  iconDisabledColor:
                                                      Colors.black,
                                                ),
                                                dropdownStyleData:
                                                    DropdownStyleData(
                                                  maxHeight: 200,
                                                  width: (screenWidth *
                                                      (200 /
                                                          AppConfig()
                                                              .screenWidth)),
                                                  decoration: BoxDecoration(
                                                    color: darkMode
                                                        ? const Color(
                                                            0xFF2D281E)
                                                        : Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            0),
                                                  ),
                                                  offset: const Offset(0, -10),
                                                ),
                                                menuItemStyleData:
                                                    const MenuItemStyleData(
                                                  height: 30,
                                                  padding: EdgeInsets.only(
                                                      left: 20, right: 14),
                                                ),
                                              ),
                                            )
                                          : TextLoaderWidget(
                                              200,
                                              screenHeight *
                                                  (20 /
                                                      AppConfig().screenHeight),
                                              screenHeight *
                                                  (0 /
                                                      AppConfig().screenHeight),
                                              darkMode),
                                    ],
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        FutureBuilder(
                          future: _booksFuture,
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (snapshot.hasError) {
                              return DetailLoaderScreen(
                                screenWidth,
                                screenHeight,
                                darkMode,
                              );
                            } else {
                              chaptersList.clear();

                              return snapshot.data == null
                                  ? DetailLoaderScreen(
                                      screenWidth,
                                      screenHeight,
                                      darkMode,
                                    )
                                  : apiIsloading
                                      ? DetailLoaderScreen(
                                          screenWidth,
                                          screenHeight,
                                          darkMode,
                                        )
                                      : SizedBox(
                                          height: playAllIsPlaying
                                              ? (screenHeight - topKeyHeight)
                                              : null,
                                          width: screenWidth,
                                          child:
                                              ScrollablePositionedList.builder(
                                            itemScrollController:
                                                itemScrollController,
                                            scrollDirection: Axis.vertical,
                                            shrinkWrap: true,
                                            physics: playAllIsPlaying
                                                ? const AlwaysScrollableScrollPhysics()
                                                : const NeverScrollableScrollPhysics(),
                                            itemCount: snapshot.data.length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              listViewMaxLength =
                                                  snapshot.data.length;
                                              verseCount = snapshot.data.length;

                                              BookChapters item =
                                                  snapshot.data[index];

                                              chaptersList.add(item);

                                              print(
                                                  "ListView Length  : $listviewLength");

                                              return Padding(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: (screenWidth *
                                                      (8 /
                                                          AppConfig()
                                                              .screenWidth)),
                                                  vertical: (screenHeight *
                                                      (8 /
                                                          AppConfig()
                                                              .screenHeight)),
                                                ),
                                                child: Container(
                                                  // width: (screenWidth *
                                                  //     (396 /
                                                  //         AppConfig()
                                                  //             .screenWidth)),
                                                  decoration: BoxDecoration(
                                                    color: darkMode
                                                        ? const Color(
                                                            0xFF2D281E)
                                                        : Colors.transparent,
                                                    border: Border.all(
                                                        color: const Color(
                                                            0xFFAF6A06)),
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                      Radius.circular(6),
                                                    ),
                                                  ),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: [
                                                      SizedBox(
                                                        height: (screenHeight *
                                                            (5 /
                                                                AppConfig()
                                                                    .screenHeight)),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                          right: (screenWidth *
                                                              (12 /
                                                                  AppConfig()
                                                                      .screenWidth)),
                                                        ),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            const SizedBox(),
                                                            Text(
                                                              getLanguageCode ==
                                                                      'en'
                                                                  ? "Verse"
                                                                  : "कविता",
                                                              style: TextStyle(
                                                                fontSize: MediaQuery.of(
                                                                        context)
                                                                    .textScaler
                                                                    .scale((screenHeight *
                                                                        (12 /
                                                                            AppConfig().screenHeight))),
                                                                color: const Color(
                                                                    0xFFAF6A06),
                                                              ),
                                                            ),
                                                            GestureDetector(
                                                              onTap: () async {
                                                                print(
                                                                    _audioPlayer
                                                                        .state);

                                                                if (isPlaying) {
                                                                  await _audioPlayer
                                                                      .stop();

                                                                  setState(() {
                                                                    isPlaying =
                                                                        false;
                                                                    playingIndex =
                                                                        -1;
                                                                  });
                                                                } else if (_audioState ==
                                                                        "Pause" ||
                                                                    !isPlaying) {
                                                                  setState(() {
                                                                    isPlaying =
                                                                        true;
                                                                    playingIndex =
                                                                        index;
                                                                  });

                                                                  playAudio(
                                                                    languageCode:
                                                                        getLanguageCode,
                                                                    text: item
                                                                        .text!,
                                                                  );

                                                                  // meaningClick(item);
                                                                }

                                                                checkedIndex =
                                                                    index;
                                                              },
                                                              child: SvgPicture
                                                                  .asset(
                                                                isPlaying &&
                                                                        checkedIndex ==
                                                                            index &&
                                                                        !playAllIsPlaying
                                                                    ? "assets/svg/speaker_on.svg"
                                                                    : "assets/svg/mic_icon.svg",
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
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: (screenHeight *
                                                            (5 /
                                                                AppConfig()
                                                                    .screenHeight)),
                                                      ),
                                                      SvgPicture.asset(
                                                          width: screenWidth,
                                                          "assets/svg/rect_bookdetail.svg"),
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                          bottom: (screenHeight *
                                                              (25 /
                                                                  AppConfig()
                                                                      .screenHeight)),
                                                          top: (screenHeight *
                                                              (33 /
                                                                  AppConfig()
                                                                      .screenHeight)),
                                                          left: (screenWidth *
                                                              28 /
                                                              AppConfig()
                                                                  .screenWidth),
                                                          right: (screenWidth *
                                                              28 /
                                                              AppConfig()
                                                                  .screenWidth),
                                                        ),
                                                        child: index ==
                                                                    playingIndex &&
                                                                _audioPlayer
                                                                        .state ==
                                                                    PlayerState
                                                                        .playing
                                                            ? Container(
                                                                decoration:
                                                                    const BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              10)),
                                                                  gradient:
                                                                      LinearGradient(
                                                                    begin: Alignment
                                                                        .topCenter,
                                                                    end: Alignment
                                                                        .bottomCenter,
                                                                    colors: [
                                                                      Color(
                                                                          0xFFC47807),
                                                                      Color(
                                                                          0xFF643402),
                                                                    ],
                                                                  ), // Set the background color to green
                                                                ),
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          8.0),
                                                                  child: Text(
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    item.text!,
                                                                    style:
                                                                        TextStyle(
                                                                      color: darkMode
                                                                          ? const Color(
                                                                              0xFFFFFFFF)
                                                                          : const Color(
                                                                              0xFF353535),
                                                                      fontSize:
                                                                          (screenHeight *
                                                                              (14 / AppConfig().screenHeight)),
                                                                    ),
                                                                  ),
                                                                ),
                                                              )
                                                            : Text(
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                item.text!,
                                                                style:
                                                                    TextStyle(
                                                                  color: darkMode
                                                                      ? const Color(
                                                                          0xFFFFFFFF)
                                                                      : const Color(
                                                                          0xFF353535),
                                                                  fontSize: MediaQuery.of(
                                                                          context)
                                                                      .textScaler
                                                                      .scale((screenHeight *
                                                                          (14 /
                                                                              AppConfig().screenHeight))),
                                                                ),
                                                              ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                          bottom: (screenHeight *
                                                              (15 /
                                                                  AppConfig()
                                                                      .screenHeight)),
                                                        ),
                                                        child: SvgPicture.asset(
                                                            width: screenWidth,
                                                            "assets/svg/narrow_line.svg"),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        );
                            }
                          },
                        )
                      ],
                    ),
                  ),
                ],
              ),
              !statusBarVisible
                  ? Container(
                      width: screenWidth,
                      height: statusBarHeight,
                      color: darkMode
                          ? AppConfig().chapterScreenBackgroundStartDarkColor
                          : AppConfig().chapterScreenBackgroundStartLightColor,
                    )
                  : const SizedBox(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: (isPlaying || playAllIsPlaying)
          ? musicApiIsLoading
              ? TextLoaderWidget(
                  AppConfig().screenWidth * .8,
                  screenHeight * (50 / AppConfig().screenHeight),
                  screenHeight * (0 / AppConfig().screenHeight),
                  darkMode)
              : Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: (screenWidth * (1 / AppConfig().screenWidth)),
                      vertical:
                          (screenHeight * (1 / AppConfig().screenHeight))),
                  child: Container(
                    height: 50,
                    width: 100,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(colors: [
                        Color(0xFFC47807),
                        Color(0xFF643402),
                      ]),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          color: Colors.white,
                          icon: Icon(_audioState == "Playing"
                              ? Icons.pause
                              : Icons.play_arrow),
                          onPressed: () async {
                            if (_audioState == "Playing") {
                              setState(() {
                                _audioState = "Paused";
                              });
                              await _audioPlayer.pause();
                            } else if (_audioState == "Paused" ||
                                _audioState == "Stopped") {
                              setState(() {
                                _audioState = "Playing";
                              });
                              await _audioPlayer.resume();
                            } else if (_audioState == "Compleated") {
                              setState(() {
                                _audioState = "Playing";
                              });
                              // await _audioPlayer.play(audioText);
                              // playAudio(
                              //   languageCode: getLanguageCode,
                              //   text: chaptersList[verseIdForReplay].text!,
                              // );
                            }
                          },
                        ),
                        Slider(
                          value: position.inSeconds
                              .toDouble()
                              .clamp(0.0, duration.inSeconds.toDouble()),
                          min: 0,
                          max: duration.inSeconds.toDouble(),
                          onChanged: (value) {
                            setState(() {
                              position = Duration(seconds: value.toInt());
                              _audioPlayer.seek(position);
                            });
                          },
                        ),
                        Text(
                          "0.${position.inSeconds}  /  0.${duration.inSeconds} Sec ",
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
    );
  }

  getTransilations() async {
    setState(() {
      translationIsLoading = true;
    });

    languagesList = await ApiHandler.getLanguages();

    print(languagesList);
    if (changableLanguage == "") {
      changableLanguage = "English";
    }

    for (var language in languagesList!) {
      if (language.language == changableLanguage) {
        print("loop");
        _translations = language.translations!;

        break;
      }
    }

    setState(() {
      translationIsLoading = false;
    });
  }

  Future scrollToIndex(int getIndex) async {
    //await autoScrollController.scrollToIndex(getIndex, preferPosition: AutoScrollPosition.begin);
    //await Scrollable.ensureVisible(Key(getIndex.toString().bu));
    //itemScrollController.jumpTo(index: getIndex);
    itemScrollController.scrollTo(
        index: getIndex, duration: const Duration(milliseconds: 500));
  }

  meaningClick(BookChapters getClass) {
    print("chapters length in meaning call ${chaptersList.length}");
    setState(() {
      isAudioWidget = true;
      //  playingIndex = 0;
    });

    for (int i = 0; i < chaptersList.length; i++) {
      print("i value : $i");
      //  getClass.verse = getClass.verse! + 1; // Incrementing getClass.verse by 1

      if (chaptersList[i].verse == getClass.verse) {
        selectedChapterClass = getClass;

        setState(() {
          musicApiIsLoading = true;
          songIsFetching = true;

          playingIndex = i;
        });

        if (i >= 10) {
          playAudio(
            text: chaptersList[i - 2].text!,
            languageCode: getLanguageCode,
          );
        } else {
          playAudio(
            text: chaptersList[i].text!,
            languageCode: getLanguageCode,
          );
        }

        setState(() {
          musicApiIsLoading = true;
          songIsFetching = false;
        });

        // playAllIsPlaying = false;
      } else {
        print(
            " getClass : ${getClass.verse}  chapterVerse:${chaptersList[i].verse}");
        chaptersList[i].versePlaying = false;
      }
    }
  }
}
