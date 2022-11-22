import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:recipe_app/main.dart';
import 'package:recipe_app/network/RestApis.dart';
import 'package:recipe_app/utils/Colors.dart';
import 'package:recipe_app/utils/Constants.dart';
import 'package:recipe_app/utils/Widgets.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  EditProfileScreenState createState() => EditProfileScreenState();
}

class EditProfileScreenState extends State<EditProfileScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailNameController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  FocusNode nameFocus = FocusNode();
  FocusNode emailFocus = FocusNode();
  FocusNode bioFocus = FocusNode();
  FocusNode dateFocus = FocusNode();

  XFile? image;
  Uint8List? profileImg;

  late DateTime userDateOfBirth;

  List name = ['Male', 'Female'];
  List icons = ['images/ic_male.png', 'images/ic_female.png'];

  String? gender;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    nameController.text = appStore.userName.validate();
    emailNameController.text = appStore.userEmail.validate();
    bioController.text = getStringAsync(BIO).validate();
    dateController.text = getStringAsync(DOB).validate();
    gender = getStringAsync(GENDER).isNotEmpty ? getStringAsync(GENDER).validate() : '';
  }

  Future getImage() async {
    if (isWeb) {
      getImageWeb();
    } else {
      image = null;
      image = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 100);

      setState(() {});
    }
  }

  Widget profileImage() {
    if (image != null) {
      return Image.file(File(image!.path), height: 100, width: 100, fit: BoxFit.cover, alignment: Alignment.center).cornerRadiusWithClipRRect(100).center();
    } else {
      return commonCachedNetworkImage(getStringAsync(USER_PHOTO_URL), fit: BoxFit.cover, height: 100, width: 100).cornerRadiusWithClipRRect(100).center();
    }
  }

  void getImageWeb() async {
    image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      profileImg = await image!.readAsBytes();
    } else {
      final List<int> codeUnits = getStringAsync(USER_PHOTO_URL).codeUnits;
      final Uint8List unit8List = Uint8List.fromList(codeUnits);

      profileImg = unit8List;
    }

    setState(() {});
  }

  recipeImageWidget() {
    if (image != null) {
      return Column(
        children: [
          Image.network(image!.path, width: 150, height: 150, fit: BoxFit.cover, alignment: Alignment.center).cornerRadiusWithClipRRect(50).center(),
          8.height,
          TextButton(
            onPressed: () async {
              getImage();
            },
            child: Text(language!.changeImage),
          )
        ],
      );
    } else {
      return commonCachedNetworkImage(appStore.userImageUrl, fit: BoxFit.cover, height: 150, width: 150).cornerRadiusWithClipRRect(100).center();
    }
  }

  pickDate() async {
    DateTime? time = await showDatePicker(
      context: context,
      initialDate: getStringAsync(DOB) == '' ? DateTime.now() : DateFormat('yyyy-MM-dd').parse(getStringAsync(DOB).validate()),
      // initialDate: userDateOfBirth,
      firstDate: DateTime(DateTime.now().year - 30),
      lastDate: DateTime(DateTime.now().year + 1),
      builder: (BuildContext context, Widget? child) {
        return Theme(data: appStore.isDarkMode ? ThemeData.dark() : ThemeData.light(), child: child!);
      },
    );
    if (time != null) {
      setState(() {
        userDateOfBirth = time;
        dateController.text = DateFormat('yyyy-MM-dd').format(userDateOfBirth);
      });
    }
  }

  submit() async {
    appStore.setLoading(true);
    hideKeyboard(context);

    await updateProfile(
      fileWeb: profileImg != null ? profileImg : null,
      file: image != null ? File(image!.path) : null,
      name: nameController.text.trim().validate(),
      userEmail: emailNameController.text.trim().validate(),
      bio: bioController.text.trim().validate(),
      dob: dateController.text.trim().validate(),
      gender: gender.validate(),
    ).then((value) {
      appStore.setLoading(false);
      toast(language!.profileUpdateSuccessfully);
    }).catchError((error) {
      appStore.setLoading(false);
      toast(error.toString());
    });
    finish(context);
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: kIsWeb ? null : appBarWidget(language!.editProfile, elevation: 0),
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (kIsWeb) ...[
                  Text(language!.editProfile, style: boldTextStyle(size: 24)).paddingBottom(16),
                  Divider(),
                  16.height,
                ],
                Stack(
                  children: [
                    isWeb ? recipeImageWidget() : profileImage(),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        margin: EdgeInsets.only(top: 55, left: 70),
                        padding: EdgeInsets.all(8),
                        decoration: boxDecorationWithRoundedCorners(boxShape: BoxShape.circle, backgroundColor: grey.withOpacity(0.3)),
                        child: Icon(Icons.edit, color: context.iconColor, size: 14),
                      ).onTap(() {
                        getImage();
                      }),
                    )
                  ],
                ),
                16.height,
                AppTextField(
                  enabled: getBoolAsync(IS_SOCIAL_LOGIN) ? false : true,
                  controller: nameController,
                  textFieldType: TextFieldType.NAME,
                  decoration: inputDecorationRecipe(context, labelTextName: language!.name),
                ),
                16.height,
                AppTextField(
                  enabled: false,
                  controller: emailNameController,
                  textFieldType: TextFieldType.NAME,
                  decoration: inputDecorationRecipe(context, labelTextName: language!.email),
                ),
                16.height,
                AppTextField(
                  controller: bioController,
                  minLines: 3,
                  maxLines: 3,
                  textFieldType: TextFieldType.NAME,
                  decoration: inputDecorationRecipe(context, labelTextName: language!.bio).copyWith(
                    alignLabelWithHint: true,
                  ),
                ),
                16.height,
                AppTextField(
                  readOnly: true,
                  controller: dateController,
                  textFieldType: TextFieldType.NAME,
                  decoration: inputDecorationRecipe(context, labelTextName: language!.dateOfBirth),
                  onTap: () {
                    pickDate();
                  },
                ),
                16.height,
                Text(language!.gender, style: primaryTextStyle()),
                16.height,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: name.map((e) {
                    int index = name.indexOf(e);
                    return Container(
                      width: context.width() / 2 - 24,
                      decoration: BoxDecoration(
                        border: Border.all(color: gender == e ? primaryColor : viewLineColor),
                        borderRadius: radius(defaultRadius),
                        color: gender == e ? primaryColor.withAlpha(50) : context.cardColor,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          8.height,
                          Image.asset(icons[index], height: 26, width: 26, fit: BoxFit.cover).paddingAll(8),
                          Text(e, style: boldTextStyle()),
                          8.height,
                        ],
                      ),
                    ).onTap(() {
                      gender = e;
                      setState(() {});
                    }, borderRadius: radius(defaultRadius));
                  }).toList(),
                ),
                16.height,
                AppButton(
                  text: language!.save,
                  textStyle: boldTextStyle(color: white),
                  onTap: () {
                    if (appStore.isDemoAdmin) {
                      snackBar(context, title: language!.demoUserMsg);
                    } else {
                      submit();
                    }
                  },
                  width: context.width(),
                  color: primaryColor,
                  shapeBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(defaultRadius)),
                ),
              ],
            ),
          ),
          Observer(builder: (_) => Loader().visible(appStore.isLoader)),
        ],
      ),
    );
  }
}
