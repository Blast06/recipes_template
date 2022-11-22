import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:recipe_app/components/FixSizedBox.dart';
import 'package:recipe_app/models/AppModel.dart';
import 'package:recipe_app/utils/Colors.dart';
import 'package:recipe_app/utils/DataProvider.dart';

import '../main.dart';

class AdminSettingWebWidget extends StatefulWidget {
  @override
  AdminSettingWebWidgetState createState() => AdminSettingWebWidgetState();
}

class AdminSettingWebWidgetState extends State<AdminSettingWebWidget> {
  List<AppModel> adminSettingData = getAdminSettingData();

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
    return FixSizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(language!.adminSetting, style: boldTextStyle(size: 24)),
          32.height,
          Wrap(
            runSpacing: 24,
            spacing: 24,
            children: adminSettingData.map((e) {
              int index = adminSettingData.indexOf(e);
              return HoverWidget(
                builder: (_, isHovered) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: 160,
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    width: context.width() * 0.12,
                    decoration: BoxDecoration(
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8.0)],
                      borderRadius: BorderRadius.circular(defaultRadius),
                      color: isHovered ? primaryColor : context.cardColor,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(adminSettingData[index].icon, size: 32, color: isHovered ? Colors.white : context.iconColor),
                        16.height,
                        Text(
                          adminSettingData[index].name!,
                          style: boldTextStyle(color: isHovered ? Colors.white : context.iconColor),
                        ).paddingSymmetric(horizontal: 16),
                      ],
                    ),
                  ).onTap(() {
                    adminSettingData[index].widget!.launch(context);
                  });
                },
              );
            }).toList(),
          ),
        ],
      ),
    ).center().paddingSymmetric(vertical: 45);
  }
}
