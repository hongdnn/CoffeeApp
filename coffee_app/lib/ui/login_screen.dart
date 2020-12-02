import 'package:coffee_app/cubits/login_cubit.dart';
import 'package:coffee_app/cubits/login_state.dart';
import 'package:coffee_app/repositories/authenticate_repository.dart';
import 'package:coffee_app/ui/send_sms.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cubit/flutter_cubit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'home.dart';
import 'input_name.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return CubitProvider(
          create: (BuildContext context) => LoginCubit(authRepository: AuthenticateRepository()),
          child: CubitListener<LoginCubit, LoginState>(
          listener: (context, state) {
            if (state is LoginSuccess) {
              User user = state.user;
              if (user.displayName != null) {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                    (route) => false);
              } else {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => InputName()),
                    (route) => false);
              }
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
                        child: ListView(children: [
                          Padding(
                            padding: EdgeInsets.only(left: 20),
                            child: Text("Vui lòng đăng nhập",
                                style: TextStyle(
                                    fontSize: 25,
                                    color: Color.fromRGBO(112, 170, 48, 1.0))),
                          ),
                          Row(
                            children: [
                              Container(
                                  margin: EdgeInsets.only(
                                      right: 10, left: 20, top: 20),
                                  width: 110,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 2.0, color: Colors.grey)),
                                  child: Padding(
                                      padding:
                                          EdgeInsets.only(bottom: 3, left: 8),
                                      child: CountryCodePicker(
                                        onChanged: print,
                                        initialSelection: 'VN',
                                        textStyle: TextStyle(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.04),
                                        showCountryOnly: false,
                                        showOnlyCountryWhenClosed: false,
                                        alignLeft: false,
                                      ))),
                              Container(
                                margin: EdgeInsets.only(top: 20),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 2.0, color: Colors.grey)),
                                child: Padding(
                                    padding: EdgeInsets.only(bottom: 6, left: 8),
                                    child: TextFormField(
                                      controller: phoneController,
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
                                        labelText: "Số điện thoại",
                                        labelStyle: TextStyle(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.04),
                                      ),
                                      validator: (value) {
                                        if (value.trim().isEmpty) {
                                          return "Vui lòng nhập số điện thoại";
                                        } else {
                                          return null;
                                        }
                                      },
                                    )),
                                height: MediaQuery.of(context).size.height * 0.08,
                                width: MediaQuery.of(context).size.width * 0.6,
                              )
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 80),
                            child: Container(
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
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => SendSMS(
                                                phoneNumber: phoneController.text
                                                    .trim())));
                                  },
                                )),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 80, left: 15),
                            child: Row(
                              children: [
                                SizedBox(
                                  height: 50,
                                  child: GoogleLoginButton(),
                                  width: 200,
                                ),
                              ],
                            ),
                          )
                        ]),
                        height: MediaQuery.of(context).size.height - 200,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(40.0),
                                topRight: Radius.circular(40.0))),
                      ),
                    ),
                  )))),
    );
  }
}

class GoogleLoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
          return RaisedButton.icon(
          label: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              'Google',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20
              ),
            ),
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          icon: const Icon(FontAwesomeIcons.google, color: Colors.white),
          color: Color.fromRGBO(112, 170, 48, 1.0),
          onPressed: () {
            //loginCubit.loginByGoogle();
            context.read<LoginCubit>().loginByGoogle();
          },
    );
  }
}
