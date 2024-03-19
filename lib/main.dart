import 'package:bible_gpt/class/theme_method.dart';
import 'package:bible_gpt/config/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'class/change_language_local.dart';
import 'class/change_theme_local.dart';
import 'config/app_config.dart';
import 'dashBoardScreen/dash_board_screen.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ChangeLanguageLocal>(
          create: (context) => ChangeLanguageLocal(),
        ),
        ChangeNotifierProvider<ChangeThemeLocal>(
          create: (context) => ChangeThemeLocal(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double screenWidth = 0;
  double screenHeight = 0;
  late var theme;
  //late int selectedLanguage;
  String selectedLanguageCode = "en";
  late var language;
  // late bool darkMode;

  navigateToDashboardScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const DashboardScreen(),
      ),
    ).then(
      (value) {
        SystemNavigator.pop();
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    FlutterNativeSplash.remove();
    assignTheme();
    // darkMode = assignTheme();

    assignLanguage();
    Future.delayed(const Duration(milliseconds: 100)).then((value) {
      navigateToDashboardScreen();
    });
  }

  assignTheme() {
    SharedPreference.instance.getOnDarkMode("darkMode").then((value) {
      print("Main Screen $value");
      if (value) {
        setState(() {
          theme.setTheme(value);
        });
      }
    });
  }

  assignLanguage() {
    SharedPreference.instance.getSelectedLanguage("language").then((value) {
      print("Main Screen $value");
      language.setLanguage(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    theme = Provider.of<ChangeThemeLocal>(context);
    language = Provider.of<ChangeLanguageLocal>(context);
    // selectedLanguageCode = language.getLanguage;

    // darkMode = themeMethod(context);

    AppConfig().getStatusBar(false);

    // print(darkMode);

    return Scaffold(
      body: SizedBox(
        width: screenWidth,
        height: screenHeight,
        child: Image.asset(
          AppConfig().splashScreenImage,
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
