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
      if (result.displayName == null) {
        emit(LoginSuccess(user: result));
      } else {
        emit(LoginInProgress());
        var token = await authRepository.insertNewUser(result);
        if (token != null) {
          emit(LoginSuccess(user: result));
        } else {
          emit(LoginFailure());
        }
      }
    } else {
      emit(LoginFailure());
    }
  }

  void loginByGoogle() async {
    var result = await authRepository.logInWithGoogle();
    if (result != null) {
      emit(LoginInProgress());
      var token = await authRepository.insertNewUser(result);
      if (token != null) {
        emit(LoginSuccess(user: result));
      } else {
        emit(LoginFailure());
      }
    } else {
      emit(LoginFailure());
    }
  }

  void loginByFacebook() async {
    var result = await authRepository.logInWithFacebook();
    if (result != null) {
      emit(LoginInProgress());
      var token = await authRepository.insertNewUser(result);
      if (token != null) {
        emit(LoginSuccess(user: result));
      } else {
        emit(LoginFailure());
      }
    } else {
      emit(LoginFailure());
    }
  }

  void logOut() async {
    var result = await authRepository.logOut();
    if (result != null) {
      emit(LogoutFailure(user: result));
    } else {
      emit(LogoutSuccess(user: result));
    }
  }
}
