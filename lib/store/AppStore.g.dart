// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'AppStore.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$AppStore on _AppStore, Store {
  Computed<bool>? _$isAdminComputed;

  @override
  bool get isAdmin => (_$isAdminComputed ??=
          Computed<bool>(() => super.isAdmin, name: '_AppStore.isAdmin'))
      .value;
  Computed<bool>? _$isDemoAdminComputed;

  @override
  bool get isDemoAdmin =>
      (_$isDemoAdminComputed ??= Computed<bool>(() => super.isDemoAdmin,
              name: '_AppStore.isDemoAdmin'))
          .value;

  late final _$isLoaderAtom =
      Atom(name: '_AppStore.isLoader', context: context);

  @override
  bool get isLoader {
    _$isLoaderAtom.reportRead();
    return super.isLoader;
  }

  @override
  set isLoader(bool value) {
    _$isLoaderAtom.reportWrite(value, super.isLoader, () {
      super.isLoader = value;
    });
  }

  late final _$isLoggedInAtom =
      Atom(name: '_AppStore.isLoggedIn', context: context);

  @override
  bool get isLoggedIn {
    _$isLoggedInAtom.reportRead();
    return super.isLoggedIn;
  }

  @override
  set isLoggedIn(bool value) {
    _$isLoggedInAtom.reportWrite(value, super.isLoggedIn, () {
      super.isLoggedIn = value;
    });
  }

  late final _$userNameAtom =
      Atom(name: '_AppStore.userName', context: context);

  @override
  String get userName {
    _$userNameAtom.reportRead();
    return super.userName;
  }

  @override
  set userName(String value) {
    _$userNameAtom.reportWrite(value, super.userName, () {
      super.userName = value;
    });
  }

  late final _$tokenAtom = Atom(name: '_AppStore.token', context: context);

  @override
  String get token {
    _$tokenAtom.reportRead();
    return super.token;
  }

  @override
  set token(String value) {
    _$tokenAtom.reportWrite(value, super.token, () {
      super.token = value;
    });
  }

  late final _$userIdAtom = Atom(name: '_AppStore.userId', context: context);

  @override
  int get userId {
    _$userIdAtom.reportRead();
    return super.userId;
  }

  @override
  set userId(int value) {
    _$userIdAtom.reportWrite(value, super.userId, () {
      super.userId = value;
    });
  }

  late final _$userRoleAtom =
      Atom(name: '_AppStore.userRole', context: context);

  @override
  String get userRole {
    _$userRoleAtom.reportRead();
    return super.userRole;
  }

  @override
  set userRole(String value) {
    _$userRoleAtom.reportWrite(value, super.userRole, () {
      super.userRole = value;
    });
  }

  late final _$userEmailAtom =
      Atom(name: '_AppStore.userEmail', context: context);

  @override
  String get userEmail {
    _$userEmailAtom.reportRead();
    return super.userEmail;
  }

  @override
  set userEmail(String value) {
    _$userEmailAtom.reportWrite(value, super.userEmail, () {
      super.userEmail = value;
    });
  }

  late final _$isDarkModeAtom =
      Atom(name: '_AppStore.isDarkMode', context: context);

  @override
  bool get isDarkMode {
    _$isDarkModeAtom.reportRead();
    return super.isDarkMode;
  }

  @override
  set isDarkMode(bool value) {
    _$isDarkModeAtom.reportWrite(value, super.isDarkMode, () {
      super.isDarkMode = value;
    });
  }

  late final _$selectedLanguageCodeAtom =
      Atom(name: '_AppStore.selectedLanguageCode', context: context);

  @override
  String get selectedLanguageCode {
    _$selectedLanguageCodeAtom.reportRead();
    return super.selectedLanguageCode;
  }

  @override
  set selectedLanguageCode(String value) {
    _$selectedLanguageCodeAtom.reportWrite(value, super.selectedLanguageCode,
        () {
      super.selectedLanguageCode = value;
    });
  }

  late final _$appBarThemeAtom =
      Atom(name: '_AppStore.appBarTheme', context: context);

  @override
  AppBarTheme get appBarTheme {
    _$appBarThemeAtom.reportRead();
    return super.appBarTheme;
  }

  @override
  set appBarTheme(AppBarTheme value) {
    _$appBarThemeAtom.reportWrite(value, super.appBarTheme, () {
      super.appBarTheme = value;
    });
  }

  late final _$userImageUrlAtom =
      Atom(name: '_AppStore.userImageUrl', context: context);

  @override
  String get userImageUrl {
    _$userImageUrlAtom.reportRead();
    return super.userImageUrl;
  }

  @override
  set userImageUrl(String value) {
    _$userImageUrlAtom.reportWrite(value, super.userImageUrl, () {
      super.userImageUrl = value;
    });
  }

  late final _$setUserEmailAsyncAction =
      AsyncAction('_AppStore.setUserEmail', context: context);

  @override
  Future<void> setUserEmail(String val, {bool isInitialization = false}) {
    return _$setUserEmailAsyncAction
        .run(() => super.setUserEmail(val, isInitialization: isInitialization));
  }

  late final _$setUserImageUrlAsyncAction =
      AsyncAction('_AppStore.setUserImageUrl', context: context);

  @override
  Future<void> setUserImageUrl(String val, {bool isInitialization = false}) {
    return _$setUserImageUrlAsyncAction.run(
        () => super.setUserImageUrl(val, isInitialization: isInitialization));
  }

  late final _$setRoleAsyncAction =
      AsyncAction('_AppStore.setRole', context: context);

  @override
  Future<void> setRole(String val, {bool isInitialization = false}) {
    return _$setRoleAsyncAction
        .run(() => super.setRole(val, isInitialization: isInitialization));
  }

  late final _$setUserIDAsyncAction =
      AsyncAction('_AppStore.setUserID', context: context);

  @override
  Future<void> setUserID(int val, {bool isInitialization = false}) {
    return _$setUserIDAsyncAction
        .run(() => super.setUserID(val, isInitialization: isInitialization));
  }

  late final _$setTokenAsyncAction =
      AsyncAction('_AppStore.setToken', context: context);

  @override
  Future<void> setToken(String val, {bool isInitialization = false}) {
    return _$setTokenAsyncAction
        .run(() => super.setToken(val, isInitialization: isInitialization));
  }

  late final _$setUserNameAsyncAction =
      AsyncAction('_AppStore.setUserName', context: context);

  @override
  Future<void> setUserName(String val, {bool isInitializing = false}) {
    return _$setUserNameAsyncAction
        .run(() => super.setUserName(val, isInitializing: isInitializing));
  }

  late final _$setLoginAsyncAction =
      AsyncAction('_AppStore.setLogin', context: context);

  @override
  Future<void> setLogin(bool val, {bool isInitializing = false}) {
    return _$setLoginAsyncAction
        .run(() => super.setLogin(val, isInitializing: isInitializing));
  }

  late final _$setDarkModeAsyncAction =
      AsyncAction('_AppStore.setDarkMode', context: context);

  @override
  Future<void> setDarkMode(bool aIsDarkMode) {
    return _$setDarkModeAsyncAction.run(() => super.setDarkMode(aIsDarkMode));
  }

  late final _$setLanguageAsyncAction =
      AsyncAction('_AppStore.setLanguage', context: context);

  @override
  Future<void> setLanguage(String val) {
    return _$setLanguageAsyncAction.run(() => super.setLanguage(val));
  }

  late final _$_AppStoreActionController =
      ActionController(name: '_AppStore', context: context);

  @override
  void setLoading(bool val) {
    final _$actionInfo =
        _$_AppStoreActionController.startAction(name: '_AppStore.setLoading');
    try {
      return super.setLoading(val);
    } finally {
      _$_AppStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isLoader: ${isLoader},
isLoggedIn: ${isLoggedIn},
userName: ${userName},
token: ${token},
userId: ${userId},
userRole: ${userRole},
userEmail: ${userEmail},
isDarkMode: ${isDarkMode},
selectedLanguageCode: ${selectedLanguageCode},
appBarTheme: ${appBarTheme},
userImageUrl: ${userImageUrl},
isAdmin: ${isAdmin},
isDemoAdmin: ${isDemoAdmin}
    ''';
  }
}
