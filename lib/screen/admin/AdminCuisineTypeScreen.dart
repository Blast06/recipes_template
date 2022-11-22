import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:recipe_app/components/EmptyWidget.dart';
import 'package:recipe_app/components/FixSizedBox.dart';
import 'package:recipe_app/main.dart';
import 'package:recipe_app/network/RestApis.dart';
import 'package:recipe_app/utils/Colors.dart';
import 'package:recipe_app/utils/Common.dart';
import 'package:recipe_app/utils/Constants.dart';
import 'package:recipe_app/utils/Widgets.dart';

class AdminCuisineTypeScreen extends StatefulWidget {
  @override
  AdminCuisineTypeScreenState createState() => AdminCuisineTypeScreenState();
}

class AdminCuisineTypeScreenState extends State<AdminCuisineTypeScreen> {
  TextEditingController cuisineController = TextEditingController();

  FocusNode cuisineFocus = FocusNode();

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
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: kIsWeb
          ? null
          : appBarWidget(
              language!.addCuisine,
              elevation: 0,
              actions: [
                IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) {
                        return AlertDialog(
                          title: Text(language!.addCuisine, style: primaryTextStyle()),
                          content: AppTextField(
                            autoFocus: true,
                            controller: cuisineController,
                            textFieldType: TextFieldType.MULTILINE,
                            decoration: inputDecorationRecipe(context, labelTextName: language!.egChinese),
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: Text(language!.cancel),
                              onPressed: () {
                                finish(context);
                              },
                            ),
                            TextButton(
                              child: Text(language!.ok),
                              onPressed: () async {
                                if (appStore.isDemoAdmin) {
                                  snackBar(context, title: language!.demoUserMsg);
                                } else {
                                  if (cuisineController.text.isNotEmpty) {
                                    Map req = {
                                      'type': RecipeTypeCuisineData,
                                      'value': toSlug(cuisineController.text.trim()),
                                      'label': cuisineController.text.trim(),
                                    };
                                    await addCuisine(req).then((value) {
                                      snackBar(context, title: language!.categorySuccessfully);
                                      finish(context);
                                      init();
                                    }).catchError((e) {
                                      log(e);
                                    });
                                  } else {
                                    snackBar(context, title: language!.pleaseEnterCuisine);
                                  }
                                }
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  icon: Icon(Icons.add, color: context.iconColor),
                )
              ],
            ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            controller: scrollController,
            child: FixSizedBox(
              maxWidth: kIsWeb ? null : context.width(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (kIsWeb)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(language!.addCuisine, style: boldTextStyle(size: 24)).expand(),
                            IconButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (_) {
                                    return AlertDialog(
                                      title: Text(language!.addCuisine, style: primaryTextStyle()),
                                      content: AppTextField(
                                        autoFocus: true,
                                        controller: cuisineController,
                                        textFieldType: TextFieldType.MULTILINE,
                                        decoration: inputDecorationRecipe(context, labelTextName: language!.egChinese),
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                          child: Text(language!.cancel),
                                          onPressed: () {
                                            finish(context);
                                          },
                                        ),
                                        TextButton(
                                          child: Text(language!.ok),
                                          onPressed: () async {
                                            if (appStore.isDemoAdmin) {
                                              snackBar(context, title: language!.demoUserMsg);
                                            } else {
                                              if (cuisineController.text.isNotEmpty) {
                                                Map req = {
                                                  'type': RecipeTypeCuisineData,
                                                  'value': toSlug(cuisineController.text.trim()),
                                                  'label': cuisineController.text.trim(),
                                                };
                                                await addCuisine(req).then((value) {
                                                  snackBar(context, title: language!.categorySuccessfully);
                                                  finish(context);
                                                  init();
                                                }).catchError((e) {
                                                  log(e);
                                                });
                                              } else {
                                                snackBar(context, title: language!.pleaseEnterCuisine);
                                              }
                                            }
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              icon: Icon(Icons.add, color: context.iconColor),
                            ),
                          ],
                        ),
                        Divider(),
                      ],
                    ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: cuisineData.map((e) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(e.label.validate(), style: primaryTextStyle()),
                          IconButton(
                            onPressed: () {
                              showConfirmDialogCustom(
                                context,
                                primaryColor: primaryColor,
                                title: language!.sureYouWantCuisine,
                                onAccept: (c) {
                                  if (appStore.isDemoAdmin) {
                                    snackBar(context, title: language!.demoUserMsg);
                                  } else {
                                    Map req = {'id': e.id};
                                    deleteCuisine(req).then((value) {
                                      snackBar(context, title: language!.cuisineHasBeenDeletedSuccessfully);
                                      init();
                                    }).catchError((e) {
                                      log(e);
                                    });
                                  }
                                },
                                dialogType: DialogType.DELETE,
                              );
                            },
                            icon: Icon(Icons.delete, color: primaryColor),
                          )
                        ],
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
          if (cuisineData.isEmpty) EmptyWidget(title: language!.emptySliderData).visible(appStore.isLoader),
          Loader().visible(mIsLoader)
        ],
      ),
    );
  }
}
