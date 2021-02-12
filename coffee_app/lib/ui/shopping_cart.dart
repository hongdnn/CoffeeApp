import 'package:coffee_app/common/stateful_widget/user_order_info.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShoppingCart extends StatelessWidget {
  final currentUser = FirebaseAuth.instance.currentUser;
  var phone;
  var address;
  List a = new List();

  Future<List<String>> getUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    phone = prefs.getString('PHONE');
    address = prefs.getString('ADDRESS');
    a.add(phone);
    a.add(address);
    return a;
  }

  @override
  Widget build(BuildContext context) {
    getUserInfo();
    return Scaffold(
        body: Stack(children: <Widget>[
      SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 100, left: 20, bottom: 20),
              child: Text(
                'Thông tin khách hàng',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            FutureBuilder(
                future: getUserInfo(),
                builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
                  if (snapshot.hasData) {
                    return UserOrderInfo(
                      userName: currentUser.displayName,
                      phone: snapshot.data[0],
                      address: snapshot.data[1],
                    );
                    
                  }
                  return SizedBox();
                }),
          ],
        ),
      ),
      Align(
          alignment: Alignment.topCenter,
          child: Container(
            color: Colors.white,
            alignment: Alignment.topCenter,
            padding: EdgeInsets.only(top: 40, left: 20, bottom: 20),
            height: 100,
            child: Row(
              children: [
                GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Image.asset(
                      "assets/left_arrow.png",
                      width: 30,
                    )),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 50),
                    child: Text(
                      'Giỏ hàng của bạn',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ))
    ]));
  }
}
