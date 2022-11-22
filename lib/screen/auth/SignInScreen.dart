import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:recipe_app/components/FixSizedBox.dart';
import 'package:recipe_app/main.dart';
import 'package:recipe_app/network/AuthService.dart';
import 'package:recipe_app/network/RestApis.dart';
import 'package:recipe_app/screen/DashboardScreen.dart';
import 'package:recipe_app/screen/DashboardWebScreen.dart';
import 'package:recipe_app/screen/auth/ForgotPasswordScreen.dart';
import 'package:recipe_app/screen/auth/SignUpScreen.dart';
import 'package:recipe_app/utils/Colors.dart';
import 'package:recipe_app/utils/Constants.dart';
import 'package:recipe_app/utils/Widgets.dart';

class SignInScreen extends StatefulWidget {
  @override
  SignInScreenState createState() => SignInScreenState();
}

class SignInScreenState extends State<SignInScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();

  FocusNode emailFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();

  bool mIsDemoUser = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    //
  }

  void toggleDemoUser() {
    if (mIsDemoUser) {
      emailController.text = 'demo@admin.com';
      passController.text = '12345678';
    } else {
      emailController.text = '';
      passController.text = '';
    }
  }

  Future<void> signIn() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      hideKeyboard(context);

      appStore.setLoading(true);

      Map req = {
        'email': emailController.text,
        'password': passController.text,
        "login_type": LoginTypeApp,
      };

      await logInApi(req).then((value) async {
        appStore.setLoading(false);

        if (isWeb) {
          DashboardWebScreen().launch(context, isNewTask: true);
        } else {
          DashboardScreen().launch(context, isNewTask: true);
        }

        appStore.setLogin(true);
      }).catchError((e) {
        appStore.setLoading(false);

        toast(e.toString());
      });
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
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
                  margin: EdgeInsets.symmetric(vertical: kIsWeb ? 16 : 0),
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
                            commonCachedNetworkImage(appStore.isDarkMode ? loginBGImage1 : loginBGImage, height: 250, width: context.width(), fit: BoxFit.cover),
                            commonCachedNetworkImage(appStore.isDarkMode ? loginImage : loginImage1, height: 150, width: context.width(), fit: BoxFit.contain),
                          ],
                        ),
                        16.height,
                        Text(language!.loginToYourAccount, style: boldTextStyle()),
                        16.height,
                        Column(
                          children: [
                            Column(
                              children: [
                                AppTextField(
                                  controller: emailController,
                                  focus: emailFocus,
                                  nextFocus: passwordFocus,
                                  textFieldType: TextFieldType.EMAIL,
                                  textInputAction: TextInputAction.next,
                                  errorThisFieldRequired: language!.thisFieldIsRequired,
                                  decoration: inputDecorationRecipe(context, labelTextName: language!.email),
                                ),
                                16.height,
                                AppTextField(
                                  controller: passController,
                                  focus: passwordFocus,
                                  textFieldType: TextFieldType.PASSWORD,
                                  errorMinimumPasswordLength: language!.passwordLengthShouldBeMoreThan,
                                  textInputAction: TextInputAction.done,
                                  errorThisFieldRequired: language!.thisFieldIsRequired,
                                  decoration: inputDecorationRecipe(context, labelTextName: language!.password),
                                  onFieldSubmitted: (val) {
                                    hideKeyboard(context);
                                    signIn();
                                  },
                                ),
                              ],
                            ).paddingSymmetric(horizontal: 16),
                            16.height,
                            CheckboxListTile(
                              value: mIsDemoUser,
                              onChanged: (v) {
                                mIsDemoUser = !mIsDemoUser;
                                setState(() {});

                                toggleDemoUser();
                              },
                              title: Text(language!.loginWithAdminDemo, style: secondaryTextStyle()),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                child: Text('${language!.forgotPassword}?', style: boldTextStyle(color: primaryColor)),
                                onPressed: () async {
                                  if (kIsWeb) {
                                    await showDialog(
                                      context: context,
                                      builder: (_) {
                                        return AlertDialog(
                                          title: Row(
                                            children: [
                                              Text(
                                                language!.forgotPassword,
                                                style: boldTextStyle(size: 18),
                                              ).expand(),
                                              IconButton(onPressed: () => finish(context), icon: Icon(Icons.close), color: context.iconColor)
                                            ],
                                          ),
                                          content: SizedBox(
                                            width: context.width() * 0.3,
                                            child: ForgotPasswordScreen(),
                                          ),
                                        );
                                      },
                                    );
                                  } else {
                                    ForgotPasswordScreen().launch(context, duration: Duration(milliseconds: 300));
                                  }
                                },
                              ),
                            ).paddingOnly(right: 16, bottom: 16),
                            AppButton(
                              shapeBorder: RoundedRectangleBorder(borderRadius: radius(defaultRadius)),
                              color: primaryColor,
                              width: context.width(),
                              onTap: () {
                                signIn();
                              },
                              text: language!.signIn,
                              textStyle: boldTextStyle(color: white),
                            ).paddingSymmetric(horizontal: 16),
                            16.height,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(language!.alreadyHaveAnAccount, style: secondaryTextStyle()),
                                4.width,
                                TextButton(
                                  onPressed: () {
                                    SignUpScreen().launch(context, duration: Duration(milliseconds: 300));
                                  },
                                  child: Text(language!.signUp, style: boldTextStyle(color: context.primaryColor)),
                                )
                              ],
                            ),
                            if (isMobile) Text(language!.orLoginWithGoogle, style: secondaryTextStyle()).center(),
                            8.height,
                            if (isMobile)
                              AppButton(
                                elevation: 3,
                                onTap: () async {
                                  appStore.setLoading(true);

                                  await signInWithGoogle().then((value) {
                                    DashboardScreen().launch(context, isNewTask: true);
                                    appStore.setLoading(false);
                                  }).catchError((e) {
                                    appStore.setLoading(false);
                                    toast(e.toString());
                                  });
                                },
                                child: GoogleLogoWidget(),
                                shapeBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(defaultRadius)),
                              ),
                          ],
                        ),
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
    );
  }
}
