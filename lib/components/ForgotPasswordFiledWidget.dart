import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:recipe_app/network/RestApis.dart';
import 'package:recipe_app/utils/Colors.dart';
import 'package:recipe_app/utils/Widgets.dart';

import '../main.dart';

class ForgotPasswordFiledWidget extends StatefulWidget {
  const ForgotPasswordFiledWidget({Key? key}) : super(key: key);

  @override
  _ForgotPasswordFiledWidgetState createState() => _ForgotPasswordFiledWidgetState();
}

class _ForgotPasswordFiledWidgetState extends State<ForgotPasswordFiledWidget> {
  GlobalKey<FormState> formKey = GlobalKey();

  TextEditingController forgotEmailController = TextEditingController();

  Future<void> submit() async {
    if (formKey.currentState!.validate()) {
      Map req = {
        'email': forgotEmailController.text.trim(),
      };
      appStore.setLoading(true);

      await forgotPassword(req).then((value) {
        snackBar(context, title: value.message.validate());

        appStore.setLoading(false);

        finish(context);
      }).catchError((error) {
        appStore.setLoading(false);

        toast(error.toString());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          40.height,
          AppTextField(
            controller: forgotEmailController,
            textFieldType: TextFieldType.EMAIL,
            decoration: inputDecorationRecipe(context, labelTextName: language!.email),
          ),
          16.height,
          AppButton(
            shapeBorder: RoundedRectangleBorder(borderRadius: radius(defaultRadius)),
            color: primaryColor,
            width: context.width(),
            onTap: () {
              submit();
            },
            text: language!.sendYourPassword,
            textStyle: boldTextStyle(color: white),
          ),
        ],
      ).paddingOnly(left: 16, right: 16),
    );
  }
}
