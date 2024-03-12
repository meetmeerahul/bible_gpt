import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import 'change_language_local.dart';

String languageMethod(BuildContext context) {
  var language = Provider.of<ChangeLanguageLocal>(context);
  return language.getLanguage();
}
