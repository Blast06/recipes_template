import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:recipe_app/network/RestApis.dart';

import '../../main.dart';

class RecipeAddTypeScreen extends StatefulWidget {
  final List<String>? typeList;
  final bool? dishTypeAppBarShow;

  RecipeAddTypeScreen({this.typeList, this.dishTypeAppBarShow = false});

  @override
  RecipeAddTypeScreenState createState() => RecipeAddTypeScreenState();
}

class RecipeAddTypeScreenState extends State<RecipeAddTypeScreen> {
  ScrollController scrollController = ScrollController();

  int totalPage = 1;
  int currentPage = 1;
  int mPage = 1;

  bool mISLastPage = false;

  List<String> dishNameList = [];

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
  }

  Future<void> init() async {
    dishNameList.addAll(widget.typeList!);

    await 200.milliseconds.delay;
    appStore.setLoading(true);

    getDishTypeList(page: mPage).then((value) {
      appStore.setLoading(false);
      mISLastPage = value.data!.length != value.pagination!.per_page;

      totalPage = value.pagination!.totalPages!;
      currentPage = value.pagination!.currentPage!;

      if (mPage == 1) {
        dishTypeList.clear();
      }

      dishTypeList.addAll(value.data!);

      setState(() {});
    }).catchError((error) {
      appStore.setLoading(false);
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
      appBar: widget.dishTypeAppBarShow.validate()
          ? PreferredSize(preferredSize: Size.fromHeight(0.0), child: appBarWidget("", showBack: false))
          : appBarWidget(
              language!.dishType,
              elevation: 0,
              actions: [
                IconButton(
                  onPressed: () {
                    finish(context, dishNameList);
                  },
                  icon: Icon(Icons.done, color: context.iconColor),
                )
              ],
            ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.symmetric(vertical: 16),
            controller: scrollController,
            child: Column(
              children: dishTypeList.map((e) {
                return CheckboxListTile(
                  title: Text(e.name.validate(), style: primaryTextStyle()),
                  value: dishNameList.contains(e.name) ? true : false,
                  onChanged: (val) {
                    e.isSelected = !e.isSelected!;
                    if (!dishNameList.contains(e.name)) {
                      dishNameList.add(e.name!);
                    } else {
                      dishNameList.remove(e.name!);
                    }
                    setState(() {});
                  },
                );
              }).toList(),
            ),
          ),
          Observer(builder: (_) => Loader().visible(appStore.isLoader)),
        ],
      ),
    );
  }
}
