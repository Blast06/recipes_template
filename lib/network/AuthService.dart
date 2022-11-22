import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:recipe_app/main.dart';
import 'package:recipe_app/network/RestApis.dart';
import 'package:recipe_app/utils/Constants.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();

Future<User> signInWithGoogle() async {
  GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();

  if (googleSignInAccount != null) {
    final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final UserCredential authResult = await _auth.signInWithCredential(credential);
    final User user = authResult.user!;

    assert(!user.isAnonymous);
    //assert(await user.getIdToken() != null);

    final User currentUser = _auth.currentUser!;
    assert(user.uid == currentUser.uid);

    signOutGoogle();

    await appStore.setUserImageUrl(USER_PHOTO_URL, isInitialization: true);

    // await setValue(USER_PHOTO_URL, currentUser.photoURL);

    Map req = {
      "email": currentUser.email,
      "name": currentUser.displayName,
      "username": currentUser.displayName,
      "accessToken": googleSignInAuthentication.accessToken,
      "login_type": LoginTypeGoogle,
      'image': currentUser.photoURL,
      "social_image": currentUser.photoURL,
    };

    return await logInApi(req, isSocialLogin: true).then((value) {
      return currentUser;
    }).catchError((e) {
      log(e);

      throw errorSomethingWentWrong;
    });
  } else {
    throw errorSomethingWentWrong;
  }
}

Future<void> signOutGoogle() async {
  await googleSignIn.signOut();
}

Future<void> loginWithOTP(BuildContext context, String phoneNumber) async {
  return await _auth.verifyPhoneNumber(
    phoneNumber: phoneNumber,
    verificationCompleted: (PhoneAuthCredential credential) async {},
    verificationFailed: (FirebaseAuthException e) {
      if (e.code == 'invalid-phone-number') {
        toast('The provided phone number is not valid.');
        throw 'The provided phone number is not valid.';
      } else {
        toast(e.toString());
        throw e.toString();
      }
    },
    codeSent: (String verificationId, int? resendToken) async {
      finish(context);
      // await showInDialog(context, builder:(context)=> OTPDialog(verificationId: verificationId, isCodeSent: true, phoneNumber: phoneNumber), barrierDismissible: false);
    },
    codeAutoRetrievalTimeout: (String verificationId) {
      //
    },
  );
}

Future<void> appleLogIn() async {
  if (await TheAppleSignIn.isAvailable()) {
    AuthorizationResult result = await TheAppleSignIn.performRequests([
      AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
    ]);
    switch (result.status) {
      case AuthorizationStatus.authorized:
        log(result.credential!.email);
        if (result.credential!.email == null) {
          return await saveAppleDataWithoutEmail().then((value) {
            //
          }).catchError((e) {
            throw e;
          });
        } else {
          return await saveAppleData(result).then((value) {
            //
          }).catchError((e) {
            throw e;
          });
        }
      case AuthorizationStatus.error:
        throw ("Sign in failed: ${result.error!.localizedDescription}");
      case AuthorizationStatus.cancelled:
        throw ('User cancelled');
    }
  } else {
    throw ('Apple SignIn is not available for your device');
  }
}

Future<void> saveAppleDataWithoutEmail() async {
  var req = {
    'email': getStringAsync('appleEmail'),
    'firstName': getStringAsync('appleGivenName'),
    'lastName': getStringAsync('appleFamilyName'),
    'photoURL': '',
    'accessToken': '12345678',
    'loginType': LoginTypeApple,
  };

  /* return await login(req, isSocialLogin: true).then((value) {
    log(value);
  }).catchError((e) {
    throw e;
  });*/
}

Future<void> saveAppleData(AuthorizationResult result) async {
  await setValue('appleEmail', result.credential!.email);
  await setValue('appleGivenName', result.credential!.fullName!.givenName);
  await setValue('appleFamilyName', result.credential!.fullName!.familyName);

  log('Email:- ${getStringAsync('appleEmail')}');
  log('appleGivenName:- ${getStringAsync('appleGivenName')}');
  log('appleFamilyName:- ${getStringAsync('appleFamilyName')}');

  var req = {
    'email': result.credential!.email,
    'firstName': result.credential!.fullName!.givenName,
    'lastName': result.credential!.fullName!.familyName,
    'photoURL': '',
    'accessToken': '12345678',
    'loginType': LoginTypeApple,
  };
  /*return await login(req, isSocialLogin: true).then((value) {
    log(value);
  }).catchError((e) {
    throw e;
  });*/
}
