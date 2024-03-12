import 'ChapterTranslationListClass.dart';

class ChapterDetailListClass {
  int chapterId;
  int verseNumber;
  String chapterMeaningText;
  String chapterTranslatorText;
  bool meaningPlaying;
  bool translatePlaying;
  List<ChapterTranslationListClass> translationListClass;

  ChapterDetailListClass(
      {required this.chapterId,
      required this.verseNumber,
      required this.chapterMeaningText,
      required this.chapterTranslatorText,
      required this.meaningPlaying,
      required this.translatePlaying,
      required this.translationListClass});
}
