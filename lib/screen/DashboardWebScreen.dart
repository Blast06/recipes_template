import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:recipe_app/main.dart';
import 'package:recipe_app/models/AppModel.dart';
import 'package:recipe_app/screen/auth/SignInScreen.dart';
import 'package:recipe_app/utils/Colors.dart';
import 'package:recipe_app/utils/Common.dart';
import 'package:recipe_app/utils/Constants.dart';
import 'package:recipe_app/utils/DataProvider.dart';

class DashboardWebScreen extends StatefulWidget {
  @override
  DashboardWebScreenState createState() => DashboardWebScreenState();
}

class DashboardWebScreenState extends State<DashboardWebScreen> {
  List<AppModel> list = getAllData();

  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    LiveStream().on(streamRefreshRecipeIndex, (e) {
      currentIndex = 0;
      setState(() {});
    });

    LiveStream().on(streamRefreshLanguage, (e) {
      list.clear();
      list = getAllData();
      setState(() {});
    });

  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
        '',
        showBack: false,
        titleWidget: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              Text(mAppName, style: boldTextStyle(color: primaryColor, size: 30, fontFamily: fontFamilyGloria)),
              32.width,
              Row(
                children: list.map(
                  (e) {
                    return TextButton(
                      onPressed: () {
                        if ((list.indexOf(e) == 2 || list.indexOf(e) == 3) && (!getBoolAsync(IS_LOGGED_IN))) {
                          SignInScreen().launch(context, duration: Duration(milliseconds: 300));
                        } else {
                          currentIndex = list.indexOf(e);
                          setState(() {});
                        }
                      },
                      child: Text(
                        e.name.validate(),
                        style: boldTextStyle(
                            color: currentIndex == list.indexOf(e)
                                ? primaryColor
                                : appStore.isDarkMode
                                    ? white
                                    : black.withOpacity(0.5)),
                      ),
                    );
                  },
                ).toList(),
              ),
            ],
          ),
        ),
      ),
      body: list[currentIndex].widget,
    );
  }
}
