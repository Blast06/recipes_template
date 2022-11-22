import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:recipe_app/main.dart';
import 'package:recipe_app/models/RecipeStaticModel.dart';
import 'package:recipe_app/models/RecipeUtensilsModel.dart';
import 'package:recipe_app/network/RestApis.dart';
import 'package:recipe_app/utils/Colors.dart';
import 'package:recipe_app/utils/Constants.dart';
import 'package:recipe_app/utils/Widgets.dart';

class AddUtensilScreen extends StatefulWidget {
  final StepUtensil? model;

  AddUtensilScreen({this.model});

  @override
  AddUtensilScreenState createState() => AddUtensilScreenState();
}

class AddUtensilScreenState extends State<AddUtensilScreen> {
  ScrollController scrollController = ScrollController();

  TextEditingController utensilController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController specialUSeController = TextEditingController();

  FocusNode utensilFocus = FocusNode();

  int totalPage = 1;
  int currentPage = 1;
  int mPage = 1;

  bool mIsUpdate = false;
  bool mIsLastPage = false;
  bool mIsSearch = false;
  bool mIsSearchListVisible = false;

  String specialUseValue = 'optional';

  List<String> specialUser = ['optional', 'for serving'];

  List<CuisineData> list = [];
  List<CuisineData> items = [];

