import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:recipe_app/main.dart';
import 'package:recipe_app/models/ImageModel.dart';
import 'package:recipe_app/models/RecipeStepModel.dart';
import 'package:recipe_app/utils/Colors.dart';
import 'package:recipe_app/utils/Widgets.dart';

class QuickRecipeStepWidget extends StatefulWidget {
  final List<RecipeStepModel>? recipeStepData;

  QuickRecipeStepWidget({this.recipeStepData});

  @override
  QuickRecipeStepWidgetState createState() => QuickRecipeStepWidgetState();
}

class QuickRecipeStepWidgetState extends State<QuickRecipeStepWidget> {
  PageController controller = PageController();

  final flutterTts = FlutterTts();

  FocusNode focus = FocusNode();

  PageController imageController = PageController();

  int imageIndex = 0;

  int currentIndex = 0;
  bool mIsSpeaking = false;
  bool mIsRotation = true;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    setOrientationLandscape();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    initializeTts();

    controller.addListener(() {
      currentIndex = controller.page.validate().toInt();

      setState(() {});
    });
  }

  void initializeTts() {
    flutterTts.setStartHandler(() {
      mIsSpeaking = true;
      setState(() {});
    });
    flutterTts.setCompletionHandler(() {
      mIsSpeaking = false;

      if ((currentIndex + 1) != widget.recipeStepData!.length) {
        controller.nextPage(duration: 500.milliseconds, curve: Curves.linear);
        1.seconds.delay.then((value) {
          flutterTts.speak(widget.recipeStepData![currentIndex].description.validate());
        });
      }
      setState(() {});
    });
    flutterTts.setErrorHandler((message) {
      mIsSpeaking = false;
    });
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.bottom, SystemUiOverlay.top]);
    if (!appStore.isDarkMode) setStatusBarColor(Colors.transparent, systemNavigationBarColor: white);
    flutterTts.stop();
    controller.dispose();
    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  Widget getImageWidget(List<ImageModel>? imageList) {
    return Container(
      height: 200,
      width: 200,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          PageView(
            controller: imageController,
            children: imageList!.map((e) {
              return commonCachedNetworkImage(
                e.url,
                width: 40,
                fit: BoxFit.cover,
                height: 40,
              ).cornerRadiusWithClipRRect(defaultRadius);
            }).toList(),
          ),
          DotIndicator(
            indicatorColor: white,
            pageController: imageController,
            pages: imageList.validate(),
            unselectedIndicatorColor: Colors.grey,
            onPageChanged: (index) {
              setState(() {
                imageIndex = index;
              });
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          AnimatedPadding(
            padding: !mIsRotation ? EdgeInsets.fromLTRB(8, context.statusBarHeight, 50, 0) : EdgeInsets.fromLTRB(8, 16, 16, 0),
            duration: Duration(milliseconds: 500),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CloseButton(),
                    8.width,
                    DotIndicator(
                      indicatorColor: primaryColor,
                      unselectedIndicatorColor: appStore.isDarkMode ? white : Colors.black12,
                      pageController: controller,
                      pages: widget.recipeStepData!,
                      onPageChanged: (index) {
                        setState(() {
                          currentIndex = index;
                        });
                      },
                    ),
                  ],
                ),
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(0),
                  width: context.width(),
                  child: Text(
                    '${currentIndex + 1}/${widget.recipeStepData!.length.toString()}',
                    style: boldTextStyle(size: 25, color: primaryColor),
                  ),
                ).expand(),
                //StopWatchTimerWidget(),
                Container(
                  decoration: BoxDecoration(color: primaryColor, borderRadius: BorderRadius.circular(defaultRadius)),
                  width: 100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(mIsSpeaking ? language!.stop : language!.speak),
                      IconButton(
                        onPressed: () {
                          if (mIsSpeaking) {
                            mIsSpeaking = false;
                            flutterTts.stop();
                            setState(() {});
                          } else {
                            mIsSpeaking = true;
                            flutterTts.speak(widget.recipeStepData![currentIndex].description.validate());
                            setState(() {});
                          }
                        },
                        icon: Icon(mIsSpeaking ? Icons.voice_over_off_outlined : Icons.record_voice_over_outlined, color: context.iconColor),
                      ),
                    ],
                  ),
                ).onTap(() {
                  if (mIsSpeaking) {
                    mIsSpeaking = false;
                    flutterTts.stop();
                    setState(() {});
                  } else {
                    mIsSpeaking = true;
                    flutterTts.speak(widget.recipeStepData![currentIndex].description.validate());
                    setState(() {});
                  }
                }),
              ],
            ),
          ),
          16.height,
          PageView.builder(
            controller: controller,
            itemCount: widget.recipeStepData!.length,
            onPageChanged: (index) {
              if (mIsSpeaking) {
                mIsSpeaking = false;
                flutterTts.stop();
                setState(() {});
              }
            },
            itemBuilder: (BuildContext context, int itemIndex) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AutoSizeText(
                          widget.recipeStepData![itemIndex].description.validate(),
                          style: boldTextStyle(size: 22),
                          minFontSize: 8,
                          maxFontSize: 40,
                        ).expand(),
                        8.width,
                        widget.recipeStepData![itemIndex].step_image_gallery!.isNotEmpty
                            ? getImageWidget(widget.recipeStepData![itemIndex].step_image_gallery)
                            : widget.recipeStepData![itemIndex].recipe_step_image!.isNotEmpty
                                ? commonCachedNetworkImage(
                                    widget.recipeStepData![itemIndex].recipe_step_image![0].url.validate(),
                                    width: context.width(),
                                    fit: BoxFit.cover,
                                    height: 180,
                                  ).cornerRadiusWithClipRRect(defaultRadius).expand()
                                : Offstage(),
                      ],
                    ).expand()
                  ],
                ).onTap(() {
                  if (mIsRotation) {
                    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
                    mIsRotation = false;
                    setState(() {});
                  } else {
                    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
                    mIsRotation = true;
                    setState(() {});
                  }
                }, highlightColor: context.cardColor),
              );
            },
          ).expand(),
        ],
      ),
    );
  }
}
