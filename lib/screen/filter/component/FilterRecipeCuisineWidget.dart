import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:recipe_app/components/EmptyWidget.dart';
import 'package:recipe_app/main.dart';
import 'package:recipe_app/models/RecipeStaticModel.dart';

class FilterRecipeCuisineWidget extends StatefulWidget {
  final List<CuisineData>? cuisineList;

  FilterRecipeCuisineWidget({this.cuisineList});

  @override
  _FilterRecipeCuisineWidgetState createState() => _FilterRecipeCuisineWidgetState();
}

class _FilterRecipeCuisineWidgetState extends State<FilterRecipeCuisineWidget> {
  bool mIsLoader = false;

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
    if (widget.cuisineList.validate().isEmpty)
      return Container(
        alignment: Alignment.center,
        width: context.width(),
        height: context.height(),
        child: EmptyWidget(title: language!.noDataFound),
      );

    return SingleChildScrollView(
      child: Column(
        children: widget.cuisineList.validate().map((e) {
          return CheckboxListTile(
            title: Text(e.label!, style: primaryTextStyle()),
            value: e.isSelected,
            onChanged: (val) {
              if (e.isSelected.validate()) {
                e.isSelected = false;
              } else {
                e.isSelected = true;
              }
              setState(() {});
            },
          );
        }).toList(),
      ),
    );
  }
}
