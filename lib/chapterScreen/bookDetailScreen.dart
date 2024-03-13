import 'package:bible_gpt/config/app_config.dart';
import 'package:bible_gpt/dashBoardScreen/gptScreen.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:provider/provider.dart';

import '../class/theme_method.dart';

class BookDetailScreen extends StatefulWidget {
  const BookDetailScreen({Key? key}) : super(key: key);

  @override
  State<BookDetailScreen> createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  double screenWidth = 0;
  double screenHeight = 0;
  late bool darkMode;

  int num = 20;

  bool isPlaying = false;

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
      " And the serpent hath been subtile above every beast of\nthe field which Jehovah God hath made, and he saith\nunto the woman, 'Is it true that God hath said, Ye do not\neat of every tree of the garden?";

  String? selectedChapter;
  final FlutterTts fluttertts = FlutterTts();

  Future<List<dynamic>> retrieveVoices() async {
    List<dynamic> voices = await fluttertts.getVoices;

    return voices;
  }

  speak() async {
    List<dynamic> voices = [];
    await fluttertts.setLanguage("en");
    await fluttertts.setPitch(1);
    voices = await retrieveVoices();

    await fluttertts.speak(demoVerse);

    setState(() {
      isPlaying = true;
    });

    fluttertts.setCompletionHandler(() {
      setState(() {
        isPlaying = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    darkMode = themeMethod(context);

    print(darkMode);

    return Scaffold(
      body: SingleChildScrollView(
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
                      horizontal:
                          (screenHeight * (27 / AppConfig().screenHeight)),
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
                          "Judges",
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
                        "Bible / ",
                        style: TextStyle(
                          color: darkMode
                              ? const Color(0xffffffff)
                              : const Color(0xFF353535),
                        ),
                      ),
                      const Text(
                        "Book / ",
                        style: TextStyle(color: Color(0XFFAF6A06)),
                      ),
                      const Text(
                        "Judges",
                        style: TextStyle(color: Color(0XFFAF6A06)),
                      ),
                    ],
                  ),
                  Container(
                    height: (screenHeight * (36 / AppConfig().screenHeight)),
                    width: (screenWidth * (113 / AppConfig().screenWidth)),
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
                          "Play All",
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
                            "Search Chapters",
                            style: TextStyle(
                              color: darkMode
                                  ? const Color(0xFFAF6A06)
                                  : const Color(0xFF623301),
                              fontSize: 12,
                            ),
                          ),
                          SizedBox(
                            height:
                                (screenHeight * (5 / AppConfig().screenHeight)),
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
                                      AppConfig().all,
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
                                  .map(
                                      (String item) => DropdownMenuItem<String>(
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
                                padding:
                                    const EdgeInsets.only(left: 14, right: 14),
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
                                    color:
                                        darkMode ? Colors.white : Colors.black,
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
                                padding: EdgeInsets.only(left: 20, right: 14),
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
              decoration:
                  BoxDecoration(color: darkMode ? Colors.black : Colors.white),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal:
                          (screenWidth * (13 / AppConfig().screenWidth)),
                      vertical:
                          (screenHeight * (21 / AppConfig().screenHeight)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Language",
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
                                        AppConfig().all,
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
                                      (156 / AppConfig().screenWidth)),
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
                                      (156 / AppConfig().screenWidth)),
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
                                  padding: EdgeInsets.only(left: 20, right: 14),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Editions/Transilations",
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
                                            AppConfig().all,
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
                                          (156 / AppConfig().screenWidth)),
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
                                          (156 / AppConfig().screenWidth)),
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
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 5,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal:
                                (screenWidth * (8 / AppConfig().screenWidth)),
                            vertical: (screenHeight *
                                (8 / AppConfig().screenHeight))),
                        child: Container(
                          height:
                              (screenHeight * (207 / AppConfig().screenHeight)),
                          width:
                              (screenWidth * (396 / AppConfig().screenWidth)),
                          decoration: BoxDecoration(
                            color: darkMode
                                ? const Color(0xFF2D281E)
                                : Colors.transparent,
                            border: Border.all(color: const Color(0xFFAF6A06)),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(6),
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                    const Text(
                                      "Verse",
                                      style:
                                          TextStyle(color: Color(0xFFAF6A06)),
                                    ),
                                    GestureDetector(
                                        onTap: () {
                                          speak();
                                          checkedIndex = index;
                                        },
                                        child: SvgPicture.asset(
                                            isPlaying && checkedIndex == index
                                                ? "assets/svg/speaker_on.svg"
                                                : "assets/svg/mic_icon.svg"))
                                  ],
                                ),
                              ),
                              SvgPicture.asset(
                                  "assets/svg/rect_bookdetail.svg"),
                              Text(
                                textAlign: TextAlign.center,
                                "And the serpent hath been subtile above every beast of\nthe field which Jehovah God hath made, and he saith\nunto the woman, 'Is it true that God hath said, Ye do not\neat of every tree of the garden?",
                                style: TextStyle(
                                    color: darkMode
                                        ? const Color(0xFFFFFFFF)
                                        : const Color(0xFF353535),
                                    fontSize: (screenHeight *
                                        (14 / AppConfig().screenHeight))),
                              ),
                              SvgPicture.asset("assets/svg/narrow_line.svg"),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
