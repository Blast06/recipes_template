import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:recipe_app/AppTheme.dart';
import 'package:recipe_app/local/BaseLanguage.dart';
import 'package:recipe_app/models/DishTypModel.dart';
import 'package:recipe_app/models/RecipeModel.dart';
import 'package:recipe_app/screen/SplashPage.dart';
import 'package:recipe_app/screen/SplashScreen.dart';
import 'package:recipe_app/store/AppStore.dart';
import 'package:recipe_app/store/filter_store.dart';
import 'package:recipe_app/utils/Colors.dart';
import 'package:recipe_app/utils/Common.dart';
import 'package:recipe_app/utils/Constants.dart';
import 'package:sqflite/sqflite.dart';

import 'controllers/AdmobController.dart';
import 'local/AppLocalizations.dart';
import 'models/RecipeStaticModel.dart';

late PackageInfoData packageInfo;

AppStore appStore = AppStore();
late Database database;
BaseLanguage? language;

RecipeModel? newRecipeModel;
FilterStore filterStore = FilterStore();
List<File> recipeFiles = [];
List<XFile>? xFileImage;
List<DishTypeData> dishTypeList = [];
List<CuisineData> cuisineData = [];

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  defaultAppButtonElevation = 0;
  defaultAppBarElevation = 0.0;
  defaultElevation = 0;
  passwordLengthGlobal = 8;
  desktopBreakpointGlobal = 700.0;

  await initialize(aLocaleLanguageList: languageList());
  packageInfo = await getPackageInfo();

  await appStore.setLanguage(getStringAsync(SELECTED_LANGUAGE_CODE, defaultValue: defaultLanguage));

  if (isMobile) {
    await Firebase.initializeApp();
    await MobileAds.instance.initialize();
  }

  defaultRadius = 16.0;
  defaultLoaderAccentColorGlobal = primaryColor;
  Get.lazyPut(() => AdmobController());

  appStore.setLogin(getBoolAsync(IS_LOGGED_IN), isInitializing: true);
  appStore.setUserName(getStringAsync(USER_NAME), isInitializing: true);
  appStore.setRole(getStringAsync(USER_ROLE_PREF), isInitialization: true);
  appStore.setToken(getStringAsync(API_TOKEN), isInitialization: true);
  appStore.setUserID(getIntAsync(USER_ID), isInitialization: true);
  appStore.setUserEmail(getStringAsync(USER_EMAIL), isInitialization: true);
  appStore.setUserImageUrl(getStringAsync(USER_PHOTO_URL), isInitialization: true);

  int themeModeIndex = getIntAsync(THEME_MODE_INDEX);
  if (themeModeIndex == ThemeModeLight) {
    appStore.setDarkMode(false);
  } else if (themeModeIndex == ThemeModeDark) {
    appStore.setDarkMode(true);
  }

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    setOrientationPortrait();

    LiveStream().on(tokenStream, (v) {
      /*Map req = {
        'email': appStore.userEmail,
        'password': getStringAsync(USER_PASSWORD),
      };

      logInApi(req);*/
    });
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => GetMaterialApp(
        title: mAppName,
        navigatorKey: navigatorKey,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: appStore.isDarkMode ? ThemeMode.dark : ThemeMode.light,
        debugShowCheckedModeBanner: false,
        home: SplashPage(),
        builder: scrollBehaviour(),
        supportedLocales: LanguageDataModel.languageLocales(),
        localizationsDelegates: [AppLocalizations(), GlobalMaterialLocalizations.delegate, GlobalWidgetsLocalizations.delegate],
        localeResolutionCallback: (locale, supportedLocales) => locale,
        locale: Locale(appStore.selectedLanguageCode),
      ),
    );
  }
}
