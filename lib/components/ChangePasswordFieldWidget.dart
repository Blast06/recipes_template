import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:recipe_app/network/RestApis.dart';
import 'package:recipe_app/utils/Colors.dart';
import 'package:recipe_app/utils/Widgets.dart';

import '../main.dart';

class ChangePasswordFieldWidget extends StatefulWidget {
  const ChangePasswordFieldWidget({Key? key}) : super(key: key);

  @override
  _ChangePasswordFieldWidgetState createState() => _ChangePasswordFieldWidgetState();
}

class _ChangePasswordFieldWidgetState extends State<ChangePasswordFieldWidget> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController oldPassword = TextEditingController();
  TextEditingController newPassword = TextEditingController();
  TextEditingController confNewPassword = TextEditingController();

  FocusNode newPassFocus = FocusNode();
  FocusNode conPassFocus = FocusNode();

  Future<void> submit() async {
    if (formKey.currentState!.validate()) {
      Map req = {
        'old_password': oldPassword.text.trim(),
        'new_password': newPassword.text.trim(),
      };
      appStore.setLoading(true);

      await changePassword(req).then((value) {
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
      autovalidateMode: AutovalidateMode.onUserInteraction,
      key: formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          AppTextField(
            controller: oldPassword,
            nextFocus: newPassFocus,
            textFieldType: TextFieldType.PASSWORD,
            textStyle: primaryTextStyle(color: gray),
            validator: (val) {
              if (val!.isEmpty) return language!.thisFieldIsRequired;
            },
            decoration: inputDecorationRecipe(context, labelTextName: language!.oldPassword),
          ),
          8.height,
          AppTextField(
            controller: newPassword,
            focus: newPassFocus,
            nextFocus: conPassFocus,
            textFieldType: TextFieldType.PASSWORD,
            textStyle: primaryTextStyle(color: gray),
            validator: (val) {
              if (val!.isEmpty) return language!.thisFieldIsRequired;
            },
            decoration: inputDecorationRecipe(context, labelTextName: language!.newPassword),
          ),
          16.height,
          AppTextField(
            controller: confNewPassword,
            focus: conPassFocus,
            textFieldType: TextFieldType.PASSWORD,
            textStyle: primaryTextStyle(color: gray),
            validator: (val) {
              if (val!.isEmpty) return language!.thisFieldIsRequired;
              if (val != newPassword.text) return language!.notMatchPassword;
              return null;
            },
            decoration: inputDecorationRecipe(context, labelTextName: language!.confirmPassword),
          ),
          32.height,
          AppButton(
            text: language!.changePassword,
            textStyle: boldTextStyle(color: white),
            color: primaryColor,
            width: context.width(),
            onTap: () {
              if (appStore.isDemoAdmin) {
                snackBar(context, title: language!.demoUserMsg);
              } else {
                submit();
              }
            },
            shapeBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(defaultRadius)),
          )
        ],
      ),
    );
  }
}
