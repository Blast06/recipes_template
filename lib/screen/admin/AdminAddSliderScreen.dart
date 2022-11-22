import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:recipe_app/components/AddSliderWidget.dart';
import 'package:recipe_app/main.dart';
import 'package:recipe_app/models/RecipeDashboardModel.dart';
import 'package:recipe_app/network/RestApis.dart';
import 'package:recipe_app/utils/Colors.dart';

class AdminAddSliderScreen extends StatefulWidget {
  final SliderData? data;

  AdminAddSliderScreen({this.data});

  @override
  AdminAddSliderScreenState createState() => AdminAddSliderScreenState();
}

class AdminAddSliderScreenState extends State<AdminAddSliderScreen> {
  bool mISUpdate = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    mISUpdate = widget.data != null;
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return kIsWeb
        ? AlertDialog(
            title: Row(
              children: [
                Text(mISUpdate ? language!.updateSlider : language!.addSlider, style: boldTextStyle(size: 24)).expand(),
                if (mISUpdate)
                  IconButton(
                    onPressed: () async {
                      await showConfirmDialogCustom(
                        context,
                        title: language!.areYouSureRemoveThisSlider,
                        dialogType: DialogType.DELETE,
                        primaryColor: primaryColor,
                        onAccept: (c) {
                          if (appStore.isDemoAdmin) {
                            snackBar(context, title: language!.demoUserMsg);
                          } else {
                            appStore.setLoading(true);
                            Map req = {
                              'id': widget.data!.id,
                            };
                            removeSliderData(req).then((value) {
                              snackBar(context, title: language!.sliderRemove);
                              appStore.setLoading(false);

                              finish(context);
                            }).catchError((error) {
                              appStore.setLoading(false);
                              log(error);
                            });
                          }
                        },
                      );
                    },
                    icon: Icon(Icons.delete, color: context.iconColor),
                  ),
                IconButton(onPressed: () => finish(context), icon: Icon(Icons.close)).paddingLeft(16),
              ],
            ),
            content: AddSliderWidget(data: widget.data),
          )
        : Scaffold(
            appBar: appBarWidget(
              mISUpdate ? language!.updateSlider : language!.addSlider,
              elevation: 0,
              titleTextStyle: boldTextStyle(),
              actions: [
                IconButton(
                  onPressed: () async {
                    await showConfirmDialogCustom(context, title: language!.areYouSureRemoveThisSlider, dialogType: DialogType.DELETE, primaryColor: primaryColor, onAccept: (c) {
                      if (appStore.isDemoAdmin) {
                        snackBar(context, title: language!.demoUserMsg);
                      } else {
                        appStore.setLoading(true);
                        Map req = {
                          'id': widget.data!.id,
                        };
                        removeSliderData(req).then((value) {
                          snackBar(context, title: language!.sliderRemove);
                          appStore.setLoading(false);

                          finish(context);
                        }).catchError((error) {
                          finish(context);
                          log("error : $error");
                        });
                      }
                    });
                  },
                  icon: Icon(Icons.delete, color: context.iconColor),
                ).visible(mISUpdate),
              ],
            ),
            body: AddSliderWidget(data: widget.data),
          );
  }
}