  @override
  void initState() {
    super.initState();
    init();
    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        if (!mIsLastPage) {
          appStore.setLoading(true);
          mPage++;
          setState(() {});

          init();
        }
      }
    });
  }

  void init() async {
    mIsUpdate = widget.model != null;

    if (mIsUpdate) {
      utensilController.text = widget.model!.name!;
      amountController.text = widget.model!.amount!.toString();
      specialUSeController.text = widget.model!.special_use!;
    }
    afterBuildCreated(() {
      addCuisineData(page: mPage, type: RecipeTypeUtensils, keyword: '').then((value) {
        appStore.setLoading(false);
        mIsLastPage = value.data!.length != value.pagination!.per_page;

        totalPage = value.pagination!.totalPages!;
        currentPage = value.pagination!.currentPage!;

        if (mPage == 1) {
          list.clear();
        }
        list.addAll(value.data!);

        setState(() {});
      }).catchError((error) {
        appStore.setLoading(false);
        toast(error.toString());
      });
    });
  }

  void filterSearchResults() {
    addCuisineData(keyword: utensilController.text.trim(), type: RecipeTypeIngredients).then((value) {
      List<CuisineData> dummySearchList = [];
      dummySearchList.addAll(value.data!);
      if (utensilController.text.trim().isNotEmpty) {
        List<CuisineData> dummyListData = [];
        dummySearchList.forEach((item) {
          if (item.label!.toLowerCase().contains(utensilController.text.trim().toLowerCase())) {
            dummyListData.add(item);
          }
        });
        setState(() {
          items.clear();
          items.addAll(dummyListData);
        });
      } else {
        setState(() {
          items.clear();
          items.addAll(list);
        });
      }
    }).catchError((error) {
      log(error.toString());
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
      appBar: appBarWidget(
        mIsUpdate ? language!.updateUtensil : language!.addUtensil,
        actions: [
          IconButton(
            onPressed: () async {
              StepUtensil model = StepUtensil();

              model.name = utensilController.text.trim();
              model.amount = amountController.text.trim();
              model.special_use = specialUSeController.text.trim();

              if (mIsUpdate) {
                finish(context, model);
              } else {
                finish(context, model);
              }
            },
            icon: Icon(Icons.done, color: context.iconColor, size: 30).paddingOnly(right: 16),
          )
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(language!.utensil, style: boldTextStyle()),
                AppTextField(
                  controller: utensilController,
                  maxLength: 55,
                  textFieldType: TextFieldType.OTHER,
                  decoration: inputDecorationRecipe(context, hintTextName: language!.addUtensilBakingDish),
                  onTap: () {
                    mIsSearch = true;
                    mIsSearchListVisible = false;
                  },
                  onChanged: (val) {
                    filterSearchResults();
                  },
                  onFieldSubmitted: (val) {
                    mIsSearch = false;
                    mIsSearchListVisible = true;

                    if (utensilController.text.isEmpty) {
                      context.requestFocus(utensilFocus);
                    }

                    setState(() {});
                  },
                ),
                16.height,
                ListView.builder(
                  controller: scrollController,
                  shrinkWrap: true,
                  itemCount: items.length,
                  itemBuilder: (_, index) {
                    return Container(
                      padding: EdgeInsets.all(8),
                      child: Text(items[index].label ?? '', style: primaryTextStyle()),
                    ).onTap(() {
                      utensilController.text = items[index].label!;

                      mIsSearch = false;
                      mIsSearchListVisible = true;
                      if (mIsUpdate) {
                        mIsSearch = true;
                        setState(() {});
                      }

                      hideKeyboard(context);
                      setState(() {});
                    });
                  },
                ).visible(!mIsSearchListVisible),
                Row(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(language!.amount, style: boldTextStyle()),
                        AppTextField(
                          maxLength: 5,
                          controller: amountController,
                          textFieldType: TextFieldType.PHONE,
                          textAlign: TextAlign.center,
                          decoration: inputDecorationRecipe(context, hintTextName: language!.eg52),
                        ),
                      ],
                    ).expand(),
                    16.width,
                    Column(
                      children: [
                        Text(language!.specialUse, style: boldTextStyle()),
                        AppTextField(
                          textAlign: TextAlign.center,
                          controller: specialUSeController,
                          readOnly: true,
                          textFieldType: TextFieldType.OTHER,
                          decoration: inputDecorationRecipe(context, hintTextName: language!.egChinese),
                          onTap: () async {
                            String? data = isWeb
                                ? await showDialog(
                                    context: context,
                                    builder: (_) {
                                      return AlertDialog(
                                        content: Container(
                                          margin: EdgeInsets.only(left: 16, right: 16),
                                          height: 200,
                                          width: 200,
                                          child: Column(
                                            children: [
                                              Align(
                                                alignment: Alignment.topRight,
                                                child: TextButton(
                                                  onPressed: () {
                                                    finish(context, specialUseValue);
                                                  },
                                                  child: Text(language!.save, style: boldTextStyle(color: primaryColor)),
                                                ),
                                              ),
                                              8.height,
                                              Divider(color: grey),
                                              8.height,
                                              CupertinoTheme(
                                                data: CupertinoThemeData(
                                                  textTheme: CupertinoTextThemeData(
                                                    pickerTextStyle: primaryTextStyle(),
                                                  ),
                                                ),
                                                child: Container(
                                                  height: 90,
                                                  child: CupertinoPicker(
                                                    scrollController: FixedExtentScrollController(initialItem: specialUser.indexOf(specialUseValue)),
                                                    itemExtent: 30,
                                                    children: specialUser.map((e) {
                                                      return Text(e, style: primaryTextStyle(size: 20));
                                                    }).toList(),
                                                    onSelectedItemChanged: (int val) {
                                                      specialUseValue = specialUser[val];
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    })
                                : await showModalBottomSheet(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Container(
                                        margin: EdgeInsets.only(left: 16, right: 16),
                                        height: context.height() * 0.3,
                                        width: context.width(),
                                        child: Column(
                                          children: [
                                            Align(
                                              alignment: Alignment.topRight,
                                              child: TextButton(
                                                onPressed: () {
                                                  finish(context, specialUseValue);
                                                },
                                                child: Text(language!.save, style: boldTextStyle(color: primaryColor)),
                                              ),
                                            ),
                                            8.height,
                                            Divider(color: grey),
                                            8.height,
                                            CupertinoTheme(
                                              data: CupertinoThemeData(
                                                textTheme: CupertinoTextThemeData(
                                                  pickerTextStyle: primaryTextStyle(),
                                                ),
                                              ),
                                              child: Container(
                                                height: 90,
                                                child: CupertinoPicker(
                                                  scrollController: FixedExtentScrollController(initialItem: specialUser.indexOf(specialUseValue)),
                                                  itemExtent: 30,
                                                  children: specialUser.map((e) {
                                                    return Text(e, style: primaryTextStyle(size: 20));
                                                  }).toList(),
                                                  onSelectedItemChanged: (int val) {
                                                    specialUseValue = specialUser[val];
                                                  },
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                            if (data != null) {
                              specialUseValue = data;
                              specialUSeController.text = specialUseValue;
                              setState(() {});
                            }
                          },
                        ).paddingOnly(bottom: 22),
                      ],
                    ).expand()
                  ],
                ).visible((!mIsSearch && mIsSearchListVisible) || mIsUpdate && !mIsUpdate)
              ],
            ),
          ),
          Observer(builder: (_) => Loader().visible(appStore.isLoader))
        ],
      ),
    );
  }
}
