import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:recipe_app/components/FixSizedBox.dart';
import 'package:recipe_app/main.dart';
import 'package:recipe_app/utils/Colors.dart';
import 'package:recipe_app/utils/Common.dart';
import 'package:recipe_app/utils/Constants.dart';

class AboutAppScreen extends StatefulWidget {
  @override
  AboutAppScreenState createState() => AboutAppScreenState();
}

class AboutAppScreenState extends State<AboutAppScreen> {
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
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: kIsWeb ? null : appBarWidget(language!.about, elevation: 0),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: 16, bottom: 16),
        child: FixSizedBox(
          maxWidth: kIsWeb ? null : context.width(),
          child: Container(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(mAppName, style: primaryTextStyle(size: 30)),
                16.height,
                Container(
                  decoration: BoxDecoration(color: primaryColor, borderRadius: radius(defaultRadius)),
                  height: 4,
                  width: 100,
                ),
                16.height,
                Text(language!.version, style: secondaryTextStyle()),
                Text('${packageInfo.versionName}', style: primaryTextStyle()),
                16.height,
                Text(
                  mAppInfo,
                  style: primaryTextStyle(size: 14),
                  textAlign: TextAlign.justify,
                ),
                16.height,
                AppButton(
                  shapeBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(defaultRadius)),
                  color: appStore.isDarkMode ? scaffoldSecondaryDark : primaryColor,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.contact_support_outlined, color: context.iconColor),
                      8.width,
                      Text(language!.purchase, style: boldTextStyle()),
                    ],
                  ),
                  onTap: () {
                    launchUrl(iqonicURL);
                    //launchUrl('mailto:${getStringAsync(CONTACT_PREF)}');
                  },
                ),
                16.height,
                AppButton(
                  color: appStore.isDarkMode ? scaffoldSecondaryDark : primaryColor,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset('images/purchase.png', height: 24, color: context.iconColor),
                      8.width,
                      Text(language!.contactUs, style: boldTextStyle()),
                    ],
                  ),
                  onTap: () {
                    launchUrl('mailto:$ContactPref');
                  },
                  shapeBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(defaultRadius)),
                ).visible(iqonicURL.isNotEmpty),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
