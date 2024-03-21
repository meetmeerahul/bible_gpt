// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class AllChapters {
  int? bookid;
  String? name;
  int? chronorder;
  int? chapters;
  bool isSelected = false;
  bool isRecentSelected = false;

  AllChapters({
    required this.bookid,
    required this.name,
    required this.chronorder,
    required this.chapters,
    required this.isSelected,
    required this.isRecentSelected,
  });

  AllChapters.fromJson(Map<String, dynamic> json) {
    bookid = json['bookid'];
    name = json['name'];
    chronorder = json['chronorder'];
    chapters = json['chapters'];
    isSelected = json["isSelected"];
    isRecentSelected = json["isRecentSelected"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['bookid'] = bookid;
    data['name'] = name;
    data['chronorder'] = chronorder;
    data['chapters'] = chapters;

    return data;
  }
}
