import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:recipe_app/models/ImageModel.dart';
import 'package:recipe_app/screen/PhotoViewScreen.dart';
import 'package:recipe_app/utils/Widgets.dart';

class DetailStepImageComponent extends StatefulWidget {
  final List<ImageModel> imageList;

  DetailStepImageComponent({required this.imageList});

  @override
  State<DetailStepImageComponent> createState() => _DetailStepImageComponentState();
}

class _DetailStepImageComponentState extends State<DetailStepImageComponent> {
  PageController pageController = PageController();

  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 310,
      width: context.width(),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          PageView(
            controller: pageController,
            children: widget.imageList.map((e) {
              return commonCachedNetworkImage(e.url, width: context.width(), fit: BoxFit.cover, height: 310).onTap(() {
                PhotoViewScreen(imgList: widget.imageList.validate(), isList: true).launch(context);
              });
            }).toList(),
          ),
          if (widget.imageList.length > 1)
            DotIndicator(
              indicatorColor: white,
              pageController: pageController,
              pages: widget.imageList.validate(),
              unselectedIndicatorColor: Colors.grey,
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
