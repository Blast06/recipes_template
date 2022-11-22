import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:photo_view/photo_view.dart';
import 'package:recipe_app/models/ImageModel.dart';

class PhotoViewScreen extends StatefulWidget {
  final String? img;
  final List<ImageModel>? imgList;
  final bool isList;

  PhotoViewScreen({this.img, this.imgList, required this.isList});

  @override
  PhotoViewScreenState createState() => PhotoViewScreenState();
}

class PhotoViewScreenState extends State<PhotoViewScreen> {
  PageController pageController = PageController();
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    setStatusBarColor(black);
  }

  @override
  void dispose() {
    pageController.dispose();
    setStatusBarColor(Colors.transparent, statusBarBrightness: Brightness.light, statusBarIconBrightness: Brightness.light);
    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: black,
      body: Stack(
        children: [
          widget.isList
              ? Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    PageView(
                      controller: pageController,
                      children: widget.imgList!.map((e) {
                        return PhotoView(
                          loadingBuilder: (context, event) => Center(
                            child: Container(
                              width: 30.0,
                              height: 30.0,
                              child: CircularProgressIndicator(
                                backgroundColor: black,
                                value: event == null ? 0 : event.cumulativeBytesLoaded / event.expectedTotalBytes!,
                              ),
                            ),
                          ),
                          maxScale: PhotoViewComputedScale.contained,
                          minScale: PhotoViewComputedScale.contained,
                          imageProvider: NetworkImage(e.url.validate()),
                        );
                      }).toList(),
                    ),
                    if (widget.imgList!.length > 1)
                      Positioned(
                        bottom: 30,
                        child: DotIndicator(
                          indicatorColor: white,
                          pageController: pageController,
                          pages: widget.imgList.validate(),
                          unselectedIndicatorColor: Colors.grey,
                          onPageChanged: (index) {
                            setState(() {
                              currentPage = index;
                            });
                          },
                        ),
                      ),
                  ],
                )
              : Container(
                  width: context.width(),
                  child: PhotoView(
                    loadingBuilder: (context, event) => Center(
                      child: Container(
                        width: 30.0,
                        height: 30.0,
                        child: CircularProgressIndicator(
                          backgroundColor: black,
                          value: event == null ? 0 : event.cumulativeBytesLoaded / event.expectedTotalBytes!,
                        ),
                      ),
                    ),
                    maxScale: PhotoViewComputedScale.contained,
                    minScale: PhotoViewComputedScale.contained,
                    imageProvider: NetworkImage(widget.img!),
                  ),
                ),
          SafeArea(child: BackButton(color: white)),
        ],
      ),
    );
  }
}
