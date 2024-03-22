class ChapterHomeListClass {
  int? bookid;
  String? name;
  int? chronOrder;
  int? chapters;
  bool isSelected = false;
  bool isRecentSelected = false;

  ChapterHomeListClass({
    this.bookid,
    this.name,
    this.chronOrder,
    this.chapters,
  });

  ChapterHomeListClass.fromJson(Map<String, dynamic> json) {
    bookid = json['bookid'];
    name = json['name'];
    chronOrder = json['chronorder'];
    chapters = json['chapters'];
  }

  Map<String, dynamic> toJson() {
    return {
      'bookid': bookid,
      'name': name,
      'chronorder': chronOrder,
      'chapters': chapters,
    };
  }
}
