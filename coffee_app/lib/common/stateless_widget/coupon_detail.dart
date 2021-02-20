import 'package:coffee_app/model/coupon.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:coffee_app/ui/shopping_cart.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CouponDetail extends StatelessWidget {
  final Coupon coupon;
  final bool used;

  CouponDetail(this.coupon, this.used);

  List<String> getDescription() {
    return coupon.description.split('//');
  }

  @override
  Widget build(BuildContext context) {
    var listDescription = getDescription();
    final totalPrice = ModalRoute.of(context).settings.arguments;
    return Container(
        height: MediaQuery.of(context).size.height * 9 / 10,
        decoration: new BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
        ),
        child: Stack(children: <Widget>[
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: Center(
                      child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Image.network(
                      coupon.image,
                      width: MediaQuery.of(context).size.width * 3 / 4,
                      fit: BoxFit.contain,
                    ),
                  )),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Center(
                    child: RaisedButton(
                      child: Text(
                        used == true ? 'Dùng sau' : 'Sử dụng mã',
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      color: Color.fromRGBO(112, 170, 48, 1.0),
                      padding: EdgeInsets.only(
                          top: 15, bottom: 15, left: 35, right: 35),
                      textColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.0))),
                      onPressed: () {
                        if (used) {
                          removeCouponFormCart(context);
                        } else {
                          if (int.parse(totalPrice.toString()) >=
                              coupon.condition) {
                            saveCouponForCart(context);
                          } else {
                            Navigator.pop(context);
                            Fluttertoast.showToast(
                                msg: "Đơn hàng ko đủ điều kiện của khuyến mãi",
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 20);
                          }
                        }
                      },
                    ),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.only(top: 20, bottom: 20, left: 20),
                    child: Row(
                      children: [
                        Text(
                          'Ngày hết hạn:',
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 15, right: 15),
                          child: Text(
                            coupon.expiryDate.split('T')[0],
                            style: TextStyle(
                                fontSize: 22,
                                color: Color.fromRGBO(58, 52, 235, 1.0)),
                          ),
                        ),
                      ],
                    )),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, bottom: 15.0),
                  child: Text(
                    'Chi tiết khuyến mãi:',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
                for (var sentence in listDescription)
                  Padding(
                      padding: EdgeInsets.only(bottom: 5, left: 20, right: 20),
                      child: Text(
                        sentence,
                        style: TextStyle(fontSize: 20),
                      )),
                Container(
                  height: 50,
                )
              ],
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Container(
              alignment: Alignment.topRight,
              decoration: new BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
              ),
              height: 50,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Padding(
                  padding:
                      const EdgeInsets.only(top: 15, right: 15, bottom: 15),
                  child: Image.asset(
                    'assets/cancel.png',
                    height: 22,
                  ),
                ),
              ),
            ),
          ),
        ]));
  }

  void saveCouponForCart(BuildContext context) async {
    var box = Hive.box('hiveBox');
    box.put('coupon', coupon);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var orderId = prefs.getInt('EXISTED_ORDER');
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => ShoppingCart(orderId: orderId)),
        ModalRoute.withName('/'));
  }

  void removeCouponFormCart(BuildContext context) async {
    var box = Hive.box('hiveBox');
    box.delete('coupon');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var orderId = prefs.getInt('EXISTED_ORDER');
    Navigator.pop(context);
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => ShoppingCart(orderId: orderId)));
  }
}
