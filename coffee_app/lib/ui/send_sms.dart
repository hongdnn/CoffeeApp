import 'package:coffee_app/cubits/login_cubit.dart';
import 'package:coffee_app/cubits/login_state.dart';
import 'package:coffee_app/repositories/authenticate_repository.dart';
import 'package:coffee_app/ui/home.dart';
import 'package:coffee_app/ui/input_name.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cubit/flutter_cubit.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SendSMS extends StatefulWidget {
  final String phoneNumber;
  const SendSMS({this.phoneNumber});
  @override
  _SendSMSState createState() => _SendSMSState();
}

class _SendSMSState extends State<SendSMS> {
  var verificationId;
  Future<String> verifyId;
  TextEditingController smsController = TextEditingController();
  LoginCubit loginCubit;

  @override
  // ignore: missing_return
  Future<void> initState() {
    super.initState();
    loginCubit = new LoginCubit(authRepository: AuthenticateRepository());
    if (widget.phoneNumber != null) {
      requestSMS();
    }
  }

  void requestSMS() async {
    loginCubit.loginBySMS(widget.phoneNumber);
  }

  @override
  Widget build(BuildContext context) {
    return CubitListener<LoginCubit, LoginState>(
        cubit: loginCubit,
        listener: (context, state) {
          if (state is LoginSuccess) {
            User user = state.user;
            if (user.displayName != null) {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage(currentIndex: 0,)),
                  (route) => false);
            } else {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => InputName()),
                  (route) => false);
            }
          }else if(state is LoginFailure){
            Fluttertoast.showToast(
                msg: "Mã OTP không đúng",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 20);
          }
        },
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: new GestureDetector(
                onTap: () {
                  FocusScope.of(context).requestFocus(new FocusNode());
                },
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/coffeeshop.jpg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.only(top: 200.0),
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                        Padding(
                          padding: EdgeInsets.only(top: 20,left: 10),
                          child: Center(
                            child: Text(
                                "Vui lòng nhập mã OTP đã được gửi tới số điện thoại của bạn",
                                style: TextStyle(
                                    fontSize: 25,
                                    color: Colors.black)),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 40),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 2.0, color: Colors.black54)),
                              child: Padding(
                                  padding: EdgeInsets.only(bottom: 6, left: 8),
                                  child: TextFormField(
                                    controller: smsController,
                                    style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.height *
                                              0.04,
                                    ),
                                    decoration: InputDecoration(
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.never,
                                      border: InputBorder.none,
                                      errorStyle: TextStyle(fontSize: 25.0),
                                      labelText: "Mã OTP",
                                      labelStyle: TextStyle(
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.04),
                                    ),
                                    validator: (value) {
                                      if (value.trim().isEmpty) {
                                        return "Vui lòng nhập mã OTP";
                                      } else {
                                        return null;
                                      }
                                    },
                                  )),
                              height: MediaQuery.of(context).size.height * 0.08,
                              width: MediaQuery.of(context).size.width * 0.7,
                            )
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 80),
                          child: Center(
                            child: Container(
                              width: 250,
                                margin: EdgeInsets.only(left: 30, right: 30),
                                height: MediaQuery.of(context).size.height * 0.1,
                                child: RaisedButton(
                                  child: Text(
                                    "Tiếp tục",
                                    style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.height *
                                                0.04),
                                  ),
                                  color: Color.fromRGBO(112, 170, 48, 1.0),
                                  textColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0))),
                                  onPressed: () {
                                   loginCubit.credentialWithSMS(
                                        smsController.text.trim());
                                  },
                                )),
                          ),
                        )
                      ]),
                      height: MediaQuery.of(context).size.height - 200,
                      decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(50.0),
                              topRight: Radius.circular(50.0))),
                    ),
                  ),
                ))));
  }

}

