import 'package:coffee_app/repositories/authenticate_repository.dart';
import 'package:coffee_app/ui/home.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class InputName extends StatefulWidget {
  @override
  _InputNameState createState() => _InputNameState();
}

class _InputNameState extends State<InputName> {
  Future<String> verificationId;
  TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      child: Text("Vui lòng nhập tên người dùng",
                          style: TextStyle(fontSize: 25, color: Colors.black)),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 20),
                          decoration: BoxDecoration(
                              border:
                                  Border.all(width: 2.0, color: Colors.grey)),
                          child: Padding(
                              padding: EdgeInsets.only(bottom: 6, left: 8),
                              child: TextFormField(
                                controller: nameController,
                                style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.height * 0.04,
                                ),
                                decoration: InputDecoration(
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.never,
                                  border: InputBorder.none,
                                  errorStyle: TextStyle(fontSize: 25.0),
                                  labelText: "Họ tên",
                                  labelStyle: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.height *
                                              0.04),
                                ),
                                validator: (value) {
                                  if (value.trim().isEmpty) {
                                    return "Vui lòng nhập tên người dùng";
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
                      child: Container(
                          margin: EdgeInsets.only(left: 30, right: 30),
                          height: MediaQuery.of(context).size.height * 0.1,
                          child: RaisedButton(
                            child: Text(
                              "Tiếp tục",
                              style: TextStyle(
                                  fontSize: MediaQuery.of(context).size.height *
                                      0.04),
                            ),
                            color: Color.fromRGBO(112, 170, 48, 1.0),
                            textColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0))),
                            onPressed: () {
                              navigateToNextPage();
                            },
                          )),
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
            )));
  }

  void navigateToNextPage() async {
    User user = FirebaseAuth.instance.currentUser;
    await user.updateProfile(displayName: nameController.text.trim()).whenComplete(() => {
      AuthenticateRepository().insertNewUser(user).then((result) => {
        if(result != null){
          Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (context) => HomePage(currentIndex: 0,)), (route) => false)
        }
      })
    });
    await user.reload();
  }
}
