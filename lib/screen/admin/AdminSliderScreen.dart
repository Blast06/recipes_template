import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:recipe_app/components/EmptyWidget.dart';
import 'package:recipe_app/components/FixSizedBox.dart';
import 'package:recipe_app/main.dart';
import 'package:recipe_app/models/RecipeDashboardModel.dart';
import 'package:recipe_app/network/RestApis.dart';
import 'package:recipe_app/screen/admin/AdminAddSliderScreen.dart';
import 'package:recipe_app/utils/Common.dart';
import 'package:recipe_app/utils/Widgets.dart';

class AdminSliderScreen extends StatefulWidget {
  @override
  AdminSliderScreenState createState() => AdminSliderScreenState();
}

class AdminSliderScreenState extends State<AdminSliderScreen> {
  ScrollController scrollController = ScrollController();

  int totalPage = 1;
  int currentPage = 1;
  int mPage = 1;

  bool mISLastPage = false;
  List<SliderData> sliderData = [];

  @override
  void initState() {
    super.initState();
    init();
    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        if (!mISLastPage) {
          appStore.setLoading(true);

          mPage++;
          setState(() {});

          init();
        }
      }
    });

    afterBuildCreated(() {
      appStore.setLoading(true);
    });
  }

  void init() async {
    getSliderData(page: mPage).then((value) {
      appStore.setLoading(false);
      mISLastPage = value.data!.length != value.pagination!.per_page;

      totalPage = value.pagination!.totalPages!;
      currentPage = value.pagination!.currentPage!;

      if (mPage == 1) {
        sliderData.clear();
      }

      sliderData.addAll(value.data!);

      setState(() {});
    }).catchError((error) {
      appStore.setLoading(false);
      toast(error.toString());
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: kIsWeb
          ? null
          : appBarWidget(
              language!.slider,
              elevation: 0,
              titleTextStyle: boldTextStyle(),
              actions: [
                IconButton(
                  onPressed: () async {
                    await AdminAddSliderScreen().launch(context, pageRouteAnimation: PageRouteAnimation.Slide, duration: Duration(milliseconds: 300));
                    init();
                  },
                  icon: Icon(Icons.add, size: 20, color: context.iconColor),
                )
              ],
            ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            child: FixSizedBox(
              maxWidth: kIsWeb ? null : context.width(),
              child: Column(
                children: [
                  if (kIsWeb) ...[
                    Row(
                      children: [
                        Text(language!.addSlider, style: boldTextStyle(size: 24)).expand(),
                        IconButton(
                          onPressed: () async {
                            await showDialog(
                              context: context,
                              builder: (_) {
                                return AdminAddSliderScreen();
                              },
                            );
                            init();
                          },
                          icon: Icon(Icons.add, size: 20, color: context.iconColor),
                        )
                      ],
                    ),
                    Divider(),
                  ],
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: sliderData.map((e) {
                      return Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          commonCachedNetworkImage(
                            e.slider_image.validate(),
                            width: context.width(),
                            fit: BoxFit.cover,
                            height: context.height() * 0.25,
                          ).cornerRadiusWithClipRRect(defaultRadius).paddingOnly(top: 8, bottom: 8).onTap(() async {
                            if (kIsWeb) {
                              await showDialog(
                                context: context,
                                builder: (_) {
                                  return AdminAddSliderScreen(data: e);
                                },
                              );
                            } else {
                              await AdminAddSliderScreen(data: e).launch(context, pageRouteAnimation: PageRouteAnimation.Slide, duration: Duration(milliseconds: 300));
                            }
                            init();
                          }),
                          e.title != null
                              ? Container(
                                  width: context.width(),
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(defaultRadius), gradient: gradientDecoration()),
                                  padding: EdgeInsets.all(8),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(defaultRadius),
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
                                      child: Container(
                                        padding: EdgeInsets.all(8),
                                        decoration: glassBoxDecoration(),
                                        child: Text(e.title.validate(), style: boldTextStyle()),
                                      ),
                                    ),
                                  ),
                                )
                              : SizedBox()
                        ],
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
          if (sliderData.isEmpty) EmptyWidget(title: language!.noDataFound).visible(appStore.isLoader),
          Observer(builder: (_) => Loader().visible(appStore.isLoader)),
        ],
      ),
    );
  }
}
