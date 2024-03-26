import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
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

import '../class/LanguageMethod.dart';
import '../class/change_language_local.dart';
import '../class/languages_and_transilations.dart';
import '../class/theme_method.dart';
import '../config/language_text_file.dart';

import 'package:http/http.dart' as http;

import '../dashBoardScreen/noInternetScreen.dart';
import '../loader/widget/TextLoaderWidget.dart';
import '../widgets/check_internet_method.dart';

class RecentBookDetailScreen extends StatefulWidget {
  final String bookid;
  final String chapterCOunt;
  final String chapterName;
  const RecentBookDetailScreen(
      {super.key,
      required this.bookid,
      required this.chapterCOunt,
      required this.chapterName});

  @override
  State<RecentBookDetailScreen> createState() => RecentBookDetail(
      bookid: bookid, chapterCOunt: chapterCOunt, chapterName: chapterName);
}

class RecentBookDetail extends State<RecentBookDetailScreen> {
  double screenWidth = 0;
  double screenHeight = 0;
  late bool darkMode;

  String bookid;
  String chapterCOunt;
  String chapterName;

  RecentBookDetail(
      {Key? key,
      required this.bookid,
      required this.chapterCOunt,
      required this.chapterName});

  bool statusBarVisible = true;
  ScrollController pageScrollController = ScrollController();
  double statusBarHeight = 0;

  double positionDouble = 0;
  double durationDouble = 1;

  bool translationIsLoading = false;

  final AudioPlayer _audioPlayer = AudioPlayer();
  String _audioState = 'Stopped';
  double _position = 0;
  double _duration = 0;

  Duration totalDuration = const Duration();
  Duration currentPosition = const Duration();

  late String getLanguageCode;
  late ChangeLanguageLocal languageLocal;

  int num = 20;

  bool isPlaying = false;
  bool isPause = false;

  bool apiIsloading = true;

  // List<Translations>? _selectedTranslations;
  List<LanguagesAndTransilations>? languagesList;

  Translations? userSelectedTranslation;

  late int checkedIndex;

  String selectedChapter = "1";
  final FlutterTts fluttertts = FlutterTts();

  late var activeSource;

  late Future<List<BookChapters>> _booksFuture;
  late List<Translations> _translations;

  // Uint8List audioData =
  //     Uint8List.fromList(base64.decode(await fluttertts.speak(demoVerse)));
  // activeSource = BytesSource(audioData);

  // print(activeSource);
  // // player.play(BytesSource(audioData));

  getLanguage() {
    languageLocal = Provider.of<ChangeLanguageLocal>(context);
    getLanguageCode = languageMethod(context);
    print("Language in details :$getLanguageCode");
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    scrollinit();
    _booksFuture = getBookChapters(0);

    getTransilations();

    setState(() {
      apiIsloading = false;
    });

    _audioPlayer.onPlayerStateChanged.listen((event) {
      if (event == PlayerState.playing) {
        setState(() {
          _audioState = 'Playing';
        });
      } else if (event == PlayerState.paused) {
        setState(() {
          _audioState = 'Paused';
        });
      } else if (event == PlayerState.stopped) {
        setState(() {
          _audioState = 'Stopped';
          _position = 0;
        });
      }
    });

    _audioPlayer.onDurationChanged.listen((duration) {
      setState(() {
        _duration = duration.inSeconds.toDouble();
      });
    });

    _audioPlayer.onPositionChanged.listen((position) {
      setState(() {
        _position = position.inSeconds.toDouble();
      });
    });
  }

  scrollinit() async {
    bool internetConnectCheck = await CheckInternetConnectionMethod();
    if (internetConnectCheck) {
      pageScrollController.addListener(() {
        if (pageScrollController.offset > 0) {
          if (statusBarVisible) {
            setState(() {
              statusBarVisible = !statusBarVisible;
            });
          }
        } else {
          setState(() {
            statusBarVisible = !statusBarVisible;
          });
        }
      });
    }
  }

  Future<List<BookChapters>> getBookChapters(int chapter) async {
    late String chapterNumber;

    if (chapter == 0) {
      chapterNumber = 1.toString();

      setState(() {
        apiIsloading = true;
      });

      return await ApiHandler.getChaptersContents(
          changableShortName, bookid, chapterNumber);
    } else {
      chapterNumber = chapter.toString();

      setState(() {
        apiIsloading = true;
      });

      return await ApiHandler.getChaptersContents(
          changableShortName, bookid, chapterNumber);
    }
  }

