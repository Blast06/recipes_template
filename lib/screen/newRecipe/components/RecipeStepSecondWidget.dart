import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:recipe_app/components/NumberPickerScreen.dart';
import 'package:recipe_app/components/PortionTypeWidget.dart';
import 'package:recipe_app/main.dart';
import 'package:recipe_app/models/UtensilModel.dart';
import 'package:recipe_app/utils/Colors.dart';
import 'package:recipe_app/utils/Common.dart';
import 'package:recipe_app/utils/Constants.dart';
import 'package:recipe_app/utils/Widgets.dart';

class RecipeStepSecondWidget extends StatefulWidget {
  final bool? mIsUpdate;

  RecipeStepSecondWidget({this.mIsUpdate});

  @override
  RecipeStepSecondWidgetState createState() => RecipeStepSecondWidgetState();
}

class RecipeStepSecondWidgetState extends State<RecipeStepSecondWidget> {
  int mISSelect = 0;

  bool mIsUpdate = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    mIsUpdate = widget.mIsUpdate.validate();

    if (mIsUpdate) {
      newRecipeModel!.portionUnit = newRecipeModel!.portionUnit.validate();
      newRecipeModel!.portionType = newRecipeModel!.portionType.validate();
      newRecipeModel!.restingTime = newRecipeModel!.restingTime.validate();
      difficulty.forEach((e) {
        if (e == newRecipeModel!.difficulty) {
          mISSelect = difficulty.indexOf(e);
          setState(() {});
        }
      });
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.cardColor,
      height: context.height(),
      width: context.width(),
      child: Column(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                createRecipeWidget(title: language!.step2Title, width: context.width()),
                8.height,
                createRecipeTime(
                  context: context,
                  title: language!.portionType,
                  subTitle: language!.choiceBetweenServing,
                  time: '${newRecipeModel!.portionUnit.validate(value: 0)} ${newRecipeModel!.portionType.validate(value: 'Serving')}',
                  onTap: () async {
                    PortionTypeModel? model = isWeb
                        ? await showDialog(
                            context: context,
                            builder: (_) {
                              return AlertDialog(content: PortionTypeWidget(type: newRecipeModel!.portionType, unit: newRecipeModel!.portionUnit));
                            })
                        : await showModalBottomSheet(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(defaultRadius), topRight: Radius.circular(16))),
                            context: context,
                            builder: (BuildContext context) {
                              return PortionTypeWidget(type: newRecipeModel!.portionType, unit: newRecipeModel!.portionUnit);
                            },
                          );
                    if (model != null) {
                      newRecipeModel!.portionUnit = model.portionUnit;
                      newRecipeModel!.portionType = model.portionType;
                      setState(() {});
                    }
                  },
                ),
                8.height,
                Divider(color: Colors.grey.shade400),
                8.height,
                Text(language!.difficulty, style: boldTextStyle()).paddingOnly(left: 16),
                12.height,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: difficulty.map((e) {
                    int select = difficulty.indexOf(e);

                    return Container(
                      margin: EdgeInsets.only(left: 16, right: 16),
                      padding: EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: mISSelect == select
                                ? primaryColor
                                : appStore.isDarkMode
                                    ? white
                                    : black,
                          ),
                          borderRadius: BorderRadius.circular(defaultRadius)),
                      child: Text(e, style: boldTextStyle()),
                    ).onTap(() {
                      mISSelect = select;

                      setState(() {});
                    }, splashColor: appStore.isDarkMode ? Colors.black : white, highlightColor: appStore.isDarkMode ? Colors.black : white);
                  }).toList(),
                ),
                8.height,
                Divider(color: Colors.grey.shade400),
                createRecipeTime(
                    context: context,
                    title: language!.preTimeCookingTime,
                    subTitle: language!.howMakingTheDish,
                    time: '${stringToMin(newRecipeModel!.preparationTime.validate())} min',
                    onTap: () async {
                      int? time = isWeb
                          ? await showDialog(
                              context: context,
                              builder: (_) {
                                return AlertDialog(
                                  content: NumberPickerScreen(
                                    aHour: (stringToMin(newRecipeModel!.preparationTime ?? '0:0').toInt() ~/ 60),
                                    aMinutes: (stringToMin(newRecipeModel!.preparationTime ?? '0:0').toInt() % 60),
                                  ),
                                );
                              },
                            )
                          : await showModalBottomSheet(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(defaultRadius), topRight: Radius.circular(10))),
                              context: context,
                              builder: (_) {
                                return NumberPickerScreen(aHour: (stringToMin(newRecipeModel!.preparationTime.validate()).toInt() ~/ 60), aMinutes: (stringToMin(newRecipeModel!.preparationTime.validate()).toInt() % 60));
                              },
                            );

                      if (time != null) {
                        newRecipeModel!.preparationTime = timeFunction(time);
                        setState(() {});
                      }
                    }),
                createRecipeTime(
                  context: context,
                  title: language!.bakingTime,
                  subTitle: language!.howBakeFor,
                  time: '${stringToMin(newRecipeModel!.bakingTime.validate())} min',
                  onTap: () async {
                    int? time = isWeb
                        ? await showDialog(
                            context: context,
                            builder: (_) {
                              return AlertDialog(
                                content: NumberPickerScreen(
                                  aHour: (stringToMin(newRecipeModel!.bakingTime ?? '0:0').toInt() ~/ 60),
                                  aMinutes: (stringToMin(newRecipeModel!.bakingTime ?? '0:0').toInt() % 60),
                                ),
                              );
                            },
                          )
                        : await showModalBottomSheet(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(defaultRadius), topRight: Radius.circular(10))),
                            context: context,
                            builder: (_) {
                              return NumberPickerScreen(aHour: (stringToMin(newRecipeModel!.bakingTime.validate()).toInt() ~/ 60), aMinutes: (stringToMin(newRecipeModel!.bakingTime.validate()).toInt() % 60));
                            },
                          );
                    if (time != null) {
                      newRecipeModel!.bakingTime = timeFunction(time);
                      setState(() {});
                    }
                  },
                ),
                createRecipeTime(
                  context: context,
                  title: language!.restingTime,
                  subTitle: language!.doesTheAnyPoint,
                  time: '${stringToMin(newRecipeModel!.restingTime.validate())} min',
                  onTap: () async {
                    int? time = isWeb
                        ? await showDialog(
                            context: context,
                            builder: (_) {
                              return AlertDialog(
                                content: NumberPickerScreen(
                                  aHour: (stringToMin(newRecipeModel!.restingTime ?? '0:0').toInt() ~/ 60),
                                  aMinutes: (stringToMin(newRecipeModel!.restingTime ?? '0:0').toInt() % 60),
                                ),
                              );
                            },
                          )
                        : await showModalBottomSheet(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(defaultRadius), topRight: Radius.circular(defaultRadius))),
                            context: context,
                            builder: (_) {
                              return NumberPickerScreen(aHour: (stringToMin(newRecipeModel!.restingTime.validate()).toInt() ~/ 60), aMinutes: (stringToMin(newRecipeModel!.restingTime.validate()).toInt() % 60));
                            },
                          );

                    if (time != null) {
                      newRecipeModel!.restingTime = timeFunction(time);

                      setState(() {});
                    }
                  },
                ),
              ],
            ),
          ).expand(),
          AppButton(
            width: context.width(),
            color: primaryColor,
            shapeBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(defaultRadius)),
            child: Text(language!.next, style: boldTextStyle(color: white)),
            onTap: () {
              newRecipeModel!.difficulty = difficulty[mISSelect];

              if (newRecipeModel!.portionUnit.validate(value: 0) == 0) {
                return snackBar(context, title: language!.pleaseAddPortionUnit);
              } else if (stringToMin(newRecipeModel!.preparationTime.validate()).toInt() == 0) {
                return snackBar(context, title: language!.pleaseAddPreparationTime);
              } else {
                LiveStream().emit(streamNewRecipePageChange, 2);
              }
            },
          ).paddingAll(8),
        ],
      ),
    );
  }
}
