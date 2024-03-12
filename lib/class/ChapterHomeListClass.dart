class ChapterHomeListClass {
  int id;
  String chapterName;
  int chapterNumber;
  String chapterNameMeaning;
  int slockCount;
  bool isSelected;
  bool isRecentSelected;

  ChapterHomeListClass({
    required this.id,
    required this.chapterName,
    required this.chapterNumber,
    required this.chapterNameMeaning,
    required this.slockCount,
    required this.isSelected,
    required this.isRecentSelected,
  });

  factory ChapterHomeListClass.fromJson(Map<String, dynamic> json) =>
      ChapterHomeListClass(
        id: json["id"],
        chapterName: json["chapterName"],
        chapterNumber: json["chapterNumber"],
        chapterNameMeaning: json["chapterNameMeaning"],
        slockCount: json["slockCount"],
        isSelected: json["isSelected"],
        isRecentSelected: json["isRecentSelected"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "chapterName": chapterName,
        "chapterNumber": chapterNumber,
        "chapterNameMeaning": chapterNameMeaning,
        "slockCount": slockCount,
        "isSelected": isSelected,
        "isRecentSelected": isRecentSelected,
      };
}
