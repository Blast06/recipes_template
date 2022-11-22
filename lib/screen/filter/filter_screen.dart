import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:recipe_app/main.dart';
import 'package:recipe_app/models/DishTypModel.dart';
import 'package:recipe_app/models/RecipeStaticModel.dart';
import 'package:recipe_app/network/RestApis.dart';
import 'package:recipe_app/screen/filter/component/FilterRecipeCuisineWidget.dart';
import 'package:recipe_app/screen/filter/component/FilterRecipeDishTypeScreen.dart';
import 'package:recipe_app/utils/Colors.dart';
import 'package:recipe_app/utils/Constants.dart';

class FilterScreen extends StatefulWidget {
  final bool isFromProvider;

  FilterScreen({this.isFromProvider = true});

  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  int isSelected = 0;

  List<DishTypeData> dishNameList = [];
  List<CuisineData> cuisineList = [];

  @override
  void initState() {
    super.initState();
    appStore.setLoading(true);
    afterBuildCreated(() => init());
  }

  void init() async {
    //Get all Dish Type List
    appStore.setLoading(true);

    await getDishTypeList(getAllPage: true).then((value) {
      appStore.setLoading(false);

      dishNameList = value.data.validate();

      dishNameList.forEach((element) {
        if (filterStore.dishTypeNameList.contains(element.name)) {
          element.isSelected = true;
        }
      });

      setState(() {});
    }).catchError((error) {
      appStore.setLoading(false);

      toast(error.toString());
    });

    //Get all Cuisine List

    await addCuisineData(type: RecipeTypeCuisineData, keyword: '', getAllPage: true).then((value) {
      appStore.setLoading(false);
      cuisineList = value.data.validate();

      cuisineList.forEach((element) {
        if (filterStore.cuisineNameList.contains(element.label)) {
          element.isSelected = true;
        }
      });

      setState(() {});
    }).catchError((error) {
      appStore.setLoading(false);

      toast(error.toString());
    });

    appStore.setLoading(false);
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  Widget buildItem({required String name, required bool isSelected}) {
    return Container(
      padding: EdgeInsets.fromLTRB(24, 20, 20, 20),
      width: context.width(),
      decoration: boxDecorationDefault(
        color: isSelected ? context.cardColor : context.scaffoldBackgroundColor,
        borderRadius: radius(0),
      ),
      child: Text(
        "$name",
        style: boldTextStyle(
          size: isSelected ? 18 : 14,
          color: isSelected
              ? primaryColor
              : appStore.isDarkMode
                  ? Colors.white
                  : Colors.black,
        ),
      ),
    );
  }

  void clearFilter() {
    dishNameList.forEach((element) {
      if (element.isSelected.validate()) {
        element.isSelected = false;
      }
    });

    cuisineList.forEach((element) {
      if (element.isSelected) {
        element.isSelected = false;
      }
    });
    filterStore.clearFilters();
    setState(() {});
    finish(context, false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(language!.filterBy, elevation: 0.6),
      body: Column(
        children: [
          Observer(builder: (context) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: boxDecorationDefault(color: context.scaffoldBackgroundColor, borderRadius: radius(0)),
                  child: Column(
                    children: [
                      buildItem(isSelected: isSelected == 0, name: language!.dishType).onTap(() {
                        isSelected = 0;
                        setState(() {});
                      }),
                      buildItem(isSelected: isSelected == ((widget.isFromProvider) ? 1 : 0), name: language!.cuisine).onTap(() {
                        isSelected = (widget.isFromProvider) ? 1 : 0;
                        setState(() {});
                      }),
                    ],
                  ),
                ).expand(flex: 2),
                Container(
                  height: context.height(),
                  width: 0.2,
                  color: Colors.grey.shade500,
                ),
                if (appStore.isLoader)
                  Loader().flexible(flex: 5)
                else
                  [
                    FilterRecipeDishTypeComponent(typeList: dishNameList),
                    FilterRecipeCuisineWidget(cuisineList: cuisineList),
                  ][isSelected]
                      .flexible(flex: 5),
              ],
            ).expand();
          }),
          Row(
            children: [
              if (filterStore.dishTypeNameList.isNotEmpty || filterStore.cuisineNameList.isNotEmpty)
                Observer(
                  builder: (_) => Container(
                    decoration: BoxDecoration(color: context.scaffoldBackgroundColor),
                    width: context.width(),
                    padding: EdgeInsets.all(16),
                    child: AppButton(
                      text: language!.clearFilter,
                      textColor: context.primaryColor,
                      shapeBorder: RoundedRectangleBorder(borderRadius: radius(), side: BorderSide(color: context.primaryColor)),
                      onTap: () {
                        clearFilter();
                      },
                    ),
                  ).visible(!appStore.isLoader),
                ).expand(),
              Observer(
                builder: (_) => Container(
                  decoration: BoxDecoration(color: context.scaffoldBackgroundColor),
                  width: context.width(),
                  padding: EdgeInsets.all(16),
                  child: AppButton(
                    text: language!.apply,
                    textColor: Colors.white,
                    color: context.primaryColor,
                    onTap: () {
                      filterStore.dishTypeNameList = [];
                      log(dishNameList.where((element) => element.isSelected == true).length);

                      dishNameList.forEach((element) {
                        //
                        if (element.isSelected.validate()) {
                          filterStore.addToDishTypeList(dishTypeName: element.name.validate());
                        }
                      });

                      filterStore.cuisineNameList = [];

                      cuisineList.forEach((element) {
                        if (element.isSelected) {
                          filterStore.addToCuisineNameList(cuisineName: element.label.validate());
                        }
                      });

                      finish(context, true);
                    },
                  ),
                ).visible(!appStore.isLoader),
              ).expand(),
            ],
          ),
        ],
      ),
    );
  }
}
