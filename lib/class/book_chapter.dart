class BookChapters {
  int? pk;
  int? verse;
  String? text;
  bool? versePlaying;

  BookChapters({this.pk, this.verse, this.text, this.versePlaying});

  BookChapters.fromJson(Map<String, dynamic> json) {
    pk = json['pk'];
    verse = json['verse'];
    text = json['text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['pk'] = pk;
    data['verse'] = verse;
    data['text'] = text;
    return data;
  }

  static List<BookChapters> bookDataFromAPi(List<dynamic> bookSnapshot) {
    return bookSnapshot.map((json) => BookChapters.fromJson(json)).toList();
  }
}
