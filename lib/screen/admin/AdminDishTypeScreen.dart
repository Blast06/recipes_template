import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:recipe_app/components/EmptyWidget.dart';
import 'package:recipe_app/components/FixSizedBox.dart';
import 'package:recipe_app/main.dart';
import 'package:recipe_app/network/RestApis.dart';
import 'package:recipe_app/utils/Colors.dart';
import 'package:recipe_app/utils/Widgets.dart';

class AdminDishTypeScreen extends StatefulWidget {
  @override
  AdminDishTypeScreenState createState() => AdminDishTypeScreenState();
}

class AdminDishTypeScreenState extends State<AdminDishTypeScreen> {
  TextEditingController dishController = TextEditingController();
  FocusNode dishFocus = FocusNode();

  ScrollController scrollController = ScrollController();

  int totalPage = 1;
  int currentPage = 1;
  int mPage = 1;

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
          setState(() {});

          init();
        }
      }
    });
    afterBuildCreated(() => appStore.setLoading(true));
  }

  void init() async {
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
              language!.addDishType,
              elevation: 0,
              actions: [
                IconButton(
                  onPressed: () async {
                    await showDialog(
                      context: context,
                      builder: (_) {
                        return AlertDialog(
                          title: Text(language!.addDishType, style: primaryTextStyle()),
                          content: AppTextField(
                            autoFocus: true,
                            controller: dishController,
                            textFieldType: TextFieldType.MULTILINE,
                            decoration: inputDecorationRecipe(context, labelTextName: language!.egSnack),
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
                              onPressed: () {
                                if (appStore.isDemoAdmin) {
                                  snackBar(context, title: language!.demoUserMsg);
                                } else {
                                  if (dishController.text.isNotEmpty) {
                                    Map req = {
                                      'name': dishController.text.trim(),
                                      'status': 1,
                                    };
                                    addDishTypeList(req).then((value) {
                                      snackBar(context, title: language!.categorySuccessfully);
                                      finish(context);
                                      init();
                                    }).catchError((e) {
                                      log(e);
                                    });
                                  } else {
                                    snackBar(context, title: language!.pleaseEnterDishType);
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
                            Text(language!.addDishType, style: boldTextStyle(size: 24)).paddingSymmetric(vertical: 16).expand(),
                            IconButton(
                              onPressed: () async {
                                await showDialog(
                                  context: context,
                                  builder: (_) {
                                    return AlertDialog(
                                      title: Text(language!.addDishType, style: primaryTextStyle()),
                                      content: AppTextField(
                                        autoFocus: true,
                                        controller: dishController,
                                        textFieldType: TextFieldType.MULTILINE,
                                        decoration: inputDecorationRecipe(context, labelTextName: language!.egSnack),
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
                                          onPressed: () {
                                            if (appStore.isDemoAdmin) {
                                              snackBar(context, title: language!.demoUserMsg);
                                            } else {
                                              if (dishController.text.isNotEmpty) {
                                                Map req = {
                                                  'name': dishController.text.trim(),
                                                  'status': 1,
                                                };
                                                addDishTypeList(req).then((value) {
                                                  snackBar(context, title: language!.categorySuccessfully);
                                                  finish(context);
                                                  init();
                                                }).catchError((e) {
                                                  log(e);
                                                });
                                              } else {
                                                snackBar(context, title: language!.pleaseEnterDishType);
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
                    children: dishTypeList.map((e) {
                      return Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(e.name.validate(), style: primaryTextStyle()),
                            IconButton(
                                onPressed: () async {
                                  await showConfirmDialogCustom(
                                    context,
                                    title: language!.removeThisCategory,
                                    primaryColor: primaryColor,
                                    onAccept: (c) {
                                      if (appStore.isDemoAdmin) {
                                        snackBar(context, title: language!.demoUserMsg);
                                      } else {
                                        Map req = {
                                          'id': e.id,
                                        };
                                        deleteDishTypeList(req).then((value) {
                                          snackBar(context, title: language!.deletedSuccessfully);
                                          init();
                                        }).catchError((e) {
                                          log(e);
                                        });
                                      }
                                    },
                                    dialogType: DialogType.DELETE,
                                  );
                                },
                                icon: Icon(Icons.delete, color: primaryColor))
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
          if (cuisineData.isEmpty) EmptyWidget(title: language!.noDataFound).visible(appStore.isLoader),
          Observer(builder: (_) => Loader().visible(appStore.isLoader)),
        ],
      ),
    );
  }
}
