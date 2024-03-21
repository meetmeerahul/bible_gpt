class BookDetails {
  int? bookid;
  String? name;
  int? chapters;
  int? chronorder;

  BookDetails({this.bookid, this.name, this.chapters, this.chronorder});

  BookDetails.fromJson(Map<String, dynamic> json) {
    bookid = json['bookid'];
    name = json['name'];
    chapters = json['chapters'];
    chronorder = json['chronorder'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['bookid'] = bookid;
    data['name'] = name;
    data['chapters'] = chapters;
    data['chronorder'] = chronorder;
    return data;
  }

  static List<BookDetails> bookDetailsFromApi(
      List<dynamic> bookDetailsSnapshot) {
    return bookDetailsSnapshot
        .map((json) => BookDetails.fromJson(json))
        .toList();
  }
}
