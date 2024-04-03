import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import 'change_theme_local.dart';

bool themeMethod(BuildContext context) {
  var theme = Provider.of<ChangeThemeLocal>(context);
  
  return theme.getTheme();
}
