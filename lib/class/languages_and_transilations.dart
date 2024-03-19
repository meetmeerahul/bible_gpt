class LanguagesAndTransilations {
  String? language;
  List<Translations>? translations;

  LanguagesAndTransilations({this.language, this.translations});

  LanguagesAndTransilations.fromJson(Map<String, dynamic> json) {
    language = json['language'];
    if (json['translations'] != null) {
      translations = <Translations>[];
      json['translations'].forEach((v) {
        translations!.add(Translations.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['language'] = language;
    if (translations != null) {
      data['translations'] = translations!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  static List<LanguagesAndTransilations> languagesFromAPi(
      List<dynamic> languagesSnapshot) {
    return languagesSnapshot
        .map((json) => LanguagesAndTransilations.fromJson(json))
        .toList();
  }
}

class Translations {
  String? shortName;
  String? fullName;
  String? info;
  int? updated;

  Translations({this.shortName, this.fullName, this.info, this.updated});

  Translations.fromJson(Map<String, dynamic> json) {
    shortName = json['short_name'];
    fullName = json['full_name'];
    info = json['info'];
    updated = json['updated'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['short_name'] = shortName;
    data['full_name'] = fullName;
    data['info'] = info;
    data['updated'] = updated;
    return data;
  }
}
