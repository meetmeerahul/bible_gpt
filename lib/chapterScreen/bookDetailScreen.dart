import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:bible_gpt/config/app_config.dart';
import 'package:bible_gpt/dashBoardScreen/gptScreen.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../class/LanguageMethod.dart';
import '../class/change_language_local.dart';
import '../class/theme_method.dart';
import '../config/language_text_file.dart';

import 'package:http/http.dart' as http;

import '../widgets/check_internet_method.dart';

class BookDetailScreen extends StatefulWidget {
  const BookDetailScreen({Key? key}) : super(key: key);

  @override
  State<BookDetailScreen> createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  double screenWidth = 0;
  double screenHeight = 0;
  late bool darkMode;

  bool statusBarVisible = true;
  ScrollController pageScrollController = ScrollController();
  double statusBarHeight = 0;

  double positionDouble = 0;
  double durationDouble = 1;

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

  final List<String> items = [
    'Item1',
    'Item2',
    'Item3',
    'Item4',
    'Item5',
    'Item6',
    'Item7',
    'Item8',
  ];

  late int checkedIndex;
  String demoVerse =
      "और सांप मैदान के सब पशुओं से, जिन्हें यहोवा परमेश्वर ने बनाया है, प्रबल हो गया है, और उस ने स्त्री से कहा, क्या सच है, कि परमेश्वर ने कहा है, कि तुम बाटिका के सब वृक्षों का फल नहीं खाते?";

  String? selectedChapter;
  final FlutterTts fluttertts = FlutterTts();

