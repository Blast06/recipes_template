import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:recipe_app/network/RestApis.dart';
import 'package:recipe_app/screen/AboutAppScreen.dart';
import 'package:recipe_app/screen/admin/AdminSettingScreen.dart';
import 'package:recipe_app/screen/auth/ChangePasswordScreen.dart';
import 'package:recipe_app/screen/auth/SignInScreen.dart';
import 'package:recipe_app/screen/user/BookMarkScreen.dart';
import 'package:recipe_app/utils/Colors.dart';
import 'package:recipe_app/utils/Common.dart';
import 'package:recipe_app/utils/Constants.dart';
import 'package:share/share.dart';

import '../main.dart';

class SettingMobileWidget extends StatefulWidget {
  @override
  SettingMobileWidgetState createState() => SettingMobileWidgetState();
}

class SettingMobileWidgetState extends State<SettingMobileWidget> {
  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SettingItemWidget(
          leading: Icon(MaterialCommunityIcons.theme_light_dark),
          title: language!.selectTheme,
          subTitle: themeModeList[getIntAsync(THEME_MODE_INDEX)],
          onTap: () async {
            showInDialog(
              context,
              builder: (_) => Container(
                width: 500,
                child: ThemeWidget(
                  onThemeChanged: (val) {
                    if (val == ThemeModeSystem) {
                      appStore.setDarkMode(MediaQuery.of(context).platformBrightness == Brightness.dark);
                    } else if (val == ThemeModeLight) {
                      appStore.setDarkMode(false);
                    } else if (val == ThemeModeDark) {
                      appStore.setDarkMode(true);
                    }
                    LiveStream().emit(streamRefreshToDo);

                    finish(context);
                  },
                ),
              ),
              contentPadding: EdgeInsets.zero,
              title: Text(language!.selectTheme, style: primaryTextStyle(size: 20)),
            );
          },
        ),
        SettingItemWidget(
          leading: Icon(FontAwesome.language, color: context.iconColor),
          title: language!.language,
          subTitle: getSelectedLanguageModel()?.name.validate(),
          onTap: () {
            Scaffold(
              appBar: appBarWidget(language!.language),
              body: LanguageListWidget(
                widgetType: WidgetType.LIST,
                onLanguageChange: (v) async {
                  await appStore.setLanguage(v.languageCode!);

                  LiveStream().emit(streamRefreshToDo);

                  setState(() {});
                  finish(context);
                },
              ).paddingSymmetric(vertical: 16),
            ).launch(context);
          },
        ),
        SettingItemWidget(
          leading: Icon(Icons.admin_panel_settings_outlined),
          title: language!.adminSetting,
          onTap: () {
            AdminSettingScreen().launch(context);
          },
        ).visible(appStore.isAdmin || appStore.isDemoAdmin),
        SettingItemWidget(
          leading: Icon(Icons.bookmark_border_sharp),
          title: language!.bookmark,
          onTap: () {
            BookMarkScreen(isProfile: true).launch(context);
          },
        ).visible((getBoolAsync(IS_LOGGED_IN)) && (!appStore.isAdmin && !appStore.isDemoAdmin)),
        SettingItemWidget(
          leading: Icon(Ionicons.key_outline),
          title: language!.changePassword,
          onTap: () {
            ChangePasswordScreen().launch(context);
          },
        ).visible(getBoolAsync(IS_LOGGED_IN) && !getBoolAsync(IS_SOCIAL_LOGIN)),
        SettingItemWidget(
          leading: Icon(Icons.assignment_outlined),
          title: language!.privacyPolicy,
          onTap: () {
            if (PrivacyPolicy.isNotEmpty) {
              launchUrl(PrivacyPolicy, forceWebView: true);
            }
          },
        ),
        SettingItemWidget(
          leading: Icon(Icons.support_rounded),
          title: language!.helpSupport,
          onTap: () {
            launchUrl(helpSupport, forceWebView: true);
          },
        ),
        SettingItemWidget(
          leading: Icon(Icons.share_outlined),
          title: language!.shareApp,
          onTap: () {
            Share.share('Share $mAppName app\n\n${storeBaseURL()}${packageInfo.packageName}');
          },
        ).visible(isMobile),
        SettingItemWidget(
          leading: Icon(Icons.info_outline),
          title: language!.about,
          onTap: () {
            AboutAppScreen().launch(context);
          },
        ),
        SettingItemWidget(
          leading: Icon(Icons.exit_to_app_rounded),
          title: appStore.isLoggedIn ? language!.logout : language!.login,
          onTap: () async {
            if (appStore.isLoggedIn) {
              await showConfirmDialogCustom(
                context,
                primaryColor: primaryColor,
                title: language!.doYouWantToLogout,
                positiveText: language!.yes,
                negativeText: language!.cancel,
                onAccept: (c) {
                  logout(context);
                },
              );
            } else {
              SignInScreen().launch(context, duration: Duration(milliseconds: 300));
            }
          },
        ).visible(getBoolAsync(IS_LOGGED_IN)),
      ],
    );
  }
}
