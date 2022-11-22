import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:recipe_app/components/FixSizedBox.dart';
import 'package:recipe_app/main.dart';
import 'package:recipe_app/network/RestApis.dart';
import 'package:recipe_app/screen/DashboardScreen.dart';
import 'package:recipe_app/screen/DashboardWebScreen.dart';
import 'package:recipe_app/utils/Colors.dart';
import 'package:recipe_app/utils/Constants.dart';
import 'package:recipe_app/utils/Widgets.dart';

class SignUpScreen extends StatefulWidget {
  @override
  SignUpScreenState createState() => SignUpScreenState();
}

class SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passWordController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();

  FocusNode userNameFocus = FocusNode();
  FocusNode userFullNameFocus = FocusNode();
  FocusNode emailFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();
  FocusNode confirmPasswordFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    //
  }

  Future<void> submit() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      appStore.setLoading(true);

      Map req = {
        'name': nameController.text.trim(),
        'username': usernameController.text.trim(),
        'email': emailController.text.trim(),
        'password': passWordController.text.validate(),
        'user_type': ROLE_USER,
        'bio': "",
        'gender': "",
        'dob': "",
      };
      await signUpApi(req).then((value) async {
        appStore.setLoading(false);
        if (isWeb) {
          DashboardWebScreen().launch(context, isNewTask: true);
        } else {
          DashboardScreen().launch(context, isNewTask: true);
        }
      }).catchError((error) {
        appStore.setLoading(false);
        toast(error.toString());
      });
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
      child: WillPopScope(
        onWillPop: () async => true,
        child: Scaffold(
          body: Stack(
            children: [
              Form(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                key: formKey,
                child: FixSizedBox(
                  maxWidth: kIsWeb ? 500 : context.width(),
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: kIsWeb ? 32 : 0),
                    decoration: kIsWeb
                        ? BoxDecoration(
                            color: context.cardColor,
                            borderRadius: BorderRadius.circular(defaultRadius),
                            boxShadow: [
                              BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8.0, spreadRadius: 3.0),
                            ],
                          )
                        : null,
                    child: SingleChildScrollView(
                      padding: EdgeInsets.only(top: 16, bottom: 24),
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              commonCachedNetworkImage(
                                appStore.isDarkMode ? loginBGImage1 : loginBGImage,
                                height: context.height() * 0.35,
                                width: context.width(),
                                fit: BoxFit.cover,
                              ),
                              commonCachedNetworkImage(
                                appStore.isDarkMode ? loginImage : loginImage1,
                                height: context.height() * 0.29,
                                width: context.width(),
                                fit: BoxFit.contain,
                              ),
                            ],
                          ),
                          16.height,
                          Column(
                            children: [
                              Text(language!.signUpToYourAccount, style: boldTextStyle()),
                              16.height,
                              AppTextField(
                                controller: usernameController,
                                focus: userNameFocus,
                                nextFocus: userFullNameFocus,
                                textFieldType: TextFieldType.USERNAME,
                                errorThisFieldRequired: language!.thisFieldIsRequired,
                                decoration: inputDecorationRecipe(context, labelTextName: language!.userName),
                              ),
                              16.height,
                              AppTextField(
                                controller: nameController,
                                focus: userFullNameFocus,
                                nextFocus: emailFocus,
                                textFieldType: TextFieldType.NAME,
                                errorThisFieldRequired: language!.thisFieldIsRequired,
                                decoration: inputDecorationRecipe(context, labelTextName: language!.fullName),
                              ),
                              16.height,
                              AppTextField(
                                controller: emailController,
                                focus: emailFocus,
                                nextFocus: passwordFocus,
                                textFieldType: TextFieldType.EMAIL,
                                errorThisFieldRequired: language!.thisFieldIsRequired,
                                decoration: inputDecorationRecipe(context, labelTextName: language!.email),
                              ),
                              16.height,
                              AppTextField(
                                controller: passWordController,
                                focus: passwordFocus,
                                nextFocus: confirmPasswordFocus,
                                textFieldType: TextFieldType.PASSWORD,
                                errorThisFieldRequired: language!.thisFieldIsRequired,
                                errorMinimumPasswordLength: language!.passwordLengthShouldBeMoreThan,
                                decoration: inputDecorationRecipe(context, labelTextName: language!.password),
                                onFieldSubmitted: (val) {
                                  //
                                },
                              ),
                              16.height,
                              AppTextField(
                                controller: confirmPassController,
                                focus: confirmPasswordFocus,
                                textFieldType: TextFieldType.PASSWORD,
                                errorMinimumPasswordLength: language!.passwordLengthShouldBeMoreThan,
                                decoration: inputDecorationRecipe(context, labelTextName: language!.confirmPassword),
                                validator: (val) {
                                  if (val!.isEmpty) return language!.thisFieldIsRequired;
                                  if (val != passWordController.text)
                                    return language!.passwordDoesNotMatch;
                                  else
                                    return null;
                                },
                                onFieldSubmitted: (s) {
                                  submit();
                                },
                              ),
                              32.height,
                              AppButton(
                                shapeBorder: RoundedRectangleBorder(borderRadius: radius(defaultRadius)),
                                color: primaryColor,
                                width: context.width(),
                                onTap: () {
                                  submit();
                                },
                                text: language!.signUp,
                                textStyle: boldTextStyle(color: white),
                              ),
                              8.height,
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(language!.alreadyHaveAnAccount, style: secondaryTextStyle()),
                                  4.width,
                                  TextButton(
                                    onPressed: () {
                                      finish(context);
                                    },
                                    child: Text(language!.signIn, style: boldTextStyle(color: context.primaryColor)),
                                  )
                                ],
                              ),
                            ],
                          ).paddingOnly(left: 16, right: 16, bottom: kIsWeb ? 16 : 0)
                        ],
                      ),
                    ),
                  ),
                ).center(),
              ),
              Observer(builder: (_) => Loader().visible(appStore.isLoader)),
            ],
          ),
        ),
      ),
    );
  }
}
