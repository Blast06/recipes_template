import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:recipe_app/models/RecipeDashboardModel.dart';
import 'package:recipe_app/utils/Common.dart';
import 'package:recipe_app/utils/Widgets.dart';

class SliderWidget extends StatefulWidget {
  final List<SliderData> list;
  final double spanCount;

  SliderWidget(this.list, {this.spanCount = 200});

  @override
  SliderWidgetState createState() => SliderWidgetState();
}

class SliderWidgetState extends State<SliderWidget> {
  PageController pageController = PageController();

  int currentPage = 0;

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
    return Container(
      height: 220,
      width: widget.spanCount,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          PageView.builder(
            controller: pageController,
            scrollDirection: Axis.horizontal,
            itemCount: widget.list.length,
            itemBuilder: (BuildContext context, index) {
              SliderData data = widget.list[index];

              return Stack(
                fit: StackFit.expand,
                children: [
                  commonCachedNetworkImage(
                    data.slider_image.validate(),
                    fit: BoxFit.cover,
                    width: context.width(),
                    radius: 0,
                    isScaled: false,
                  ),
                  Positioned(
                    top: 16,
                    left: 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: 180,
                          child: Text(data.title.validate(), style: primaryTextStyle(color: white, fontFamily: fontFamilyGloria, size: 22, height: 1.5)),
                        ),
                        16.height,
                        Container(
                          width: 130,
                          child: Text(data.description.validate(), style: primaryTextStyle(color: white), maxLines: 2),
                        ),
                      ],
                    ),
                  )
                ],
              );
            },
          ),
          DotIndicator(
            indicatorColor: white,
            pageController: pageController,
            pages: widget.list,
            unselectedIndicatorColor: Colors.black12,
            onPageChanged: (index) {
              setState(() {
                currentPage = index;
              });
            },
          ),
        ],
      ),
    );
  }
}
