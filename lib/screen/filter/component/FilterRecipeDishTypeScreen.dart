import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:recipe_app/components/EmptyWidget.dart';
import 'package:recipe_app/main.dart';
import 'package:recipe_app/models/DishTypModel.dart';

class FilterRecipeDishTypeComponent extends StatefulWidget {
  final List<DishTypeData>? typeList;

  FilterRecipeDishTypeComponent({this.typeList});

  @override
  _FilterRecipeDishTypeComponentState createState() => _FilterRecipeDishTypeComponentState();
}

class _FilterRecipeDishTypeComponentState extends State<FilterRecipeDishTypeComponent> {
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    log(widget.typeList!.where((element) => element.isSelected == true).length);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.typeList.validate().isEmpty)
      return Container(
        alignment: Alignment.center,
        width: context.width(),
        height: context.height(),
        child: EmptyWidget(title: language!.noDataFound),
      );

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: widget.typeList.validate().map((e) {
          return CheckboxListTile(
            title: Text(e.name.validate(), style: primaryTextStyle()),
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
