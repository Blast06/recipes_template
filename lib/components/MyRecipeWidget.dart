import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:recipe_app/components/EmptyWidget.dart';
import 'package:recipe_app/components/RecipeItemGridWidget.dart';
import 'package:recipe_app/main.dart';
import 'package:recipe_app/models/RecipeModel.dart';
import 'package:recipe_app/network/RestApis.dart';
import 'package:recipe_app/utils/Constants.dart';

class MyRecipeWidget extends StatefulWidget {
  final List<PopupMenuItem<int>>? popMenuList;
  final int? status;
  final Function(int, RecipeModel)? onTap;
  final int spanCount;

  MyRecipeWidget({this.popMenuList, this.status, this.onTap, this.spanCount = 2});

  @override
  MyRecipeWidgetState createState() => MyRecipeWidgetState();
}

class MyRecipeWidgetState extends State<MyRecipeWidget> with AutomaticKeepAliveClientMixin<MyRecipeWidget> {
  ScrollController scrollController = ScrollController();

  int totalPage = 1;
  int currentPage = 1;
  int mPage = 1;

  List<RecipeModel> listData = [];

  bool mISLastPage = false;

  @override
  void initState() {
    super.initState();
    init();

    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        if (!mISLastPage) {
          appStore.setLoading(true);

          mPage++;

          init();
        }
      }
    });

    LiveStream().on(streamRefreshRecipe, (v) {
      mPage = 1;
      init();
    });

    LiveStream().on(streamRefreshRecipeData, (v) {
      mPage = 1;
      init();
    });
    LiveStream().on(streamRefreshUnPublished, (v) {
      mPage = 1;
      init();
    });

    afterBuildCreated(() {
      appStore.setLoading(true);
    });
  }

  void init() async {
    getRecipeListData(page: mPage, status: widget.status).then((value) {
      appStore.setLoading(false);

      mISLastPage = value.data!.length != value.pagination!.per_page!;

      totalPage = value.pagination!.totalPages!;
      currentPage = value.pagination!.currentPage!;

      if (mPage == 1) {
        listData.clear();
      }
      listData.addAll(value.data!);

      setState(() {});
    }).catchError((error) {
      appStore.setLoading(false);

      log(error);
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    scrollController.dispose();

    LiveStream().dispose(streamRefreshRecipe);
    LiveStream().dispose(streamRefreshRecipeData);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Observer(
      builder: (_) => Stack(
        children: [
          SingleChildScrollView(
            controller: scrollController,
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            child: listData.isNotEmpty
                ? Wrap(
                    runSpacing: 16,
                    spacing: 16,
                    children: listData.validate().map((e) {
                      return RecipeItemGridWidget(
                        e,
                        spanCount: widget.spanCount,
                        onPopupMenuSelected: (val) async {
                          await widget.onTap!(val, e);
                          init();
                        },
                        popMenuList: widget.popMenuList,
                      );
                    }).toList(),
                  )
                : Container(height: context.height() * 0.6, child: EmptyWidget(title: language!.noDataFound).visible(!appStore.isLoader)),
          ),
          Loader().visible(appStore.isLoader),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
