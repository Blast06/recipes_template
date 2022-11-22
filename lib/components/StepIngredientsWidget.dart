import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:recipe_app/main.dart';
import 'package:recipe_app/models/RecipeIngredientsModel.dart';
import 'package:recipe_app/network/RestApis.dart';

class StepIngredientsWidget extends StatefulWidget {
  final List<RecipeIngredientsModel>? listData;
  final int? ingredientRecipeId;

  StepIngredientsWidget({this.listData, this.ingredientRecipeId});

  @override
  StepIngredientsWidgetState createState() => StepIngredientsWidgetState();
}

class StepIngredientsWidgetState extends State<StepIngredientsWidget> {
  ScrollController scrollController = ScrollController();

  int totalPage = 1;
  int currentPage = 1;
  int mPage = 1;

  bool mISUpdated = false;
  bool mISLastPage = false;

  List<RecipeIngredientsModel> ingredientList = [];
  List<RecipeIngredientsModel> data = [];

  @override
  void initState() {
    super.initState();
    init();
    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        if (mISLastPage) {
          appStore.setLoading(true);

          mPage++;
          setState(() {});
        }
        init();
      }
    });
  }

  void init() async {
    mISUpdated = widget.ingredientRecipeId != null;
    await 200.milliseconds.delay;
    appStore.setLoading(true);
    getIngredients(page: mPage, recipeId: mISUpdated ? widget.ingredientRecipeId : newRecipeModel!.id).then((value) {
      appStore.setLoading(false);

      mISLastPage = value.data!.length != value.pagination!.per_page!;

      totalPage = value.pagination!.totalPages!;
      currentPage = value.pagination!.currentPage!;

      if (mPage == 1) {
        data.clear();
      }
      data.addAll(value.data!);

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
      appBar: appBarWidget(
        language!.ingredients,
        elevation: 0,
        showBack: false,
        actions: [
          IconButton(
            onPressed: () {
              finish(context, ingredientList);
            },
            icon: Icon(Icons.done,color: context.iconColor),
          ).paddingOnly(right: 12)
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: data.map((e) {
                return CheckboxListTile(
                  title: Text(e.name!,style: primaryTextStyle()),
                  value: e.mISCheck,
                  onChanged: (val) {
                    e.mISCheck = !e.mISCheck!;
                    if (!ingredientList.contains(e.name)) {
                      ingredientList.add(e);
                    } else {
                      ingredientList.remove(e);
                    }
                    setState(() {});
                  },
                );
              }).toList(),
            ),
          ),
          Observer(builder: (_) => Loader().visible(appStore.isLoader))
        ],
      ),
    );
  }
}
