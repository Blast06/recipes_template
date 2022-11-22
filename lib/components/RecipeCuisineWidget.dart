import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:recipe_app/main.dart';
import 'package:recipe_app/network/RestApis.dart';
import 'package:recipe_app/utils/Constants.dart';

class RecipeCuisineWidget extends StatefulWidget {
  final List<String>? cuisineList;
  final bool? cuisineAppBarShow;

  RecipeCuisineWidget({this.cuisineList, this.cuisineAppBarShow = false});

  @override
  RecipeCuisineWidgetState createState() => RecipeCuisineWidgetState();
}

class RecipeCuisineWidgetState extends State<RecipeCuisineWidget> {
  ScrollController scrollController = ScrollController();

  int currentPage = 1;
  int totalPage = 1;
  int mPage = 1;

  bool mIsLastPage = false;
  bool mIsLoader = false;

  List<String> cuisineList = [];

  @override
  void initState() {
    super.initState();
    init();

    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        if (!mIsLastPage) {
          mPage++;
          setState(() {});
        }
        init();
      }
    });
  }

  void init() async {
    cuisineList.addAll(widget.cuisineList!);
    mIsLoader = true;
    setState(() {});

    addCuisineData(type: RecipeTypeCuisineData, page: mPage, keyword: '').then((value) {
      mIsLoader = false;
      setState(() {});
      mIsLastPage = value.data!.length != value.pagination!.per_page!;

      totalPage = value.pagination!.totalPages!;
      currentPage = value.pagination!.currentPage!;

      if (mPage == 1) {
        cuisineData.clear();
      }

      cuisineData.addAll(value.data!);

      setState(() {});
    }).catchError((error) {
      mIsLoader = false;
      setState(() {});
      toast(error.toString());
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.cuisineAppBarShow.validate()
          ? PreferredSize(preferredSize: Size.fromHeight(0.0), child: appBarWidget("", showBack: false))
          : appBarWidget(
              language!.cuisine,
              elevation: 0,
              actions: [
                IconButton(
                  onPressed: () {
                    finish(context, cuisineList);
                  },
                  icon: Icon(Icons.done, color: context.iconColor),
                ),
              ],
            ),
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: scrollController,
            child: Column(
              children: cuisineData.map((e) {
                return CheckboxListTile(
                  title: Text(e.label!, style: primaryTextStyle()),
                  value: cuisineList.contains(e.label) ? true : false,
                  onChanged: (val) {
                    e.mISCheck = !e.mISCheck!;
                    if (!cuisineList.contains(e.label)) {
                      cuisineList.add(e.label!);
                    } else {
                      cuisineList.remove(e.label);
                    }
                    setState(() {});
                  },
                );
              }).toList(),
            ),
          ),
          Loader().visible(mIsLoader)
        ],
      ),
    );
  }
}
