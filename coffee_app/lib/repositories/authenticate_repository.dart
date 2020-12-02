import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticateRepository {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['email']);

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
    User user;
    PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
        verificationId: verificationId.toString(), smsCode: smsCode);

    await auth
        .signInWithCredential(phoneAuthCredential)
        .then((result) => {user = result.user});
    return user;
  }

  Future<User> logInWithGoogle() async {
    User user;
    final googleUser = await googleSignIn.signIn();
    try {
      if (googleUser != null) {
        final googleAuth = await googleUser.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        await auth.signInWithCredential(credential)
        .then((result) => {user = result.user});
      }
    } on Exception {
      return null;
    }
    return user;
  }

  Future<void> logOut() async {
    try {
      await Future.wait([
        auth.signOut(),
      ]);
    } on Exception {
      //throw LogOutFailure();
    }
  }
}
