import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:recipe_app/main.dart';
import 'package:recipe_app/screen/DashboardScreen.dart';
import 'package:recipe_app/screen/DashboardWebScreen.dart';
import 'package:recipe_app/utils/Colors.dart';
import 'package:recipe_app/utils/Constants.dart';
import 'package:recipe_app/utils/Widgets.dart';

class WalkThroughScreen extends StatefulWidget {
  @override
  WalkThroughScreenState createState() => WalkThroughScreenState();
}

class WalkThroughScreenState extends State<WalkThroughScreen> {
  PageController pageController = PageController();

  int currentPage = 0;

  List<WalkThroughModelClass> list = [];

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    setStatusBarColor(white);

    list.add(WalkThroughModelClass(title: language!.walkthrough1Title, subTitle: language!.walkthrough1SubTitle, image: WalkThroughIMG1));
    list.add(WalkThroughModelClass(title: language!.walkthrough2Title, subTitle: language!.walkthrough2SubTitle, image: WalkThroughIMG2));
  }

  void redirect({bool skip = false}) async {
    await setValue(IS_FIRST_TIME, false);
    if (skip) {
      if (isWeb) {
        DashboardWebScreen().launch(context, isNewTask: true);
      } else {
        DashboardScreen().launch(context, isNewTask: true);
      }
    } else {
      if (currentPage == 1) {
        if (isWeb) {
          DashboardWebScreen().launch(context, isNewTask: true);
        } else {
          DashboardScreen().launch(context, isNewTask: true);
        }
      } else {
        pageController.animateToPage(currentPage + 1, duration: Duration(milliseconds: 300), curve: Curves.linear);
      }
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.topRight,
        children: [
          PageView(
            controller: pageController,
            children: list.map((e) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  commonCachedNetworkImage(e.image, fit: BoxFit.cover, height: 250, width: 250).cornerRadiusWithClipRRect(defaultRadius),
                  50.height,
                  Text(e.title!, style: boldTextStyle(size: 22), textAlign: TextAlign.center),
                  16.height,
                  Text(e.subTitle!, style: secondaryTextStyle(), textAlign: TextAlign.center),
                ],
              );
            }).toList(),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 100,
            child: DotIndicator(
              indicatorColor: primaryColor,
              pageController: pageController,
              pages: list,
              unselectedIndicatorColor: grey,
              onPageChanged: (index) {
                setState(() {
                  currentPage = index;
                });
              },
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: GestureDetector(
                    onTap: () {
                      redirect(skip: true);
                    },
                    child: Text(language!.skip, style: primaryTextStyle()))
                .paddingOnly(top: 36, right: 16)
                .visible(currentPage != 1),
          ),
          Positioned(
            bottom: 20,
            right: 0,
            left: 0,
            child: AppButton(
              shapeBorder: RoundedRectangleBorder(borderRadius: radius(defaultRadius)),
              padding: EdgeInsets.all(12),
              color: primaryColor,
              text: language!.getStarted,
              textStyle: boldTextStyle(color: white),
              onTap: () {
                redirect();
              },
            ).paddingOnly(left: 16, right: 16),
          ),
        ],
      ),
    );
  }
}
