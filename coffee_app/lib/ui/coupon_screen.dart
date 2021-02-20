import 'package:coffee_app/common/stateless_widget/cart_header.dart';
import 'package:coffee_app/common/stateless_widget/coupon_detail.dart';
import 'package:coffee_app/model/coupon.dart';
import 'package:coffee_app/repositories/load_data_repository.dart';
import 'package:flutter/material.dart';

class CouponScreen extends StatelessWidget {
  Future<List<Coupon>> coupons;
  final repo = LoadDataRepository();

  void getCoupons() {
    coupons = repo.getAllCoupons();
  }

  @override
  Widget build(BuildContext context) {
    getCoupons();
    final totalPrice = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CartHeader('Voucher của bạn'),
          FutureBuilder(
              future: coupons,
              builder:
                  (BuildContext context, AsyncSnapshot<List<Coupon>> snapshot) {
                if (snapshot.hasData) {
                  return Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding:
                              EdgeInsets.only(top: 30, bottom: 30, left: 20),
                          child: Text(
                            'Các voucher khuyến mãi',
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                        ),
                        for (var coupon in snapshot.data)
                          Container(
                            padding: EdgeInsets.only(top: 30, bottom: 30),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Color.fromRGBO(112, 170, 48, 1.0)),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                color: Colors.white),
                            margin: EdgeInsets.all(10),
                            child: ListTile(
                              leading: Image.network(
                                coupon.image,
                                width: 70,
                                height: 70,
                                fit: BoxFit.fill,
                              ),
                              title: Text(
                                coupon.title,
                                style: TextStyle(fontSize: 20),
                              ),
                              onTap: () {
                                showModalBottomSheet(
                                    context: context,
                                    routeSettings:
                                        RouteSettings(arguments: totalPrice),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(25.0)),
                                    ),
                                    isScrollControlled: true,
                                    builder: (BuildContext context) {
                                      return CouponDetail(coupon, false);
                                    });
                              },
                            ),
                          ),
                      ],
                    ),
                  );
                }
                return Container(
                  width: 0,
                  height: 0,
                );
              })
        ],
      ),
    );
  }
}
