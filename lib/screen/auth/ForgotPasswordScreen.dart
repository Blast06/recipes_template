import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:recipe_app/components/ForgotPasswordFiledWidget.dart';
import 'package:recipe_app/main.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  ForgotPasswordScreenState createState() => ForgotPasswordScreenState();
}

class ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
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
    return kIsWeb
        ? ForgotPasswordFiledWidget()
        : Scaffold(
            appBar: appBarWidget(language!.forgotPassword),
            body: Stack(
              children: [
                SingleChildScrollView(
                  child: ForgotPasswordFiledWidget(),
                ),
                Observer(builder: (_) => Loader().visible(appStore.isLoader)),
              ],
            ),
          );
  }
}
