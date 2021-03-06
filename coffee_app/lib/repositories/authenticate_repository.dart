import 'dart:async';
import 'package:coffee_app/model/response_result.dart';
import 'package:coffee_app/utils/base_api.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AuthenticateRepository {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['email']);
  final FacebookLogin facebookLogin = FacebookLogin();
  User user;

  Future<String> loginBySMS(String phone) async {
    await auth.verifyPhoneNumber(
      phoneNumber: phone,
      verificationCompleted: (PhoneAuthCredential credential) async {
        print("verify phone complete");
      },
      codeSent: (String verificationId, int resendToken) async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('VERIFY_ID', verificationId);
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
      timeout: const Duration(seconds: 60),
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          print('Số điện thoại không đúng.');
        }
      },
    );
    return null;
  }

  Future<User> credentialWithSMS(String verificationId, String smsCode) async {
    try {
      PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
          verificationId: verificationId.toString(), smsCode: smsCode);
      await auth
          .signInWithCredential(phoneAuthCredential)
          .then((result) => {user = result.user});
      return user;
    } on Exception {
      return null;
    }
  }

  Future<User> logInWithGoogle() async {
    final googleUser = await googleSignIn.signIn();
    try {
      if (googleUser != null) {
        final googleAuth = await googleUser.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        await auth
            .signInWithCredential(credential)
            .then((result) => {user = result.user});
        return user;
      }
    } on Exception {
      return null;
    }
    return null;
  }

  Future<User> logInWithFacebook() async {
    FacebookLoginResult facebookLoginResult = await handleFBSignIn();
    if (facebookLoginResult.status == FacebookLoginStatus.Success) {
      try {
        final accessToken = facebookLoginResult.accessToken.token;
        final credential = FacebookAuthProvider.credential(accessToken);
        await auth
            .signInWithCredential(credential)
            .then((result) => {user = result.user});
        return user;
      } on Exception catch (e) {
        print(e.toString());
        return null;
      }
    }
    return null;
  }

  Future<FacebookLoginResult> handleFBSignIn() async {
    FacebookLoginResult facebookLoginResult =
        await facebookLogin.logIn(permissions: [
      FacebookPermission.publicProfile,
      FacebookPermission.email,
      FacebookPermission.userPhotos
    ]);
    switch (facebookLoginResult.status) {
      case FacebookLoginStatus.Success:
        print("Success");
        break;
      case FacebookLoginStatus.Cancel:
        print("Cancelled");
        break;
      case FacebookLoginStatus.Error:
        print("Error");
        break;
    }
    return facebookLoginResult;
  }

  Future<String> insertNewUser(User user) async {
    // Dio dio = new Dio();
    var baseApi = BaseApi(true, false);
    var identifier;
    if (user.providerData[user.providerData.length - 1].providerId == 'phone') {
      identifier = user.phoneNumber;
    } else {
      identifier = user.email;
    }
    try {
      final Response response = await baseApi.dio.post('/users', data: {
        'userId': user.uid,
        'fullname': user.displayName,
        'identifier': identifier,
        'providerId':
            user.providerData[user.providerData.length - 1].providerId,
        'image': user.photoURL,
      });
      final responseResult =
          ResponseResult.fromJson(json.decode(response.data));
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('ACCESS_TOKEN', responseResult.accessToken);
      await prefs.setString('REFRESH_TOKEN', responseResult.refreshToken);
      BaseApi.jwt = responseResult.accessToken;
      return responseResult.accessToken;
    } on DioError catch (e) {
      print(e.error);
    }
    return null;
  }

  Future<User> logOut() async {
    try {
      if (auth
              .currentUser
              .providerData[auth.currentUser.providerData.length - 1]
              .providerId ==
          "google.com") {
        await googleSignIn.signOut();
      }
      if (auth
              .currentUser
              .providerData[auth.currentUser.providerData.length - 1]
              .providerId ==
          "facebook.com") {
        await facebookLogin.logOut();
      }
      await auth.signOut().then((value) => user = auth.currentUser);
      return user;
    } on Exception {
      print("logout failed");
    }
    return auth.currentUser;
  }
}
