import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:recipe_app/components/ChangePasswordFieldWidget.dart';
import 'package:recipe_app/components/FixSizedBox.dart';
import 'package:recipe_app/models/AppModel.dart';
import 'package:recipe_app/network/RestApis.dart';
import 'package:recipe_app/utils/Colors.dart';
import 'package:recipe_app/utils/Common.dart';
import 'package:recipe_app/utils/Constants.dart';
import 'package:recipe_app/utils/DataProvider.dart';

import '../main.dart';

class SettingWebWidget extends StatefulWidget {
  @override
  SettingWebWidgetState createState() => SettingWebWidgetState();
}

class SettingWebWidgetState extends State<SettingWebWidget> {
  ScrollController _scrollController = ScrollController();
  List<AppModel> settingData = getSettingData();
  int selected = 0;

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
    return Scrollbar(
      controller: _scrollController,
      child: SingleChildScrollView(
        controller: _scrollController,
        padding: EdgeInsets.symmetric(vertical: 16),
        child: FixSizedBox(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(language!.setting, style: boldTextStyle(size: 24)),
              32.height,
              Wrap(
                runSpacing: 24,
                spacing: 24,
                children: settingData.map(
                  (e) {
                    int index = settingData.indexOf(e);
                    return HoverWidget(
                      builder: (_, isHovered) {
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          height: 160,
                          width: ((context.width() * 0.5) / 3) - 48,
                          decoration: BoxDecoration(
                            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8.0)],
                            borderRadius: BorderRadius.circular(defaultRadius),
                            color: isHovered ? primaryColor : context.cardColor,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(settingData[index].icon, size: 32, color: isHovered ? Colors.white : context.iconColor),
                              16.height,
                              Text(settingData[index].name!, style: boldTextStyle(color: isHovered ? Colors.white : context.iconColor)).paddingSymmetric(horizontal: 16),
                            ],
                          ),
                        ).onTap(() async {
                          if (index == 0) {
                            await showInDialog(
                              context,
                              builder: (_) {
                                return SizedBox(
                                  height: 200,
                                  width: 200,
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
                                      LiveStream().emit(streamRefreshRecipeIndex, '');

                                      finish(context);
                                    },
                                  ),
                                );
                              },
                            );
                          } else if (index == 1) {
                            await showInDialog(context, builder: (_) {
                              return AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                height: 300,
                                width: 300,
                                child: LanguageListWidget(
                                  widgetType: WidgetType.LIST,
                                  onLanguageChange: (v) async {
                                    await appStore.setLanguage(v.languageCode!);

                                    LiveStream().emit(streamRefreshLanguage);
                                    settingData.clear();
                                    settingData = getSettingData();

                                    setState(() {});
                                    finish(context);
                                  },
                                ).paddingSymmetric(vertical: 16),
                              );
                            });
                          } else if (index == 3) {
                            await showDialog(
                              context: context,
                              builder: (_) {
                                return AlertDialog(
                                  title: Row(
                                    children: [
                                      Text(
                                        language!.changePassword,
                                        style: boldTextStyle(size: 18),
                                      ).expand(),
                                      IconButton(onPressed: ()=>finish(context), icon: Icon(Icons.close),color: context.iconColor)
                                    ],
                                  ),
                                  content: SizedBox(
                                    width: context.width() * 0.3,
                                    child: ChangePasswordFieldWidget(),
                                  ),
                                );
                              },
                            );
                          } else if (index == 4) {
                            if (PrivacyPolicy.isNotEmpty) {
                              launchUrl(PrivacyPolicy, forceWebView: true);
                            }
                          } else if (index == 5) {
                            if (PrivacyPolicy.isNotEmpty) {
                              launchUrl(PrivacyPolicy, forceWebView: true);
                            }
                          } else if (index == 7) {
                            showConfirmDialogCustom(
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
                            settingData[index].widget.launch(context);
                          }
                        }, splashColor: Colors.transparent, highlightColor: Colors.transparent, hoverColor: Colors.transparent);
                      },
                    );
                  },
                ).toList(),
              ),
            ],
          ),
        ).center(),
      ),
    );
  }
}
