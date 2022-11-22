import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:recipe_app/local/AppLocalizations.dart';
import 'package:recipe_app/utils/Colors.dart';
import 'package:recipe_app/utils/Constants.dart';

import '../main.dart';

part 'AppStore.g.dart';

class AppStore = _AppStore with _$AppStore;

abstract class _AppStore with Store {
  @observable
  bool isLoader = false;

  @observable
  bool isLoggedIn = false;

  @observable
  String userName = '';

  @observable
  String token = '';

  @observable
  int userId = 0;

  @computed
  bool get isAdmin => userRole == ROLE_ADMIN;

  @observable
  String userRole = '';

  @observable
  String userEmail = '';

  @observable
  bool isDarkMode = false;

  @computed
  bool get isDemoAdmin => userRole == ROLE_DEMO;

  @observable
  String selectedLanguageCode = defaultLanguage;

  @observable
  AppBarTheme appBarTheme = AppBarTheme();

  @observable
  String userImageUrl = '';

  @action
  Future<void> setUserEmail(String val, {bool isInitialization = false}) async {
    userEmail = val;
    if (!isInitialization) await setValue(USER_EMAIL, val);
  }

  @action
  Future<void> setUserImageUrl(String val, {bool isInitialization = false}) async {
    userImageUrl = val;
    if (!isInitialization) await setValue(USER_PHOTO_URL, val);
  }

  @action
  Future<void> setRole(String val, {bool isInitialization = false}) async {
    userRole = val;
    if (!isInitialization) await setValue(USER_ROLE_PREF, val);
  }

  @action
  Future<void> setUserID(int val, {bool isInitialization = false}) async {
    userId = val;
    if (!isInitialization) await setValue(USER_ID, val);
  }

  @action
  Future<void> setToken(String val, {bool isInitialization = false}) async {
    token = val;
    if (!isInitialization) await setValue(API_TOKEN, val);
  }

  @action
  Future<void> setUserName(String val, {bool isInitializing = false}) async {
    userName = val;
    if (!isInitializing) await setValue(USER_NAME, val);
  }

  @action
  void setLoading(bool val) {
    isLoader = val;
  }

  @action
  Future<void> setLogin(bool val, {bool isInitializing = false}) async {
    isLoggedIn = val;
    if (!isInitializing) await setValue(IS_LOGGED_IN, val);
  }

  @action
  Future<void> setDarkMode(bool aIsDarkMode) async {
    isDarkMode = aIsDarkMode;

    if (isDarkMode) {
      textPrimaryColorGlobal = Colors.white;
      textSecondaryColorGlobal = textSecondaryColor;

      defaultLoaderBgColorGlobal = scaffoldSecondaryDark;
      defaultLoaderAccentColorGlobal = primaryColor;

      appButtonBackgroundColorGlobal = appButtonColorDark;
      //shadowColorGlobal = Colors.white12;

      appBarBackgroundColorGlobal = scaffoldSecondaryDark;

      setStatusBarColor(scaffoldSecondaryDark);
    } else {
      textPrimaryColorGlobal = textPrimaryColor;
      textSecondaryColorGlobal = textSecondaryColor;

      defaultLoaderBgColorGlobal = Colors.white;
      defaultLoaderAccentColorGlobal = primaryColor;

      appButtonBackgroundColorGlobal = Colors.white;
      //shadowColorGlobal = Colors.black12;

      appBarBackgroundColorGlobal = Colors.white;

      setStatusBarColor(Colors.white);
    }

    shadowColorGlobal = Colors.transparent;
  }

  @action
  Future<void> setLanguage(String val) async {
    selectedLanguageCode = val;
    selectedLanguageDataModel = getSelectedLanguageModel();

    await setValue(SELECTED_LANGUAGE_CODE, selectedLanguageCode);

    language = await AppLocalizations().load(Locale(selectedLanguageCode));

    errorInternetNotAvailable = language!.yourInterNetNotWorking;
  }
}
