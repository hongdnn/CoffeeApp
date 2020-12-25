import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  LoginState get initialState => LoginInitial();

  @override
  List<Object> get props => [];
}

class LoginInitial extends LoginState {}

class LoginInProgress extends LoginState {}

class LoginSuccess extends LoginState {
  final User user;

  const LoginSuccess({@required this.user});
}

class LoginFailure extends LoginState {

  const LoginFailure();

}

class LogoutSuccess extends LoginState {
  final User user;

  const LogoutSuccess({@required this.user});
}

class LogoutFailure extends LoginState {
  final User user;

  const LogoutFailure({@required this.user});
}