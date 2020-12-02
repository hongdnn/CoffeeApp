import 'package:coffee_app/repositories/authenticate_repository.dart';
import 'package:cubit/cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthenticateRepository authRepository;

  LoginCubit({
    @required this.authRepository,
  })  : assert(authRepository != null),
        super(LoginInitial());

  void loginBySMS(String phone) async {
    emit(LoginInProgress());
    await authRepository.loginBySMS(phone);
  }

  void credentialWithSMS(String smsCode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var verificationId = prefs.getString('VERIFY_ID');
    print("id: ${verificationId.toString()}");
    var result =
        await authRepository.credentialWithSMS(verificationId, smsCode);
    if (result != null) {
      emit(LoginSuccess(user: result));
      print(result.providerData[result.providerData.length-1].providerId);
    } else {
      emit(LoginFailure());
    }
  }

  void loginByGoogle() async{
    emit(LoginInProgress());
    var result = await authRepository.logInWithGoogle();
    if (result != null) {
      emit(LoginSuccess(user: result));
      print(result.providerData[result.providerData.length-1].providerId);
    } else {
      emit(LoginFailure());
      print("failed");
    }
  }
}