  late var activeSource;

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
                                getLanguageCode == 'en'
                                    ? "Judges"
                                    : "न्यायाधीशों",
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
                              getLanguageCode == 'en'
                                  ? " Judges  "
                                  : " न्यायाधीशों ",
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
                                    items: items
                                        .map((String item) =>
                                            DropdownMenuItem<String>(
                                              value: item,
                                              child: Text(
                                                item,
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: darkMode
                                                      ? Colors.white
                                                      : Colors.black,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ))
                                        .toList(),
                                    value: selectedChapter,
                                    onChanged: (String? value) {
                                      setState(() {
                                        selectedChapter = value;
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
                                          color: darkMode
                                              ? Colors.white
                                              : Colors.black,
                                          "assets/svg/drop_down.svg"),
                                      iconSize: 12,
                                      iconEnabledColor: Colors.black,
                                      iconDisabledColor: Colors.black,
                                    ),
                                    dropdownStyleData: DropdownStyleData(
                                      maxHeight: 200,
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
                                    LanguageTextFile()
                                        .bottomNavLanguageDropDown(
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
                                              LanguageTextFile().bottomNavAll(
                                                  getLanguageCode),
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
                                      items: items
                                          .map((String item) =>
                                              DropdownMenuItem<String>(
                                                value: item,
                                                child: Text(
                                                  item,
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: darkMode
                                                        ? Colors.white
                                                        : Colors.black,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ))
                                          .toList(),
                                      value: selectedChapter,
                                      onChanged: (String? value) {
                                        setState(() {
                                          selectedChapter = value;
                                        });
                                      },
                                      buttonStyleData: ButtonStyleData(
                                        height: (screenHeight *
                                            (40 / AppConfig().screenHeight)),
                                        width: (screenWidth *
                                            (156 / AppConfig().screenWidth)),
                                        padding: const EdgeInsets.only(
                                            left: 14, right: 14),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(0),
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
                                            color: darkMode
                                                ? Colors.white
                                                : Colors.black,
                                            "assets/svg/drop_down.svg"),
                                        iconSize: 12,
                                        iconEnabledColor: Colors.black,
                                        iconDisabledColor: Colors.black,
                                      ),
                                      dropdownStyleData: DropdownStyleData(
                                        maxHeight: 200,
                                        width: (screenWidth *
                                            (156 / AppConfig().screenWidth)),
                                        decoration: BoxDecoration(
                                          color: darkMode
                                              ? const Color(0xFF2D281E)
                                              : Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(0),
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
                                                      .bottomNavAll(
                                                          getLanguageCode),
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: darkMode
                                                        ? Colors.white
                                                        : Colors.black,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                          items: items
                                              .map((String item) =>
                                                  DropdownMenuItem<String>(
                                                    value: item,
                                                    child: Text(
                                                      item,
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color: darkMode
                                                            ? Colors.white
                                                            : Colors.black,
                                                      ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ))
                                              .toList(),
                                          value: selectedChapter,
                                          onChanged: (String? value) {
                                            setState(() {
                                              selectedChapter = value;
                                            });
                                          },
                                          buttonStyleData: ButtonStyleData(
                                            height: (screenHeight *
                                                (40 /
                                                    AppConfig().screenHeight)),
                                            width: (screenWidth *
                                                (156 /
                                                    AppConfig().screenWidth)),
                                            padding: const EdgeInsets.only(
                                                left: 14, right: 14),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(0),
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
                                                color: darkMode
                                                    ? Colors.white
                                                    : Colors.black,
                                                "assets/svg/drop_down.svg"),
                                            iconSize: 12,
                                            iconEnabledColor: Colors.black,
                                            iconDisabledColor: Colors.black,
                                          ),
                                          dropdownStyleData: DropdownStyleData(
                                            maxHeight: 200,
                                            width: (screenWidth *
                                                (156 /
                                                    AppConfig().screenWidth)),
                                            decoration: BoxDecoration(
                                              color: darkMode
                                                  ? const Color(0xFF2D281E)
                                                  : Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(0),
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
                                      ),
                                    ],
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: 5,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: (screenWidth *
                                      (8 / AppConfig().screenWidth)),
                                  vertical: (screenHeight *
                                      (8 / AppConfig().screenHeight))),
                              child: Container(
                                height: (screenHeight *
                                    (207 / AppConfig().screenHeight)),
                                width: (screenWidth *
                                    (396 / AppConfig().screenWidth)),
                                decoration: BoxDecoration(
                                  color: darkMode
                                      ? const Color(0xFF2D281E)
                                      : Colors.transparent,
                                  border: Border.all(
                                      color: const Color(0xFFAF6A06)),
                                  borderRadius: const BorderRadius.all(
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
                                            (12 / AppConfig().screenWidth)),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const SizedBox(),
                                          Text(
                                            getLanguageCode == 'en'
                                                ? "Verse"
                                                : "कविता",
                                            style: const TextStyle(
                                              color: Color(0xFFAF6A06),
                                            ),
                                          ),
                                          GestureDetector(
                                              onTap: () async {
                                                print(_audioPlayer.state);
                                                if (isPlaying) {
                                                  await _audioPlayer.stop();
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
                                              child: SvgPicture.asset(isPlaying &&
                                                      checkedIndex == index
                                                  ? "assets/svg/speaker_on.svg"
                                                  : "assets/svg/mic_icon.svg"))
                                        ],
                                      ),
                                    ),
                                    SvgPicture.asset(
                                        "assets/svg/rect_bookdetail.svg"),
                                    Text(
                                      textAlign: TextAlign.center,
                                      getLanguageCode == 'en'
                                          ? "And the serpent hath been subtile above every beast of\nthe field which Jehovah God hath made, and he saith\nunto the woman, 'Is it true that God hath said, Ye do not\neat of every tree of the garden?"
                                          : "और सांप मैदान के सब पशुओं से, जिन्हें यहोवा परमेश्वर ने बनाया है, \nप्रबल हो गया है, और उस ने स्त्री से कहा, क्या सच है, कि परमेश्वर \nने कहा है, कि तुम बाटिका के सब वृक्षों का फल नहीं खाते?",
                                      style: TextStyle(
                                          color: darkMode
                                              ? const Color(0xFFFFFFFF)
                                              : const Color(0xFF353535),
                                          fontSize: (screenHeight *
                                              (14 / AppConfig().screenHeight))),
                                    ),
                                    SvgPicture.asset(
                                        "assets/svg/narrow_line.svg"),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
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
}