  Future<void> playAudio() async {
    final response = await http.get(Uri.parse(
        'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-12.mp3'));
    final bytes = response.bodyBytes;
    final file = File('${(await getTemporaryDirectory()).path}/temp_audio.mp3');
    await file.writeAsBytes(bytes);
    activeSource = DeviceFileSource(file.path);
    _audioPlayer.play(DeviceFileSource(file.path));
  }

  Future<void> stop() async {
    await _audioPlayer.stop();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    stop();
    pageScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    statusBarHeight = MediaQuery.of(context).padding.top;
    darkMode = themeMethod(context);

    getLanguage();
    print(darkMode);
    print(("ook id : ${widget.bookid}"));
    print(" BookId-------${widget.chapterCOunt}");
    print("book name $chapterName");
    // print(" Chapters-------${widget.chapterCount}");
    return Scaffold(
      body: Container(
        child: Stack(
          children: [
            SingleChildScrollView(
              controller: pageScrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  Container(
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
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () => Navigator.of(context).pop(),
                                child: SvgPicture.asset(
                                    color: darkMode
                                        ? const Color(0xffffffff)
                                        : const Color(0xff000000),
                                    "assets/svg/back_arrow.svg"),
                              ),
                              Text(
                                textAlign: TextAlign.center,
                                chapterName,
                                style: TextStyle(
                                    color: darkMode
                                        ? const Color(0xffffffff)
                                        : const Color(0xFF353535),
                                    fontSize: 18),
                              ),
                              GestureDetector(
                                onTap: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => const GptScreen(),
                                  ),
                                ),
                                child: SvgPicture.asset(
                                    color: darkMode
                                        ? const Color(0xffffffff)
                                        : const Color(0xff000000),
                                    "assets/svg/search_icon.svg"),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              getLanguageCode == 'en'
                                  ? "Bible / "
                                  : " बाइबिल /",
                              style: TextStyle(
                                color: darkMode
                                    ? const Color(0xffffffff)
                                    : const Color(0xFF353535),
                              ),
                            ),
                            Text(
                              getLanguageCode == 'en' ? " Book / " : " किताब /",
                              style: const TextStyle(color: Color(0XFFAF6A06)),
                            ),
                            Text(
                              chapterName,
                              style: const TextStyle(color: Color(0XFFAF6A06)),
                            ),
                          ],
                        ),
                        Container(
                          height:
                              (screenHeight * (36 / AppConfig().screenHeight)),
                          width:
                              (screenWidth * (113 / AppConfig().screenWidth)),
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(30)),
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
                                  width: (screenWidth *
                                      (10.87 / AppConfig().screenWidth)),
                                  height: (screenHeight *
                                      (12 / AppConfig().screenHeight)),
                                  "assets/svg/play_icon.svg"),
                              Text(
                                getLanguageCode == 'en'
                                    ? "Play All"
                                    : "सभी खेलना",
                                style: TextStyle(
                                  color: const Color(0xFFFFFFFF),
                                  fontSize: (screenHeight *
                                      (16 / AppConfig().screenHeight)),
                                ),
                              ),
                            ],
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
                                    fontSize: 12,
                                  ),
                                ),
                                SizedBox(
                                  height: (screenHeight *
                                      (5 / AppConfig().screenHeight)),
                                ),
                                DropdownButtonHideUnderline(
                                  child: DropdownButton2<String>(
                                    isExpanded: true,
                                    hint: Row(
                                      children: [
                                        const SizedBox(
                                          width: 4,
                                        ),
                                        Expanded(
                                          child: Text(
                                            LanguageTextFile()
                                                .bottomNavAll(getLanguageCode),
                                            style: TextStyle(
                                              fontSize: 12,
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
                                            fontSize: 12,
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
                                      setState(() {
                                        selectedChapter = value!;
                                        apiIsloading = !apiIsloading;
                                        _booksFuture = getBookChapters(
                                            int.parse(selectedChapter));
                                      });

                                      setState(() {
                                        apiIsloading = false;
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
                                      iconSize: 12,
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
                                      fontSize: 12,
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
                                          fontSize: 12,
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
                                                          fontSize: 12,
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
                                                    .map((Translations item) =>
                                                        DropdownMenuItem<
                                                            Translations>(
                                                          value: item,
                                                          child: Text(
                                                            item.fullName!,
                                                            style: TextStyle(
                                                              fontSize: 12,
                                                              color: darkMode
                                                                  ? Colors.white
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
                                                  setState(() {
                                                    apiIsloading = true;
                                                    userSelectedTranslation =
                                                        value;
                                                    changableShortName =
                                                        value!.shortName!;
                                                    _booksFuture =
                                                        getBookChapters(int.parse(
                                                            selectedChapter));
                                                    apiIsloading = false;
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
                              // return const NoInternetScreen();

                              return const SizedBox(
                                height: 500,
                                child: Center(
                                  child: Text(
                                      'Some error Happended in Loaading the data '),
                                ),
                              );
                            } else {
                              return (!snapshot.hasData) ||
                                      (snapshot.hasData && apiIsloading)
                                  ? DetailLoaderScreen(
                                      screenWidth, screenHeight, darkMode)
                                  : ListView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: snapshot.data.length,
                                      primary: false,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        BookChapters item =
                                            snapshot.data[index];
                                        return Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: (screenWidth *
                                                  (8 /
                                                      AppConfig().screenWidth)),
                                              vertical: (screenHeight *
                                                  (8 /
                                                      AppConfig()
                                                          .screenHeight))),
                                          child: Container(
                                            height: (screenHeight *
                                                (220 /
                                                    AppConfig().screenHeight)),
                                            width: (screenWidth *
                                                (396 /
                                                    AppConfig().screenWidth)),
                                            decoration: BoxDecoration(
                                              color: darkMode
                                                  ? const Color(0xFF2D281E)
                                                  : Colors.transparent,
                                              border: Border.all(
                                                  color:
                                                      const Color(0xFFAF6A06)),
                                              borderRadius:
                                                  const BorderRadius.all(
                                                Radius.circular(6),
                                              ),
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.only(
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
                                                        getLanguageCode == 'en'
                                                            ? "Verse"
                                                            : "कविता",
                                                        style: const TextStyle(
                                                          color:
                                                              Color(0xFFAF6A06),
                                                        ),
                                                      ),
                                                      GestureDetector(
                                                        onTap: () async {
                                                          print(_audioPlayer
                                                              .state);
                                                          if (isPlaying) {
                                                            await _audioPlayer
                                                                .stop();
                                                            setState(() {
                                                              isPlaying = false;
                                                            });
                                                          } else if (_audioState ==
                                                                  "Pause" ||
                                                              !isPlaying) {
                                                            setState(() {
                                                              isPlaying = true;
                                                            });
                                                            playAudio();
                                                          }
                                                          checkedIndex = index;
                                                        },
                                                        child: SvgPicture.asset(
                                                            isPlaying &&
                                                                    checkedIndex ==
                                                                        index
                                                                ? "assets/svg/speaker_on.svg"
                                                                : "assets/svg/mic_icon.svg"),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SvgPicture.asset(
                                                    "assets/svg/rect_bookdetail.svg"),
                                                Padding(
                                                  padding: EdgeInsets.only(
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
                                                  child: Text(
                                                    textAlign: TextAlign.center,
                                                    item.text!,
                                                    style: TextStyle(
                                                      color: darkMode
                                                          ? const Color(
                                                              0xFFFFFFFF)
                                                          : const Color(
                                                              0xFF353535),
                                                      fontSize: (screenHeight *
                                                          (14 /
                                                              AppConfig()
                                                                  .screenHeight)),
                                                    ),
                                                  ),
                                                ),
                                                SvgPicture.asset(
                                                    "assets/svg/narrow_line.svg"),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                            }
                          },
                        )
                      ],
                    ),
                  ),
                ],
              ),
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
      bottomNavigationBar: isPlaying
          ? Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: (screenWidth * (1 / AppConfig().screenWidth)),
                  vertical: (screenHeight * (1 / AppConfig().screenHeight))),
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
                      icon: Icon(_audioState == 'Playing'
                          ? Icons.pause
                          : Icons.play_arrow),
                      onPressed: () async {
                        if (_audioState == "Playing") {
                          await _audioPlayer.pause();
                        } else if (_audioState == "Paused" ||
                            _audioState == "Stopped") {
                          playAudio();
                        }
                      },
                    ),
                    Slider(
                      value: _position,
                      min: 0.0,
                      max: _duration,
                      onChanged: (value) {
                        setState(() {
                          _position = value;
                          _audioPlayer.seek(Duration(seconds: value.toInt()));
                        });
                      },
                    ),
                    Text(
                      "${_position.toStringAsFixed(0).toString()}  / ${_duration.toStringAsFixed(0).toString()} sec",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize:
                            (screenHeight * (12 / AppConfig().screenHeight)),
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
}
