import 'package:flutter/material.dart';
import 'package:coffee_app/ui/home.dart';

class CartNoItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/emptycart.jpg',
            height: MediaQuery.of(context).size.height / 3,
          ),
          Padding(
            padding: EdgeInsets.only(top: 10.0),
            child: Text(
              'Đơn hàng của bạn chưa có món nào',
              style: TextStyle(fontSize: 24),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20),
            child: Container(
                margin: EdgeInsets.only(left: 30, right: 30),
                height: MediaQuery.of(context).size.height * 0.1,
                child: RaisedButton(
                  child: Text(
                    "Chọn món ngay",
                    style: TextStyle(fontSize: 24),
                  ),
                  color: Color.fromRGBO(112, 170, 48, 1.0),
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HomePage(
                                  currentIndex: 1,
                                )),
                        (route) => false);
                  },
                )),
          )
        ],
      ),
    );
  }
}
